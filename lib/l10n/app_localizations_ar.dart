// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'قارئ المستندات';

  @override
  String get searchHint => 'ابحث باسم الملف...';

  @override
  String get all => 'الكل';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => 'ملف';

  @override
  String get recent => 'الأخيرة';

  @override
  String get bookmarks => 'العلامات المرجعية';

  @override
  String get noDocuments => 'لا توجد مستندات';

  @override
  String get scanNow => 'فحص الذاكرة الآن';

  @override
  String get renameFile => 'إعادة تسمية الملف';

  @override
  String get newFileName => 'اسم الملف الجديد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get deleteFile => 'حذف الملف';

  @override
  String deleteConfirm(Object fileName) {
    return 'هل أنت متأكد من حذف الملف \"$fileName\" نهائياً؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get open => 'فتح';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get scanningStorage => 'جاري فحص الذاكرة...';

  @override
  String get fileReadError => 'حدث خطأ أثناء قراءة الملف';

  @override
  String get fileSavedSuccess => 'تم حفظ الملف بنجاح';

  @override
  String get saveError => 'حدث خطأ أثناء الحفظ';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get writeTextHere => 'اكتب النص هنا...';

  @override
  String get column => 'عمود';

  @override
  String get emptyFile => 'الملف فارغ';

  @override
  String get emptyPage => 'الصفحة فارغة';

  @override
  String get openExternal => 'فتح باستخدام تطبيق خارجي';

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
