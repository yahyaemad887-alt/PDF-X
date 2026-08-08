// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '文档阅读器';

  @override
  String get searchHint => '按文件名搜索...';

  @override
  String get all => '全部';

  @override
  String get pdf => 'PDF';

  @override
  String get excel => 'Excel';

  @override
  String get txt => 'TXT';

  @override
  String get filesSuffix => '个文件';

  @override
  String get recent => '最近';

  @override
  String get bookmarks => '书签';

  @override
  String get noDocuments => '未找到文档';

  @override
  String get scanNow => '立即扫描存储';

  @override
  String get renameFile => '重命名文件';

  @override
  String get newFileName => '新文件名';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get deleteFile => '删除文件';

  @override
  String deleteConfirm(Object fileName) {
    return '确定要永久删除 \"$fileName\" 吗？';
  }

  @override
  String get delete => '删除';

  @override
  String get open => '打开';

  @override
  String get rename => '重命名';

  @override
  String get scanningStorage => '正在扫描存储...';

  @override
  String get fileReadError => '读取文件时出错';

  @override
  String get fileSavedSuccess => '文件保存成功';

  @override
  String get saveError => '保存文件时出错';

  @override
  String get saveChanges => '保存更改';

  @override
  String get writeTextHere => '在此处输入文本...';

  @override
  String get column => '列';

  @override
  String get emptyFile => '文件为空';

  @override
  String get emptyPage => '空白页';

  @override
  String get openExternal => '使用外部应用打开';

  @override
  String get shareError => '分享文件时出错';

  @override
  String get jumpToPage => '跳转到页码';

  @override
  String get enterPageNumber => '输入页码';

  @override
  String get go => '前往';

  @override
  String get invalidPageNumber => '页码无效';

  @override
  String get shareFile => '分享文件';

  @override
  String get loadingPdf => '正在加载 PDF...';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';
}
