// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcome_title => 'أهلاً بك';

  @override
  String get select_language_desc => 'الرجاء اختيار لغتك المفضلة';

  @override
  String get continue_button => 'متابعة';

  @override
  String get share_error => 'خطأ في مشاركة الملف';

  @override
  String get jump_to_page => 'الانتقال إلى صفحة';

  @override
  String get enter_page_number => 'أدخل رقم الصفحة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get invalid_page_number => 'رقم صفحة غير صالح';

  @override
  String get go => 'انتقال';

  @override
  String get share_file => 'مشاركة الملف';

  @override
  String get loading_pdf => 'جاري تحميل ملف الـ PDF...';

  @override
  String get file_read_error => 'خطأ في قراءة الملف';

  @override
  String get previous_page => 'الصفحة السابقة';

  @override
  String get next_page => 'الصفحة التالية';

  @override
  String get openFileError => 'خطأ في فتح الملف';

  @override
  String get deleteFile => 'حذف الملف';

  @override
  String deleteConfirm(String name) {
    return 'هل أنت متأكد من حذف الملف \'$name\'؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get searchHint => 'ابحث في المستندات...';

  @override
  String get appTitle => 'PDF X';

  @override
  String get all => 'الكل';

  @override
  String get filesSuffix => 'ملفات';

  @override
  String get pdf => 'PDF';

  @override
  String get word => 'Word';

  @override
  String get excel => 'Excel';

  @override
  String get ppt => 'PowerPoint';

  @override
  String get txt => 'نص';

  @override
  String get image => 'صور';

  @override
  String get guides => 'المستكشف';

  @override
  String get recent => 'الأحدث';

  @override
  String get bookmarks => 'المفضلة';

  @override
  String get noDocuments => 'لا توجد مستندات';

  @override
  String get scanNow => 'فحص الآن';

  @override
  String get scanningStorage => 'جاري فحص التخزين...';

  @override
  String get open => 'فتح';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get legacyDocFormatError =>
      'نسخة ملف Word القديمة (.doc) غير مدعومة للعرض المباشر.';

  @override
  String get documentReaderError => 'عذراً، حدث خطأ أثناء قراءة المستند.';

  @override
  String get emptyTable => 'الجدول فارغ';

  @override
  String get legacyXlsFormatError =>
      'نسخة ملف Excel القديمة (.xls) تتطلب الفتح عبر تطبيق خارجي.';

  @override
  String get openExternalApp => 'فتح في تطبيق خارجي';

  @override
  String get columnPrefix => 'عمود';

  @override
  String get renameFile => 'إعادة تسمية الملف';

  @override
  String get newFileName => 'اسم الملف الجديد';

  @override
  String get save => 'حفظ';

  @override
  String get file_saved_success => 'تم حفظ الملف بنجاح';

  @override
  String get save_error => 'خطأ في حفظ الملف';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get write_text_here => 'اكتب النص هنا...';

  @override
  String get column => 'عمود';

  @override
  String get open_external => 'فتح خارجي';

  @override
  String get empty_file => 'ملف فارغ';

  @override
  String get empty_page => 'صفحة فارغة';
}
