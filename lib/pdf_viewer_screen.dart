import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'l10n/app_localizations.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const PdfViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFViewController? _pdfViewController;

  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = '';

  Future<void> _shareFile() async {
    final loc = AppLocalizations.of(context)!;
    try {
      await Share.shareXFiles([XFile(widget.filePath)], text: widget.fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.share_error}: $e')),
        );
      }
    }
  }

  void _jumpToPageDialog() {
    final pageTextController = TextEditingController();
    String? errorText;
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              loc.jump_to_page,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: pageTextController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '${loc.enter_page_number} (1 - $_totalPages)',
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(loc.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  final targetPage = int.tryParse(pageTextController.text);
                  if (targetPage != null && targetPage >= 1 && targetPage <= _totalPages) {
                    _pdfViewController?.setPage(targetPage - 1);
                    Navigator.pop(dialogContext);
                  } else {
                    setDialogState(() {
                      errorText = loc.invalid_page_number;
                    });
                  }
                },
                child: Text(loc.go),
              ),
            ],
          );
        },
      ),
    ).then((_) => pageTextController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_isReady) ...[
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: loc.share_file,
              onPressed: _shareFile,
            ),
            InkWell(
              onTap: _jumpToPageDialog,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PDFView(
              filePath: widget.filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              nightMode: isDark,
              defaultPage: 0,
              fitPolicy: FitPolicy.WIDTH,
              onViewCreated: (controller) {
                _pdfViewController = controller;
              },
              onRender: (pages) {
                setState(() {
                  _totalPages = pages ?? 0;
                  _isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  _errorMessage = error.toString();
                });
              },
              onPageChanged: (int? page, int? total) {
                if (page != null) {
                  setState(() => _currentPage = page);
                }
              },
            ),

            if (!_isReady && _errorMessage.isEmpty)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(loc.loading_pdf),
                  ],
                ),
              ),

            if (_errorMessage.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        '${loc.file_read_error}:\n$_errorMessage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

            if (_isReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(30),
                    color: isDark
                        ? Colors.grey[900]!.withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up),
                            tooltip: loc.previous_page,
                            onPressed: _currentPage > 0
                                ? () => _pdfViewController?.setPage(_currentPage - 1)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${_currentPage + 1} / $_totalPages',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            tooltip: loc.next_page,
                            onPressed: _currentPage < _totalPages - 1
                                ? () => _pdfViewController?.setPage(_currentPage + 1)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}