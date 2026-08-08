// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dokumentenleser';

  @override
  String get searchHint => 'Suchen nach Name...';

  @override
  String get all => 'Alle';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => 'Dateien';

  @override
  String get recent => 'Verlauf';

  @override
  String get bookmarks => 'Lesezeichen';

  @override
  String get noDocuments => 'Keine Dokumente gefunden';

  @override
  String get scanNow => 'Speicher scannen';

  @override
  String get renameFile => 'Datei umbenennen';

  @override
  String get newFileName => 'Neuer Dateiname';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get deleteFile => 'Datei löschen';

  @override
  String deleteConfirm(Object fileName) {
    return 'Möchten Sie \"$fileName\" wirklich löschen?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get open => 'Öffnen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get scanningStorage => 'Speicher wird gescannt...';

  @override
  String get fileReadError => 'Fehler beim Lesen der Datei';

  @override
  String get fileSavedSuccess => 'Datei erfolgreich gespeichert';

  @override
  String get saveError => 'Fehler beim Speichern';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get writeTextHere => 'Text hier schreiben...';

  @override
  String get column => 'Spalte';

  @override
  String get emptyFile => 'Datei ist leer';

  @override
  String get emptyPage => 'Leere Seite';

  @override
  String get openExternal => 'Mit externer App öffnen';

  @override
  String get shareError => 'Fehler beim Teilen';

  @override
  String get jumpToPage => 'Gehe zu Seite';

  @override
  String get enterPageNumber => 'Seitennummer eingeben';

  @override
  String get go => 'Los';

  @override
  String get invalidPageNumber => 'Ungültige Seitennummer';

  @override
  String get shareFile => 'Datei teilen';

  @override
  String get loadingPdf => 'PDF wird geladen...';

  @override
  String get previousPage => 'Vorherige Seite';

  @override
  String get nextPage => 'Nächste Seite';
}
