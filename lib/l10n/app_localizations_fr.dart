// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lecteur de Documents';

  @override
  String get searchHint => 'Rechercher par nom...';

  @override
  String get all => 'Tous';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => 'fichiers';

  @override
  String get recent => 'Récents';

  @override
  String get bookmarks => 'Favoris';

  @override
  String get noDocuments => 'Aucun document trouvé';

  @override
  String get scanNow => 'Analyser le stockage';

  @override
  String get renameFile => 'Renommer le fichier';

  @override
  String get newFileName => 'Nouveau nom';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get deleteFile => 'Supprimer le fichier';

  @override
  String deleteConfirm(Object fileName) {
    return 'Voulez-vous vraiment supprimer \"$fileName\" ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get open => 'Ouvrir';

  @override
  String get rename => 'Renommer';

  @override
  String get scanningStorage => 'Analyse du stockage...';

  @override
  String get fileReadError => 'Erreur lors de la lecture du fichier';

  @override
  String get fileSavedSuccess => 'Fichier enregistré avec succès';

  @override
  String get saveError => 'Erreur lors de l\'enregistrement';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get writeTextHere => 'Écrivez le texte ici...';

  @override
  String get column => 'Colonne';

  @override
  String get emptyFile => 'Fichier vide';

  @override
  String get emptyPage => 'Page vide';

  @override
  String get openExternal => 'Ouvrir avec une application externe';

  @override
  String get shareError => 'Erreur lors du partage';

  @override
  String get jumpToPage => 'Aller à la page';

  @override
  String get enterPageNumber => 'Entrez le numéro de page';

  @override
  String get go => 'Aller';

  @override
  String get invalidPageNumber => 'Numéro de page invalide';

  @override
  String get shareFile => 'Partager le fichier';

  @override
  String get loadingPdf => 'Chargement du PDF...';

  @override
  String get previousPage => 'Page précédente';

  @override
  String get nextPage => 'Page suivante';
}
