import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';
import 'package:archive/archive.dart';
import 'package:excel/excel.dart' hide Border;
import 'l10n/app_localizations.dart';
import 'services.dart';
import 'pdf_viewer_screen.dart';
import 'document_viewers.dart';
import 'package:excel/excel.dart' hide Border, Color; // تجنب التعارض مع عناصر الواجهة
import 'package:open_filex/open_filex.dart';

/// الجذر الرئيسي للتطبيق لتجميع التكوينات والإعدادات
class PdfToolsApp extends StatefulWidget {
  const PdfToolsApp({super.key});

  static Future<void> setThemeMode(BuildContext context, bool isDark) async {
    final state = context.findAncestorStateOfType<_PdfToolsAppState>();
    await state?.setThemeMode(isDark);
  }

  static Future<void> setLocale(BuildContext context, Locale locale) async {
    final state = context.findAncestorStateOfType<_PdfToolsAppState>();
    await state?.setLocale(locale);
  }

  @override
  State<PdfToolsApp> createState() => _PdfToolsAppState();
}

class _PdfToolsAppState extends State<PdfToolsApp> {
  bool _isDarkMode = false;
  bool _isFirstRun = true;
  Locale _locale = const Locale('ar');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
      _isFirstRun = prefs.getBool('is_first_run') ?? true;
      final langCode = prefs.getString('language_code') ?? 'ar';
      _locale = Locale(langCode);
      _isLoading = false;
    });
  }

  Future<void> setThemeMode(bool isDark) async {
    setState(() => _isDarkMode = isDark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
  }

  Future<void> setLocale(Locale locale) async {
    setState(() => _locale = locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  Future<void> _completeOnboarding(Locale selectedLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', selectedLocale.languageCode);
    await prefs.setBool('is_first_run', false);
    if (!mounted) return;
    setState(() {
      _locale = selectedLocale;
      _isFirstRun = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'PDF X',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: _isFirstRun
          ? OnboardingLanguageScreen(
        isDarkMode: _isDarkMode,
        onLanguageSelected: _completeOnboarding,
      )
          : MainDashboardView(
        isDarkMode: _isDarkMode,
        onThemeToggle: () => setThemeMode(!_isDarkMode),
      ),
    );
  }
}

/// شاشة الترحيب واختيار اللغة المتعددة (تظهر لمرة واحدة)
class OnboardingLanguageScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(Locale) onLanguageSelected;

  const OnboardingLanguageScreen({
    super.key,
    required this.isDarkMode,
    required this.onLanguageSelected,
  });

  @override
  State<OnboardingLanguageScreen> createState() => _OnboardingLanguageScreenState();
}

class _OnboardingLanguageScreenState extends State<OnboardingLanguageScreen> {
  String _selectedLang = 'ar';

  final List<Map<String, String>> _supportedLanguages = const [
    {'code': 'ar', 'title': 'العربية', 'subtitle': 'Arabic'},
    {'code': 'en', 'title': 'English', 'subtitle': 'الإنجليزية'},
    {'code': 'de', 'title': 'Deutsch', 'subtitle': 'الألمانية'},
    {'code': 'es', 'title': 'Español', 'subtitle': 'الإسبانية'},
    {'code': 'fr', 'title': 'Français', 'subtitle': 'الفرنسية'},
    {'code': 'ru', 'title': 'Русский', 'subtitle': 'الروسية'},
    {'code': 'zh', 'title': '中文', 'subtitle': 'الصينية'},
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardBgColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.language, size: 48, color: Color(0xFF1E88E5)),
              ),
              const SizedBox(height: 16),
              Text(
                'اختر لغة التطبيق',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Select Application Language',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _supportedLanguages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final lang = _supportedLanguages[index];
                    return _buildLanguageCard(
                      title: lang['title']!,
                      subtitle: lang['subtitle']!,
                      code: lang['code']!,
                      cardBgColor: cardBgColor,
                      textColor: textColor,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2962FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  onPressed: () {
                    widget.onLanguageSelected(Locale(_selectedLang));
                  },
                  child: const Text(
                    'تأكيد • Confirm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required String subtitle,
    required String code,
    required Color cardBgColor,
    required Color textColor,
  }) {
    final bool isSelected = _selectedLang == code;
    return InkWell(
      onTap: () => setState(() => _selectedLang = code),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2962FF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!widget.isDarkMode)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            const Spacer(),
            Radio<String>(
              value: code,
              groupValue: _selectedLang,
              activeColor: const Color(0xFF2962FF),
              onChanged: (val) {
                if (val != null) setState(() => _selectedLang = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// شاشة لوحة التحكم الرئيسية للمستندات
class MainDashboardView extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MainDashboardView({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<MainDashboardView> createState() => _MainDashboardViewState();
}

class _MainDashboardViewState extends State<MainDashboardView> with SingleTickerProviderStateMixin {
  final DocumentManagerService _docManager = DocumentManagerService();

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  StreamSubscription<List<DocumentItem>>? _docsSubscription;
  StreamSubscription<bool>? _scanningSubscription;
  StreamSubscription<String>? _progressSubscription;

  List<DocumentItem> _allDocuments = [];
  bool _isScanning = false;
  String _scanProgressMessage = '';

  DocumentCategory _selectedCategory = DocumentCategory.all;
  bool _isSearchActive = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _docManager.loadSavedBookmarks();

    _docsSubscription = _docManager.documentsStream.listen((docs) {
      if (mounted) setState(() => _allDocuments = docs);
    });

    _scanningSubscription = _docManager.scanningStateStream.listen((isScanning) {
      if (mounted) setState(() => _isScanning = isScanning);
    });

    _progressSubscription = _docManager.progressStream.listen((progress) {
      if (mounted) setState(() => _scanProgressMessage = progress);
    });

    _allDocuments = _docManager.currentDocuments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionsAndInit();
    });
  }

  Future<void> _requestPermissionsAndInit() async {
    bool hasPermission = false;

    if (await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted) {
      hasPermission = true;
    } else {
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        hasPermission = true;
      } else {
        final storageStatus = await Permission.storage.request();
        hasPermission = storageStatus.isGranted;
      }
    }

    if (hasPermission && _allDocuments.isEmpty) {
      await _docManager.startFullScan();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _docsSubscription?.cancel();
    _scanningSubscription?.cancel();
    _progressSubscription?.cancel();
    super.dispose();
  }

  Future<void> _openDocument(DocumentItem doc) async {
    switch (doc.category) {
      case DocumentCategory.pdf:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(filePath: doc.path, fileName: doc.name),
          ),
        );
        break;

      case DocumentCategory.word:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordViewerScreen(filePath: doc.path, fileName: doc.name),
          ),
        );
        break;

      case DocumentCategory.excel:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExcelViewerScreen(filePath: doc.path, fileName: doc.name),
          ),
        );
        break;

      case DocumentCategory.txt:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TxtViewerScreen(filePath: doc.path, fileName: doc.name),
          ),
        );
        break;

      case DocumentCategory.image:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerScreen(filePath: doc.path, fileName: doc.name),
          ),
        );
        break;

      case DocumentCategory.ppt:
      case DocumentCategory.guides:
      default:
        final result = await OpenFilex.open(doc.path);
        if (result.type != ResultType.done && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('يرجى تثبيت تطبيق يمتلك صلاحية قراءة الملف (${result.message})'),
            ),
          );
        }
        break;
    }
  }

  void _showRenameDialog(DocumentItem doc, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (dialogContext) => _RenameDialogWidget(
        initialName: doc.name,
        loc: loc,
        onSave: (newName) async {
          await _docManager.renameDocument(doc.id, newName);
        },
      ),
    );
  }

  void _confirmDeleteDialog(DocumentItem doc, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.deleteFile),
        content: Text(loc.deleteConfirm(doc.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _docManager.deleteDocument(doc.id);
            },
            child: Text(loc.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final Color bgColor = widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color cardBgColor = widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black87;

    final stats = _docManager.getStorageStats();

    final filteredRecentDocs = SearchFilterService.filterDocuments(
      sourceList: _allDocuments,
      query: _searchQuery,
      category: _selectedCategory,
      onlyBookmarks: false,
    );

    final filteredBookmarkDocs = SearchFilterService.filterDocuments(
      sourceList: _allDocuments,
      query: _searchQuery,
      category: _selectedCategory,
      onlyBookmarks: true,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBgColor,
        elevation: 0,
        title: _isSearchActive
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: loc.searchHint,
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        )
            : Text(
          loc.appTitle,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search, color: textColor, size: 26),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: textColor),
            onPressed: widget.onThemeToggle,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _docManager.startFullScan(),
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Container(
                      color: cardBgColor,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.72,
                        children: [
                          _buildGridItem(
                            loc.all,
                            '${stats.categoryCounts[DocumentCategory.all] ?? 0} ${loc.filesSuffix}',
                            Icons.folder,
                            const Color(0xFF1976D2),
                            category: DocumentCategory.all,
                          ),
                          _buildGridItem(
                            loc.pdf,
                            '${stats.categoryCounts[DocumentCategory.pdf] ?? 0} ${loc.filesSuffix}',
                            Icons.picture_as_pdf,
                            const Color(0xFFE53935),
                            category: DocumentCategory.pdf,
                          ),
                          _buildGridItem(
                            'Word',
                            '${stats.categoryCounts[DocumentCategory.word] ?? 0} ${loc.filesSuffix}',
                            Icons.description,
                            const Color(0xFF1E88E5),
                            category: DocumentCategory.word,
                          ),
                          _buildGridItem(
                            loc.excel,
                            '${stats.categoryCounts[DocumentCategory.excel] ?? 0} ${loc.filesSuffix}',
                            Icons.table_chart,
                            const Color(0xFF43A047),
                            category: DocumentCategory.excel,
                          ),
                          _buildGridItem(
                            'PPT',
                            '${stats.categoryCounts[DocumentCategory.ppt] ?? 0} ${loc.filesSuffix}',
                            Icons.slideshow,
                            const Color(0xFFFB8C00),
                            category: DocumentCategory.ppt,
                          ),
                          _buildGridItem(
                            loc.txt,
                            '${stats.categoryCounts[DocumentCategory.txt] ?? 0} ${loc.filesSuffix}',
                            Icons.article,
                            const Color(0xFF5C6BC0),
                            category: DocumentCategory.txt,
                          ),
                          _buildGridItem(
                            'صورة',
                            '${stats.categoryCounts[DocumentCategory.image] ?? 0} ${loc.filesSuffix}',
                            Icons.image,
                            const Color(0xFFFFB300),
                            category: DocumentCategory.image,
                          ),
                          _buildGridItem(
                            'الدلائل',
                            '${stats.totalUsedFormatted} / ${stats.totalCapacityFormatted}',
                            Icons.find_in_page,
                            const Color(0xFF0288D1),
                            category: DocumentCategory.guides,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF2962FF),
                        unselectedLabelColor: Colors.grey[500],
                        indicatorColor: const Color(0xFF2962FF),
                        indicatorWeight: 3,
                        tabs: [
                          Tab(text: loc.recent),
                          Tab(text: loc.bookmarks),
                        ],
                      ),
                      backgroundColor: cardBgColor,
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildDocumentList(filteredRecentDocs, loc),
                  _buildDocumentList(filteredBookmarkDocs, loc),
                ],
              ),
            ),
            if (_isScanning)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            _scanProgressMessage.isNotEmpty ? _scanProgressMessage : loc.scanningStorage,
                            style: TextStyle(color: textColor),
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

  Widget _buildDocumentList(List<DocumentItem> docs, AppLocalizations loc) {
    if (docs.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                loc.noDocuments,
                style: TextStyle(color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _docManager.startFullScan(),
                icon: const Icon(Icons.refresh),
                label: Text(loc.scanNow),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: docs.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final doc = docs[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getCategoryColor(doc.category).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getCategoryIcon(doc.category), color: _getCategoryColor(doc.category), size: 24),
          ),
          title: Text(
            doc.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, color: widget.isDarkMode ? Colors.white : Colors.black87),
          ),
          subtitle: Text('${doc.formattedSize} • ${_formatDate(doc.lastModified)}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  doc.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: doc.isBookmarked ? const Color(0xFF2962FF) : Colors.grey[400],
                ),
                onPressed: () => _docManager.toggleBookmark(doc.id),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[500]),
                onSelected: (value) {
                  if (value == 'open') _openDocument(doc);
                  if (value == 'rename') _showRenameDialog(doc, loc);
                  if (value == 'delete') _confirmDeleteDialog(doc, loc);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'open', child: Text(loc.open)),
                  PopupMenuItem(value: 'rename', child: Text(loc.rename)),
                  PopupMenuItem(value: 'delete', child: Text(loc.delete, style: const TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          onTap: () => _openDocument(doc),
        );
      },
    );
  }

  Widget _buildGridItem(String title, String subtitle, IconData icon, Color color, {required DocumentCategory category}) {
    final bool isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = category),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: isSelected ? Border.all(color: const Color(0xFF2962FF), width: 1.5) : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                subtitle,
                maxLines: 1,
                style: TextStyle(fontSize: 9, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.pdf: return const Color(0xFFE53935);
      case DocumentCategory.excel: return const Color(0xFF43A047);
      case DocumentCategory.word: return const Color(0xFF1E88E5);
      case DocumentCategory.ppt: return const Color(0xFFFB8C00);
      case DocumentCategory.txt: return const Color(0xFF5C6BC0);
      case DocumentCategory.image: return const Color(0xFFFFB300);
      case DocumentCategory.guides: return const Color(0xFF0288D1);
      default: return const Color(0xFF1976D2);
    }
  }

  IconData _getCategoryIcon(DocumentCategory category) {
    switch (category) {
      case DocumentCategory.pdf: return Icons.picture_as_pdf;
      case DocumentCategory.excel: return Icons.table_chart;
      case DocumentCategory.word: return Icons.description;
      case DocumentCategory.ppt: return Icons.slideshow;
      case DocumentCategory.txt: return Icons.article;
      case DocumentCategory.image: return Icons.image;
      case DocumentCategory.guides: return Icons.find_in_page;
      default: return Icons.folder;
    }
  }

  String _formatDate(DateTime date) => '${date.year}/${date.month}/${date.day}';
}

/// فئة مساعدة لتثبيت الـ TabBar داخل NestedScrollView
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverAppBarDelegate(this.tabBar, {required this.backgroundColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor || oldDelegate.tabBar != tabBar;
  }
}

/// شاشة عرض المستندات المصورة
class ImageViewerScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const ImageViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(fileName, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(
            File(filePath),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text('تعذر تحميل الصورة', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}

/// شاشة عرض مستندات الورد (.docx) داخل التطبيق
class WordViewerScreen extends StatefulWidget {
  final String filePath;
  final String fileName;

  const WordViewerScreen({
    super.key,
    required this.filePath,
    required this.fileName,
  });

  @override
  State<WordViewerScreen> createState() => _WordViewerScreenState();
}

class _WordViewerScreenState extends State<WordViewerScreen> {
  List<String> _paragraphs = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _parseWordDocument();
  }

  Future<void> _parseWordDocument() async {
    try {
      final bytes = await File(widget.filePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      ArchiveFile? docXmlFile;
      for (final file in archive) {
        if (file.name == 'word/document.xml') {
          docXmlFile = file;
          break;
        }
      }

      if (docXmlFile != null) {
        final content = String.fromCharCodes(docXmlFile.content as List<int>);
        final regExpP = RegExp(r'<w:p[\s>].*?</w:p>');
        final regExpT = RegExp(r'<w:t[\s>](.*?)</w:t>');

        List<String> extractedText = [];
        for (final pMatch in regExpP.allMatches(content)) {
          final pText = pMatch.group(0) ?? '';
          final textBuffer = StringBuffer();
          for (final tMatch in regExpT.allMatches(pText)) {
            final rawVal = tMatch.group(1) ?? '';
            final cleanVal = rawVal
                .replaceAll('&lt;', '<')
                .replaceAll('&gt;', '>')
                .replaceAll('&amp;', '&')
                .replaceAll('&quot;', '"')
                .replaceAll('&apos;', "'");
            textBuffer.write(cleanVal);
          }
          if (textBuffer.isNotEmpty) {
            extractedText.add(textBuffer.toString());
          }
        }

        if (!mounted) return;
        setState(() {
          _paragraphs = extractedText;
          _isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'الملف بتنسيق قديم (.doc)، يرجى تحويله إلى (.docx) لفتحه داخل التطبيق.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'تعذر قراءة المستند داخل التطبيق.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName, style: const TextStyle(fontSize: 16)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _paragraphs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SelectableText(
              _paragraphs[index],
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }
}


/// شاشة عرض ملفات الإكسيل (.xlsx / .xls) الموحدة داخل التطبيق
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
  Excel? _excel;
  bool _isLoading = true;
  bool _isOldFormat = false;

  @override
  void initState() {
    super.initState();
    _checkAndLoadExcel();
  }

  Future<void> _checkAndLoadExcel() async {
    if (widget.filePath.toLowerCase().endsWith('.xls')) {
      if (!mounted) return;
      setState(() {
        _isOldFormat = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final bytes = await File(widget.filePath).readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      if (!mounted) return;
      setState(() {
        _excel = excel;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isOldFormat = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _openExternal() async {
    final result = await OpenFilex.open(widget.filePath);
    if (result.type != ResultType.done && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر فتح الملف: ${result.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName, style: const TextStyle(fontSize: 16)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isOldFormat
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.description_outlined, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'تنسيق الملف قديم (.xls) ولا يمكن عرضه مباشرة، يمكنك فتحه باستخدام تطبيق خارجي.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _openExternal,
                icon: const Icon(Icons.open_in_new),
                label: const Text('فتح بواسطة تطبيق خارجي'),
              ),
            ],
          ),
        ),
      )
          : DefaultTabController(
        length: _excel?.tables.keys.length ?? 0,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: _excel!.tables.keys.map((sheet) => Tab(text: sheet)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: _excel!.tables.keys.map((sheetName) {
                  final sheet = _excel!.tables[sheetName]!;
                  if (sheet.maxRows == 0 || sheet.maxColumns == 0) {
                    return const Center(child: Text('جدول البيانات فارغ'));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: List.generate(
                          sheet.maxColumns,
                              (index) => DataColumn(
                            label: Text('عمود ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        rows: sheet.rows.map((row) {
                          return DataRow(
                            cells: List.generate(sheet.maxColumns, (colIndex) {
                              final val = colIndex < row.length ? row[colIndex]?.value : '';
                              return DataCell(Text(val?.toString() ?? ''));
                            }),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ويدجت إعادة التسمية منفصلة
class _RenameDialogWidget extends StatefulWidget {
  final String initialName;
  final dynamic loc; // يدعم AppLocalizations الخاص بمشروعك
  final Function(String) onSave;

  const _RenameDialogWidget({
    required this.initialName,
    required this.loc,
    required this.onSave,
  });

  @override
  State<_RenameDialogWidget> createState() => _RenameDialogWidgetState();
}

class _RenameDialogWidgetState extends State<_RenameDialogWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.loc.renameFile),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.loc.newFileName,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.loc.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final newName = _controller.text.trim();
            if (newName.isNotEmpty && newName != widget.initialName) {
              widget.onSave(newName);
            }
            Navigator.pop(context);
          },
          child: Text(widget.loc.save),
        ),
      ],
    );
  }
}