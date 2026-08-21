// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get welcome_title => 'Добро пожаловать';

  @override
  String get select_language_desc => 'Пожалуйста, выберите предпочитаемый язык';

  @override
  String get continue_button => 'Продолжить';

  @override
  String get share_error => 'Ошибка при отправке файла';

  @override
  String get jump_to_page => 'Перейти к странице';

  @override
  String get enter_page_number => 'Введите номер страницы';

  @override
  String get cancel => 'Отмена';

  @override
  String get invalid_page_number => 'Неверный номер страницы';

  @override
  String get go => 'Перейти';

  @override
  String get share_file => 'Поделиться файлом';

  @override
  String get loading_pdf => 'Загрузка PDF...';

  @override
  String get file_read_error => 'Ошибка чтения файла';

  @override
  String get previous_page => 'Предыдущая страница';

  @override
  String get next_page => 'Следующая страница';

  @override
  String get openFileError => 'Ошибка открытия файла';

  @override
  String get deleteFile => 'Удалить файл';

  @override
  String deleteConfirm(String name) {
    return 'Вы уверены, что хотите удалить \'$name\'?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get searchHint => 'Поиск документов...';

  @override
  String get appTitle => 'PDF X';

  @override
  String get all => 'Все';

  @override
  String get filesSuffix => 'файлов';

  @override
  String get pdf => 'PDF';

  @override
  String get word => 'Word';

  @override
  String get excel => 'Excel';

  @override
  String get ppt => 'PowerPoint';

  @override
  String get txt => 'Текст';

  @override
  String get image => 'Изображения';

  @override
  String get guides => 'Проводник';

  @override
  String get recent => 'Недавние';

  @override
  String get bookmarks => 'Закладки';

  @override
  String get noDocuments => 'Документы не найдены';

  @override
  String get scanNow => 'Сканировать';

  @override
  String get scanningStorage => 'Сканирование хранилища...';

  @override
  String get open => 'Открыть';

  @override
  String get rename => 'Переименовать';

  @override
  String get legacyDocFormatError =>
      'Старый формат Word (.doc) не поддерживается для прямого просмотра.';

  @override
  String get documentReaderError =>
      'Извините, произошла ошибка при чтении документа.';

  @override
  String get emptyTable => 'Таблица пуста';

  @override
  String get legacyXlsFormatError =>
      'Старый формат Excel (.xls) требует открытия через внешнее приложение.';

  @override
  String get openExternalApp => 'Открыть во внешнем приложении';

  @override
  String get columnPrefix => 'Кол';

  @override
  String get renameFile => 'Переименовать файл';

  @override
  String get newFileName => 'Новое имя файла';

  @override
  String get save => 'Сохранить';

  @override
  String get file_saved_success => 'Файл успешно сохранен';

  @override
  String get save_error => 'Ошибка сохранения файла';

  @override
  String get save_changes => 'Сохранить изменения';

  @override
  String get write_text_here => 'Введите текст здесь...';

  @override
  String get column => 'Столбец';

  @override
  String get open_external => 'Открыть извне';

  @override
  String get empty_file => 'Пустой файл';

  @override
  String get empty_page => 'Пустая страница';
}
