import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DocumentCategory { all, pdf, word, excel, ppt, txt, image, guides }

class DocumentItem {
  final String id;
  final String name;
  final String path;
  final DocumentCategory category;
  final int sizeInBytes;
  final DateTime lastModified;
  bool isBookmarked;

  DocumentItem({
    required this.id,
    required this.name,
    required this.path,
    required this.category,
    required this.sizeInBytes,
    required this.lastModified,
    this.isBookmarked = false,
  });

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class StorageStats {
  final Map<DocumentCategory, int> categoryCounts;
  final int totalUsedBytes;
  final int totalCapacityBytes;

  StorageStats({
    required this.categoryCounts,
    this.totalUsedBytes = 0,
    this.totalCapacityBytes = 0,
  });

  String get totalUsedFormatted {
    if (totalUsedBytes < 1024) return '$totalUsedBytes B';
    if (totalUsedBytes < 1024 * 1024) return '${(totalUsedBytes / 1024).toStringAsFixed(1)} KB';
    if (totalUsedBytes < 1024 * 1024 * 1024) return '${(totalUsedBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(totalUsedBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String get totalCapacityFormatted {
    if (totalCapacityBytes == 0) return '64 GB';
    if (totalCapacityBytes < 1024 * 1024 * 1024) return '${(totalCapacityBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(totalCapacityBytes / (1024 * 1024 * 1024)).toStringAsFixed(0)} GB';
  }
}

class DocumentManagerService {
  static final DocumentManagerService _instance = DocumentManagerService._internal();
  factory DocumentManagerService() => _instance;
  DocumentManagerService._internal();

  final List<DocumentItem> _documents = [];
  Set<String> _bookmarkedPaths = {};

  final StreamController<List<DocumentItem>> _docsController = StreamController.broadcast();
  final StreamController<bool> _scanningController = StreamController.broadcast();
  final StreamController<String> _progressController = StreamController.broadcast();

  Stream<List<DocumentItem>> get documentsStream => _docsController.stream;
  Stream<bool> get scanningStateStream => _scanningController.stream;
  Stream<String> get progressStream => _progressController.stream;

  List<DocumentItem> get currentDocuments => List.unmodifiable(_documents);

  int _pendingScanBuffer = 0;

  /// تحميل العلامات المرجعية المحفوظة من الذاكرة بشكل آمن
  Future<void> loadSavedBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _bookmarkedPaths = (prefs.getStringList('bookmarked_paths') ?? []).toSet();

      if (_documents.isNotEmpty) {
        for (var doc in _documents) {
          doc.isBookmarked = _bookmarkedPaths.contains(doc.path);
        }
        _notifyDocsChanged();
      }
    } catch (e) {
      debugPrint("Error loading bookmarks: $e");
    }
  }

  /// حفظ قائمة العلامات المرجعية في SharedPreferences
  Future<void> _persistBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('bookmarked_paths', _bookmarkedPaths.toList());
    } catch (e) {
      debugPrint("Error persisting bookmarks: $e");
    }
  }

  /// إضافة / إزالة العلامات المرجعية مع حفظها الفوري
  Future<void> toggleBookmark(String docId) async {
    try {
      final index = _documents.indexWhere((doc) => doc.id == docId);
      if (index != -1) {
        final doc = _documents[index];
        doc.isBookmarked = !doc.isBookmarked;

        if (doc.isBookmarked) {
          _bookmarkedPaths.add(doc.path);
        } else {
          _bookmarkedPaths.remove(doc.path);
        }

        await _persistBookmarks();
        _notifyDocsChanged();
      }
    } catch (e) {
      debugPrint("Error toggling bookmark: $e");
    }
  }

  /// مسح الذاكرة واستخراج المستندات بشكل آمن لا يسبب إغلاق التطبيق
  Future<void> startFullScan() async {
    if (_scanningController.isClosed) return;
    _scanningController.add(true);

    if (!_progressController.isClosed) {
      _progressController.add('scanning_storage');
    }

    await loadSavedBookmarks();

    try {
      if (Platform.isAndroid) {
        bool hasPermission = await Permission.manageExternalStorage.isGranted;

        if (!hasPermission) {
          final status = await Permission.manageExternalStorage.request();
          hasPermission = status.isGranted;
        }

        if (!hasPermission) {
          final status = await Permission.storage.request();
          hasPermission = status.isGranted;
        }

        if (hasPermission) {
          final rootDir = Directory('/storage/emulated/0');
          if (await rootDir.exists()) {
            _documents.clear();
            _pendingScanBuffer = 0;
            await _scanDirectory(rootDir);
          }
        }
      }
    } catch (e) {
      debugPrint("Scan error: $e");
    } finally {
      if (!_scanningController.isClosed) {
        _scanningController.add(false);
      }
      _notifyDocsChanged();
    }
  }

  /// فحص المجلدات بشكل آمن مع إرسال التحديثات على دفعات للوقاية من تجميد الواجهة
  Future<void> _scanDirectory(Directory dir) async {
    try {
      final Stream<FileSystemEntity> entities = dir.list(followLinks: false);

      await for (final entity in entities) {
        if (_scanningController.isClosed) break;

        try {
          if (entity is Directory) {
            final String name = entity.path.split(Platform.pathSeparator).last;
            // تجاهل المجلدات المخفية ومجلدات النظام لتجنب البطء والانهيار
            if (!name.startsWith('.') && name != 'Android') {
              await _scanDirectory(entity);
            }
          } else if (entity is File) {
            final String path = entity.path.toLowerCase();
            final String fileName = entity.path.split(Platform.pathSeparator).last.toLowerCase();
            DocumentCategory? category;

            if (path.endsWith('.pdf')) {
              category = fileName.contains('guide') || fileName.contains('daliil') || fileName.contains('دليل')
                  ? DocumentCategory.guides
                  : DocumentCategory.pdf;
            } else if (path.endsWith('.doc') || path.endsWith('.docx')) {
              category = DocumentCategory.word;
            } else if (path.endsWith('.xlsx') || path.endsWith('.xls')) {
              category = DocumentCategory.excel;
            } else if (path.endsWith('.ppt') || path.endsWith('.pptx')) {
              category = DocumentCategory.ppt;
            } else if (path.endsWith('.txt')) {
              category = DocumentCategory.txt;
            } else if (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png') || path.endsWith('.webp')) {
              category = DocumentCategory.image;
            }

            if (category != null) {
              final stat = await entity.stat();
              final doc = DocumentItem(
                id: entity.path,
                name: entity.path.split(Platform.pathSeparator).last,
                path: entity.path,
                category: category,
                sizeInBytes: stat.size,
                lastModified: stat.modified,
                isBookmarked: _bookmarkedPaths.contains(entity.path),
              );

              if (!_documents.any((d) => d.path == entity.path)) {
                _documents.add(doc);
                _pendingScanBuffer++;

                // تحديث الواجهة كل 25 ملفاً لتجنب الإغراق
                if (_pendingScanBuffer >= 25) {
                  _pendingScanBuffer = 0;
                  _notifyDocsChanged();
                  await Future.delayed(Duration.zero);
                }
              }
            }
          }
        } catch (_) {
          continue;
        }
      }
    } catch (e) {
      debugPrint("Directory scan error: $e");
    }
  }

  StorageStats getStorageStats() {
    final Map<DocumentCategory, int> counts = {
      for (var cat in DocumentCategory.values) cat: 0,
    };
    counts[DocumentCategory.all] = _documents.length;

    int totalBytes = 0;

    for (var doc in _documents) {
      counts[doc.category] = (counts[doc.category] ?? 0) + 1;
      totalBytes += doc.sizeInBytes;
    }

    return StorageStats(
      categoryCounts: counts,
      totalUsedBytes: totalBytes,
    );
  }

  Future<bool> renameDocument(String docId, String newName) async {
    final index = _documents.indexWhere((doc) => doc.id == docId);
    if (index == -1) return false;

    final oldPath = _documents[index].path;
    final oldFile = File(oldPath);
    final String parentDirPath = oldFile.parent.path;
    final String newPath = '$parentDirPath${Platform.pathSeparator}$newName';

    try {
      await oldFile.rename(newPath);

      final wasBookmarked = _documents[index].isBookmarked;

      if (wasBookmarked) {
        _bookmarkedPaths.remove(oldPath);
        _bookmarkedPaths.add(newPath);
        await _persistBookmarks();
      }

      _documents[index] = DocumentItem(
        id: newPath,
        name: newName,
        path: newPath,
        category: _documents[index].category,
        sizeInBytes: _documents[index].sizeInBytes,
        lastModified: DateTime.now(),
        isBookmarked: wasBookmarked,
      );

      _notifyDocsChanged();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteDocument(String docId) async {
    final index = _documents.indexWhere((doc) => doc.id == docId);
    if (index == -1) return false;

    try {
      final doc = _documents[index];
      final file = File(doc.path);

      if (await file.exists()) {
        await file.delete();
      }

      if (_bookmarkedPaths.contains(doc.path)) {
        _bookmarkedPaths.remove(doc.path);
        await _persistBookmarks();
      }

      _documents.removeAt(index);
      _notifyDocsChanged();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _notifyDocsChanged() {
    if (!_docsController.isClosed) {
      _docsController.add(List.unmodifiable(_documents));
    }
  }
}

class SearchFilterService {
  static List<DocumentItem> filterDocuments({
    required List<DocumentItem> sourceList,
    required String query,
    required DocumentCategory category,
    required bool onlyBookmarks,
  }) {
    final cleanQuery = query.trim().toLowerCase();

    return sourceList.where((doc) {
      final matchesCategory = category == DocumentCategory.all || doc.category == category;
      final matchesQuery = cleanQuery.isEmpty || doc.name.toLowerCase().contains(cleanQuery);
      final matchesBookmark = !onlyBookmarks || doc.isBookmarked;

      return matchesCategory && matchesQuery && matchesBookmark;
    }).toList();
  }
}