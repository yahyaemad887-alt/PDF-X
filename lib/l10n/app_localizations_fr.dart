// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcome_title => 'Bienvenue';

  @override
  String get select_language_desc =>
      'Veuillez sélectionner votre langue préférée';

  @override
  String get continue_button => 'Continuer';

  @override
  String get share_error => 'Erreur lors du partage du fichier';

  @override
  String get jump_to_page => 'Aller à la page';

  @override
  String get enter_page_number => 'Entrer le numéro de page';

  @override
  String get cancel => 'Annuler';

  @override
  String get invalid_page_number => 'Numéro de page invalide';

  @override
  String get go => 'Aller';

  @override
  String get share_file => 'Partager le fichier';

  @override
  String get loading_pdf => 'Chargement du PDF...';

  @override
  String get file_read_error => 'Erreur de lecture du fichier';

  @override
  String get previous_page => 'Page précédente';

  @override
  String get next_page => 'Page suivante';

  @override
  String get openFileError => 'Erreur lors de l\'ouverture du fichier';

  @override
  String get deleteFile => 'Supprimer le fichier';

  @override
  String deleteConfirm(String name) {
    return 'Voulez-vous vraiment supprimer \'$name\' ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get searchHint => 'Rechercher des documents...';

  @override
  String get appTitle => 'PDF X';

  @override
  String get all => 'Tout';

  @override
  String get filesSuffix => 'fichiers';

  @override
  String get pdf => 'PDF';

  @override
  String get word => 'Word';

  @override
  String get excel => 'Excel';

  @override
  String get ppt => 'PowerPoint';

  @override
  String get txt => 'Texte';

  @override
  String get image => 'Images';

  @override
  String get guides => 'Explorateur';

  @override
  String get recent => 'Récents';

  @override
  String get bookmarks => 'Favoris';

  @override
  String get noDocuments => 'Aucun document trouvé';

  @override
  String get scanNow => 'Analyser';

  @override
  String get scanningStorage => 'Analyse du stockage...';

  @override
  String get open => 'Ouvrir';

  @override
  String get rename => 'Renommer';

  @override
  String get legacyDocFormatError =>
      'L\'ancien format Word (.doc) n\'est pas pris en charge pour l\'affichage direct.';

  @override
  String get documentReaderError =>
      'Désolé, une erreur s\'est produite lors de la lecture du document.';

  @override
  String get emptyTable => 'Tableau vide';

  @override
  String get legacyXlsFormatError =>
      'L\'ancien format Excel (.xls) nécessite une ouverture via une application externe.';

  @override
  String get openExternalApp => 'Ouvrir dans une application externe';

  @override
  String get columnPrefix => 'Col';

  @override
  String get renameFile => 'Renommer le fichier';

  @override
  String get newFileName => 'Nouveau nom de fichier';

  @override
  String get save => 'Enregistrer';

  @override
  String get file_saved_success => 'Fichier enregistré avec succès';

  @override
  String get save_error => 'Erreur lors de l\'enregistrement du fichier';

  @override
  String get save_changes => 'Enregistrer les modifications';

  @override
  String get write_text_here => 'Écrivez le texte ici...';

  @override
  String get column => 'Colonne';

  @override
  String get open_external => 'Ouvrir en externe';

  @override
  String get empty_file => 'Fichier vide';

  @override
  String get empty_page => 'Page vide';
}
