import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui.dart';

/// نقطة الانطلاق الرئيسية للتطبيق (Bootstrap Entry Point)
void main() {
  runZonedGuarded<Future<void>>(() async {
    // 1. ضمان تهيئة محرك Flutter قبل استدعاء أي خدمات أو Native APIs
    WidgetsFlutterBinding.ensureInitialized();

    // 2. ضبط توجيه الشاشة على الوضع الرأسي فقط
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 3. حارس أخطاء بناء واجهة المستخدم (Widget Framework Errors)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('[Flutter Boundary Error]: ${details.exception}');
    };

    // 4. حارس الأخطاء البرمجية غير الملتقطة على مستوى المحرك (Platform Dispatcher)
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('[Platform Dispatcher Error]: $error');
      return true;
    };

    // 5. تشغيل التطبيق مباشرة (الكلاس نفسه هيتولى تحميل الإعدادات)
    runApp(const PdfToolsApp());

  }, (Object error, StackTrace stack) {
    // حارس الأخطاء العام للعمليات غير المتزامنة (Uncaught Async Guard)
    debugPrint('[Uncaught Async Error]: $error');
  });
}