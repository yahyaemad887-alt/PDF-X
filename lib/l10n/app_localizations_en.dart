// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_title => 'Welcome';

  @override
  String get select_language_desc => 'Please select your preferred language';

  @override
  String get continue_button => 'Continue';

  @override
  String get share_error => 'Error sharing file';

  @override
  String get jump_to_page => 'Jump to Page';

  @override
  String get enter_page_number => 'Enter page number';

  @override
  String get cancel => 'Cancel';

  @override
  String get invalid_page_number => 'Invalid page number';

  @override
  String get go => 'Go';

  @override
  String get share_file => 'Share file';

  @override
  String get loading_pdf => 'Loading PDF...';

  @override
  String get file_read_error => 'Error reading file';

  @override
  String get previous_page => 'Previous Page';

  @override
  String get next_page => 'Next Page';

  @override
  String get openFileError => 'Error opening file';

  @override
  String get deleteFile => 'Delete File';

  @override
  String deleteConfirm(String name) {
    return 'Are you sure you want to delete \'$name\'?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get searchHint => 'Search documents...';

  @override
  String get appTitle => 'PDF X';

  @override
  String get all => 'All';

  @override
  String get filesSuffix => 'files';

  @override
  String get pdf => 'PDF';

  @override
  String get word => 'Word';

  @override
  String get excel => 'Excel';

  @override
  String get ppt => 'PowerPoint';

  @override
  String get txt => 'Text';

  @override
  String get image => 'Images';

  @override
  String get guides => 'Explorer';

  @override
  String get recent => 'Recent';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get noDocuments => 'No documents found';

  @override
  String get scanNow => 'Scan Now';

  @override
  String get scanningStorage => 'Scanning storage...';

  @override
  String get open => 'Open';

  @override
  String get rename => 'Rename';

  @override
  String get legacyDocFormatError =>
      'Legacy Word format (.doc) is not supported for direct viewing.';

  @override
  String get documentReaderError =>
      'Sorry, an error occurred while reading the document.';

  @override
  String get emptyTable => 'Table is empty';

  @override
  String get legacyXlsFormatError =>
      'Legacy Excel format (.xls) requires opening via an external app.';

  @override
  String get openExternalApp => 'Open in external app';

  @override
  String get columnPrefix => 'Col';

  @override
  String get renameFile => 'Rename File';

  @override
  String get newFileName => 'New file name';

  @override
  String get save => 'Save';

  @override
  String get file_saved_success => 'File saved successfully';

  @override
  String get save_error => 'Error saving file';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get write_text_here => 'Write text here...';

  @override
  String get column => 'Column';

  @override
  String get open_external => 'Open External';

  @override
  String get empty_file => 'Empty file';

  @override
  String get empty_page => 'Empty page';
}
