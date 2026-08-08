// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lector de Documentos';

  @override
  String get searchHint => 'Buscar por nombre...';

  @override
  String get all => 'Todos';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => 'archivos';

  @override
  String get recent => 'Recientes';

  @override
  String get bookmarks => 'Marcadores';

  @override
  String get noDocuments => 'No hay documentos';

  @override
  String get scanNow => 'Escanear almacenamiento';

  @override
  String get renameFile => 'Renombrar archivo';

  @override
  String get newFileName => 'Nuevo nombre';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get deleteFile => 'Eliminar archivo';

  @override
  String deleteConfirm(Object fileName) {
    return '¿Eliminar permanentemente \"$fileName\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get open => 'Abrir';

  @override
  String get rename => 'Renombrar';

  @override
  String get scanningStorage => 'Escaneando almacenamiento...';

  @override
  String get fileReadError => 'Error al leer el archivo';

  @override
  String get fileSavedSuccess => 'Archivo guardado con éxito';

  @override
  String get saveError => 'Error al guardar el archivo';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get writeTextHere => 'Escribe el texto aquí...';

  @override
  String get column => 'Columna';

  @override
  String get emptyFile => 'Archivo vacío';

  @override
  String get emptyPage => 'Página vacía';

  @override
  String get openExternal => 'Abrir con aplicación externa';

  @override
  String get shareError => 'Error al compartir';

  @override
  String get jumpToPage => 'Ir a la página';

  @override
  String get enterPageNumber => 'Ingrese el número de página';

  @override
  String get go => 'Ir';

  @override
  String get invalidPageNumber => 'Número de página no válido';

  @override
  String get shareFile => 'Compartir archivo';

  @override
  String get loadingPdf => 'Cargando PDF...';

  @override
  String get previousPage => 'Página anterior';

  @override
  String get nextPage => 'Página siguiente';
}
