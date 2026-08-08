// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Document Reader';

  @override
  String get searchHint => 'Search by file name...';

  @override
  String get all => 'All';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => 'files';

  @override
  String get recent => 'Recent';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get noDocuments => 'No documents found';

  @override
  String get scanNow => 'Scan Storage Now';

  @override
  String get renameFile => 'Rename File';

  @override
  String get newFileName => 'New file name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get deleteFile => 'Delete File';

  @override
  String deleteConfirm(Object fileName) {
    return 'Are you sure you want to permanently delete \"$fileName\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get open => 'Open';

  @override
  String get rename => 'Rename';

  @override
  String get scanningStorage => 'Scanning storage...';

  @override
  String get fileReadError => 'Error reading file';

  @override
  String get fileSavedSuccess => 'File saved successfully';

  @override
  String get saveError => 'Error saving file';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get writeTextHere => 'Write text here...';

  @override
  String get column => 'Column';

  @override
  String get emptyFile => 'File is empty';

  @override
  String get emptyPage => 'Empty page';

  @override
  String get openExternal => 'Open with external app';

  @override
  String get shareError => 'حدث خطأ أثناء المشاركة';

  @override
  String get jumpToPage => 'الانتقال إلى صفحة';

  @override
  String get enterPageNumber => 'أدخل رقم الصفحة';

  @override
  String get go => 'انتقال';

  @override
  String get invalidPageNumber => 'رقم الصفحة غير صحيح';

  @override
  String get shareFile => 'مشاركة الملف';

  @override
  String get loadingPdf => 'جاري تحميل ملف PDF...';

  @override
  String get previousPage => 'الصفحة السابقة';

  @override
  String get nextPage => 'الصفحة التالية';
}
