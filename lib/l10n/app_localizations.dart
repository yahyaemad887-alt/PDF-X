import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('ru')
  ];

  /// No description provided for @welcome_title.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك'**
  String get welcome_title;

  /// No description provided for @select_language_desc.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء اختيار لغتك المفضلة'**
  String get select_language_desc;

  /// No description provided for @continue_button.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get continue_button;

  /// No description provided for @share_error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في مشاركة الملف'**
  String get share_error;

  /// No description provided for @jump_to_page.
  ///
  /// In ar, this message translates to:
  /// **'الانتقال إلى صفحة'**
  String get jump_to_page;

  /// No description provided for @enter_page_number.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الصفحة'**
  String get enter_page_number;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @invalid_page_number.
  ///
  /// In ar, this message translates to:
  /// **'رقم صفحة غير صالح'**
  String get invalid_page_number;

  /// No description provided for @go.
  ///
  /// In ar, this message translates to:
  /// **'انتقال'**
  String get go;

  /// No description provided for @share_file.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة الملف'**
  String get share_file;

  /// No description provided for @loading_pdf.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل ملف الـ PDF...'**
  String get loading_pdf;

  /// No description provided for @file_read_error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في قراءة الملف'**
  String get file_read_error;

  /// No description provided for @previous_page.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة السابقة'**
  String get previous_page;

  /// No description provided for @next_page.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة التالية'**
  String get next_page;

  /// No description provided for @openFileError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في فتح الملف'**
  String get openFileError;

  /// No description provided for @deleteFile.
  ///
  /// In ar, this message translates to:
  /// **'حذف الملف'**
  String get deleteFile;

  /// No description provided for @deleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف الملف \'{name}\'؟'**
  String deleteConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في المستندات...'**
  String get searchHint;

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'PDF X'**
  String get appTitle;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @filesSuffix.
  ///
  /// In ar, this message translates to:
  /// **'ملفات'**
  String get filesSuffix;

  /// No description provided for @pdf.
  ///
  /// In ar, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @word.
  ///
  /// In ar, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @excel.
  ///
  /// In ar, this message translates to:
  /// **'Excel'**
  String get excel;

  /// No description provided for @ppt.
  ///
  /// In ar, this message translates to:
  /// **'PowerPoint'**
  String get ppt;

  /// No description provided for @txt.
  ///
  /// In ar, this message translates to:
  /// **'نص'**
  String get txt;

  /// No description provided for @image.
  ///
  /// In ar, this message translates to:
  /// **'صور'**
  String get image;

  /// No description provided for @guides.
  ///
  /// In ar, this message translates to:
  /// **'المستكشف'**
  String get guides;

  /// No description provided for @recent.
  ///
  /// In ar, this message translates to:
  /// **'الأحدث'**
  String get recent;

  /// No description provided for @bookmarks.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get bookmarks;

  /// No description provided for @noDocuments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مستندات'**
  String get noDocuments;

  /// No description provided for @scanNow.
  ///
  /// In ar, this message translates to:
  /// **'فحص الآن'**
  String get scanNow;

  /// No description provided for @scanningStorage.
  ///
  /// In ar, this message translates to:
  /// **'جاري فحص التخزين...'**
  String get scanningStorage;

  /// No description provided for @open.
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get open;

  /// No description provided for @rename.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تسمية'**
  String get rename;

  /// No description provided for @legacyDocFormatError.
  ///
  /// In ar, this message translates to:
  /// **'نسخة ملف Word القديمة (.doc) غير مدعومة للعرض المباشر.'**
  String get legacyDocFormatError;

  /// No description provided for @documentReaderError.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، حدث خطأ أثناء قراءة المستند.'**
  String get documentReaderError;

  /// No description provided for @emptyTable.
  ///
  /// In ar, this message translates to:
  /// **'الجدول فارغ'**
  String get emptyTable;

  /// No description provided for @legacyXlsFormatError.
  ///
  /// In ar, this message translates to:
  /// **'نسخة ملف Excel القديمة (.xls) تتطلب الفتح عبر تطبيق خارجي.'**
  String get legacyXlsFormatError;

  /// No description provided for @openExternalApp.
  ///
  /// In ar, this message translates to:
  /// **'فتح في تطبيق خارجي'**
  String get openExternalApp;

  /// No description provided for @columnPrefix.
  ///
  /// In ar, this message translates to:
  /// **'عمود'**
  String get columnPrefix;

  /// No description provided for @renameFile.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تسمية الملف'**
  String get renameFile;

  /// No description provided for @newFileName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الملف الجديد'**
  String get newFileName;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @file_saved_success.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الملف بنجاح'**
  String get file_saved_success;

  /// No description provided for @save_error.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في حفظ الملف'**
  String get save_error;

  /// No description provided for @save_changes.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get save_changes;

  /// No description provided for @write_text_here.
  ///
  /// In ar, this message translates to:
  /// **'اكتب النص هنا...'**
  String get write_text_here;

  /// No description provided for @column.
  ///
  /// In ar, this message translates to:
  /// **'عمود'**
  String get column;

  /// No description provided for @open_external.
  ///
  /// In ar, this message translates to:
  /// **'فتح خارجي'**
  String get open_external;

  /// No description provided for @empty_file.
  ///
  /// In ar, this message translates to:
  /// **'ملف فارغ'**
  String get empty_file;

  /// No description provided for @empty_page.
  ///
  /// In ar, this message translates to:
  /// **'صفحة فارغة'**
  String get empty_page;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
