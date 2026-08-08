import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'قارئ المستندات'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث باسم الملف...'**
  String get searchHint;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @pdf.
  ///
  /// In ar, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @excel.
  ///
  /// In ar, this message translates to:
  /// **'Excel'**
  String get excel;

  /// No description provided for @txt.
  ///
  /// In ar, this message translates to:
  /// **'TXT'**
  String get txt;

  /// No description provided for @filesSuffix.
  ///
  /// In ar, this message translates to:
  /// **'ملف'**
  String get filesSuffix;

  /// No description provided for @recent.
  ///
  /// In ar, this message translates to:
  /// **'الأخيرة'**
  String get recent;

  /// No description provided for @bookmarks.
  ///
  /// In ar, this message translates to:
  /// **'العلامات المرجعية'**
  String get bookmarks;

  /// No description provided for @noDocuments.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مستندات'**
  String get noDocuments;

  /// No description provided for @scanNow.
  ///
  /// In ar, this message translates to:
  /// **'فحص الذاكرة الآن'**
  String get scanNow;

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

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @deleteFile.
  ///
  /// In ar, this message translates to:
  /// **'حذف الملف'**
  String get deleteFile;

  /// No description provided for @deleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف الملف \"{fileName}\" نهائياً؟'**
  String deleteConfirm(Object fileName);

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

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

  /// No description provided for @scanningStorage.
  ///
  /// In ar, this message translates to:
  /// **'جاري فحص الذاكرة...'**
  String get scanningStorage;

  /// No description provided for @fileReadError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء قراءة الملف'**
  String get fileReadError;

  /// No description provided for @fileSavedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الملف بنجاح'**
  String get fileSavedSuccess;

  /// No description provided for @saveError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء الحفظ'**
  String get saveError;

  /// No description provided for @saveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get saveChanges;

  /// No description provided for @writeTextHere.
  ///
  /// In ar, this message translates to:
  /// **'اكتب النص هنا...'**
  String get writeTextHere;

  /// No description provided for @column.
  ///
  /// In ar, this message translates to:
  /// **'عمود'**
  String get column;

  /// No description provided for @emptyFile.
  ///
  /// In ar, this message translates to:
  /// **'الملف فارغ'**
  String get emptyFile;

  /// No description provided for @emptyPage.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة فارغة'**
  String get emptyPage;

  /// No description provided for @openExternal.
  ///
  /// In ar, this message translates to:
  /// **'فتح باستخدام تطبيق خارجي'**
  String get openExternal;

  /// No description provided for @shareError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء المشاركة'**
  String get shareError;

  /// No description provided for @jumpToPage.
  ///
  /// In ar, this message translates to:
  /// **'الانتقال إلى صفحة'**
  String get jumpToPage;

  /// No description provided for @enterPageNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الصفحة'**
  String get enterPageNumber;

  /// No description provided for @go.
  ///
  /// In ar, this message translates to:
  /// **'انتقال'**
  String get go;

  /// No description provided for @invalidPageNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الصفحة غير صحيح'**
  String get invalidPageNumber;

  /// No description provided for @shareFile.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة الملف'**
  String get shareFile;

  /// No description provided for @loadingPdf.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحميل ملف PDF...'**
  String get loadingPdf;

  /// No description provided for @previousPage.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة السابقة'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In ar, this message translates to:
  /// **'الصفحة التالية'**
  String get nextPage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
