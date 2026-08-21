import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'l10n/app_localizations.dart';

// ==========================================
// أدوات مساعدة عامة للتعامل مع الترميزات
// ==========================================
String _safeDecodeBytes(List<int> bytes) {
  if (bytes.length >= 2) {
    // UTF-16 LE
    if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      final buffer = StringBuffer();
      for (int i = 2; i < bytes.length - 1; i += 2) {
        buffer.writeCharCode(bytes[i] | (bytes[i + 1] << 8));
      }
      return buffer.toString();
    }
    // UTF-16 BE
    if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      final buffer = StringBuffer();
      for (int i = 2; i < bytes.length - 1; i += 2) {
        buffer.writeCharCode((bytes[i] << 8) | bytes[i + 1]);
      }
      return buffer.toString();
    }
  }
  try {
    return utf8.decode(bytes, allowMalformed: true);
  } catch (_) {
    return latin1.decode(bytes);
  }
}

// ==========================================
// 1. قارئ ومحرر النصوص (TXT)
// ==========================================
class TxtViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const TxtViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<TxtViewerScreen> createState() => _TxtViewerScreenState();
}

class _TxtViewerScreenState extends State<TxtViewerScreen> {
  late TextEditingController _controller;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadFileContent();
  }

  Future<void> _loadFileContent() async {
    try {
      final file = File(widget.filePath);
      final bytes = await file.readAsBytes();
      final content = _safeDecodeBytes(bytes);
      if (mounted) {
        _controller.text = content;
      }
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.file_read_error}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    final loc = AppLocalizations.of(context)!;
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_controller.text, encoding: utf8);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.file_saved_success),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${loc.save_error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName, style: const TextStyle(fontSize: 16)),
        actions: [
          _isSaving
              ? const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : IconButton(
            icon: const Icon(Icons.save),
            tooltip: loc.save_changes,
            onPressed: _saveFile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 15, height: 1.6),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: loc.write_text_here,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. قارئ ومحرر ملفات الإكسل (XLSX / XLS)
// ==========================================
excel_pkg.Excel? _decodeExcelTask(List<int> bytes) {
  try {
    return excel_pkg.Excel.decodeBytes(bytes);
  } catch (_) {
    return null;
  }
}

class ExcelViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const ExcelViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<ExcelViewerScreen> createState() => _ExcelViewerScreenState();
}

class _ExcelViewerScreenState extends State<ExcelViewerScreen> {
  excel_pkg.Excel? _excel;
  List<List<String>> _parsedHtmlTableRows = [];
  bool _isHtmlTable = false;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _showExternalOpen = false;
  String? _errorMessage;

  static const int _maxRenderRows = 300;

  @override
  void initState() {
    super.initState();
    _loadExcelFile();
  }

  Future<void> _loadExcelFile() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final file = File(widget.filePath);
      final bytes = await file.readAsBytes();

      final decodedExcel = await compute(_decodeExcelTask, bytes);
      if (decodedExcel != null && decodedExcel.tables.isNotEmpty) {
        if (mounted) {
          setState(() {
            _excel = decodedExcel;
            _isLoading = false;
          });
        }
        return;
      }

      final contentStr = _safeDecodeBytes(bytes);

      if (contentStr.contains('<Workbook') || contentStr.contains('<Table')) {
        final rows = _parseXmlSpreadsheet(contentStr);
        if (rows.isNotEmpty) {
          if (mounted) {
            setState(() {
              _parsedHtmlTableRows = rows;
              _isHtmlTable = true;
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (contentStr.contains('<table') || contentStr.contains('<tr')) {
        final rows = _parseHtmlTable(contentStr);
        if (rows.isNotEmpty) {
          if (mounted) {
            setState(() {
              _parsedHtmlTableRows = rows;
              _isHtmlTable = true;
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (contentStr.contains('\t') || contentStr.contains(',')) {
        final rows = _parseTsvCsv(contentStr);
        if (rows.length > 1) {
          if (mounted) {
            setState(() {
              _parsedHtmlTableRows = rows;
              _isHtmlTable = true;
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (mounted) {
        setState(() {
          _showExternalOpen = true;
          _errorMessage = loc.file_read_error;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showExternalOpen = true;
          _errorMessage = '${loc.file_read_error}: $e';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<List<String>> _parseXmlSpreadsheet(String xmlContent) {
    final List<List<String>> rowsData = [];
    final rowRegExp = RegExp(r'<Row[^>]*>(.*?)</Row>', caseSensitive: false, dotAll: true);
    final dataRegExp = RegExp(r'<Data[^>]*>(.*?)</Data>', caseSensitive: false, dotAll: true);
    final tagCleaner = RegExp(r'<[^>]*>');

    for (final rowMatch in rowRegExp.allMatches(xmlContent)) {
      final rowContent = rowMatch.group(1) ?? '';
      final List<String> rowCells = [];
      for (final dataMatch in dataRegExp.allMatches(rowContent)) {
        String cellText = dataMatch.group(1) ?? '';
        cellText = cellText.replaceAll(tagCleaner, '').trim();
        rowCells.add(cellText);
      }
      if (rowCells.isNotEmpty) {
        rowsData.add(rowCells);
      }
    }
    return rowsData;
  }

  List<List<String>> _parseTsvCsv(String textContent) {
    final List<List<String>> rowsData = [];
    final lines = textContent.split(RegExp(r'\r?\n'));
    final String delimiter = textContent.contains('\t') ? '\t' : ',';

    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      final cells = line.split(delimiter).map((e) => e.trim().replaceAll('"', '')).toList();
      rowsData.add(cells);
    }
    return rowsData;
  }

  List<List<String>> _parseHtmlTable(String htmlContent) {
    final List<List<String>> rowsData = [];
    final trRegExp = RegExp(r'<tr[^>]*>(.*?)</tr>', caseSensitive: false, dotAll: true);
    final tdRegExp = RegExp(r'<t[dh][^>]*>(.*?)</t[dh]>', caseSensitive: false, dotAll: true);
    final tagCleaner = RegExp(r'<[^>]*>');

    for (final trMatch in trRegExp.allMatches(htmlContent)) {
      final trContent = trMatch.group(1) ?? '';
      final List<String> rowCells = [];
      for (final tdMatch in tdRegExp.allMatches(trContent)) {
        String cellText = tdMatch.group(1) ?? '';
        cellText = cellText.replaceAll(tagCleaner, '').trim();
        rowCells.add(cellText);
      }
      if (rowCells.isNotEmpty) {
        rowsData.add(rowCells);
      }
    }
    return rowsData;
  }

  Future<void> _openWithExternalApp() async {
    try {
      final result = await OpenFilex.open(widget.filePath);
      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _saveExcelFile() async {
    if (_excel == null || _isSaving) return;

    setState(() => _isSaving = true);
    final loc = AppLocalizations.of(context)!;
    try {
      final fileBytes = _excel!.save();
      if (fileBytes != null) {
        final file = File(widget.filePath);
        await file.writeAsBytes(fileBytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.file_saved_success),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${loc.save_error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _editCellDialog(String sheetName, int colIndex, int rowIndex, String currentValue) {
    final textController = TextEditingController(text: currentValue);
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${loc.column} ${colIndex + 1}'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              textController.dispose();
              Navigator.pop(dialogContext);
            },
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                var sheet = _excel!.tables[sheetName];
                if (sheet != null) {
                  sheet.updateCell(
                    excel_pkg.CellIndex.indexByColumnRow(
                      columnIndex: colIndex,
                      rowIndex: rowIndex,
                    ),
                    excel_pkg.TextCellValue(textController.text),
                  );
                }
              });
              textController.dispose();
              Navigator.pop(dialogContext);
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName, style: const TextStyle(fontSize: 16)),
        actions: [
          if (_excel != null)
            _isSaving
                ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : IconButton(
              icon: const Icon(Icons.save),
              tooltip: loc.save_changes,
              onPressed: _saveExcelFile,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final loc = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.description_outlined, size: 60, color: Colors.blueAccent),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
              if (_showExternalOpen) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _openWithExternalApp,
                  icon: const Icon(Icons.open_in_new),
                  label: Text(loc.open_external),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (_isHtmlTable) {
      int maxCols = 0;
      for (var r in _parsedHtmlTableRows) {
        if (r.length > maxCols) maxCols = r.length;
      }

      final displayRows = _parsedHtmlTableRows.take(_maxRenderRows).toList();

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: List.generate(
              maxCols,
                  (index) => DataColumn(label: Text('${loc.column} ${index + 1}')),
            ),
            rows: displayRows.map((row) {
              return DataRow(
                cells: List.generate(maxCols, (colIndex) {
                  final cellVal = colIndex < row.length ? row[colIndex] : '';
                  return DataCell(Text(cellVal));
                }),
              );
            }).toList(),
          ),
        ),
      );
    }

    final tables = _excel?.tables ?? {};
    if (tables.isEmpty) {
      return Center(child: Text(loc.empty_file));
    }

    return DefaultTabController(
      length: tables.keys.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: tables.keys.map((sheetName) => Tab(text: sheetName)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: tables.keys.map((sheetName) {
                final table = tables[sheetName];
                if (table == null || table.rows.isEmpty) {
                  return Center(child: Text(loc.empty_page));
                }

                final totalRows = table.rows.length;
                final renderCount = totalRows > _maxRenderRows ? _maxRenderRows : totalRows;

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: List.generate(
                        table.maxColumns,
                            (index) => DataColumn(label: Text('${loc.column} ${index + 1}')),
                      ),
                      rows: List.generate(renderCount, (rowIndex) {
                        final row = table.rows[rowIndex];
                        return DataRow(
                          cells: List.generate(table.maxColumns, (colIndex) {
                            final cellValue =
                            colIndex < row.length ? row[colIndex]?.value?.toString() ?? '' : '';
                            return DataCell(
                              InkWell(
                                onTap: () =>
                                    _editCellDialog(sheetName, colIndex, rowIndex, cellValue),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(cellValue.isEmpty ? '-' : cellValue),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.edit, size: 12, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}