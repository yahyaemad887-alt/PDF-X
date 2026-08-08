import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui.dart';

/// نقطة الانطلاق الرئيسية للتطبيق (Bootstrap Entry Point)
void main() {
  // تغليف التطبيق داخل Zone معزولة لالتقاط كافة أخطاء الـ Async والـ Null غير المتوقعة
  runZonedGuarded<Future<void>>(() async {
    // 1. ضمان تهيئة محرك Flutter قبل استدعاء أي خدمات أو Native APIs
    WidgetsFlutterBinding.ensureInitialized();

    // 2. ضبط توجيه الشاشة وحماية واجهة النظام من التشوه
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 3. درع حماية لأخطاء بناء الواجهات (Widget Render Errors)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('[Flutter Boundary Error]: ${details.exception}');
    };

    // 4. تشغيل التطبيق المباشر المستورد من ui.dart
    runApp(const PdfToolsApp());
  }, (Object error, StackTrace stack) {
    // حارس الأخطاء العام لمنع انهيار التطبيق (Crash Guard)
    debugPrint('[Uncaught Async Error]: $error');
  });
}