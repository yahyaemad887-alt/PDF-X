// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Чтец Документов';

  @override
  String get searchHint => 'Поиск по имени...';

  @override
  String get all => 'Все';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => 'файлов';

  @override
  String get recent => 'Недавние';

  @override
  String get bookmarks => 'Закладки';

  @override
  String get noDocuments => 'Документы не найдены';

  @override
  String get scanNow => 'Сканировать память';

  @override
  String get renameFile => 'Переименовать файл';

  @override
  String get newFileName => 'Новое имя файла';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get deleteFile => 'Удалить файл';

  @override
  String deleteConfirm(Object fileName) {
    return 'Удалить файл \"$fileName\" безвозвратно?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get open => 'Открыть';

  @override
  String get rename => 'Переименовать';

  @override
  String get scanningStorage => 'Сканирование памяти...';

  @override
  String get fileReadError => 'Ошибка чтения файла';

  @override
  String get fileSavedSuccess => 'Файл успешно сохранен';

  @override
  String get saveError => 'Ошибка при сохранении';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get writeTextHere => 'Введите текст здесь...';

  @override
  String get column => 'Столбец';

  @override
  String get emptyFile => 'Файл пуст';

  @override
  String get emptyPage => 'Пустая страница';

  @override
  String get openExternal => 'Открыть во внешнем приложении';

  @override
  String get shareError => 'Ошибка при отправке';

  @override
  String get jumpToPage => 'Перейти к странице';

  @override
  String get enterPageNumber => 'Введите номер страницы';

  @override
  String get go => 'Перейти';

  @override
  String get invalidPageNumber => 'Неверный номер страницы';

  @override
  String get shareFile => 'Поделиться файлом';

  @override
  String get loadingPdf => 'Загрузка PDF...';

  @override
  String get previousPage => 'Предыдущая страница';

  @override
  String get nextPage => 'Следующая страница';
}
