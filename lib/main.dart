import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Clean Architecture dependency injection
  ServiceLocator.instance.init();

  // Set system UI overlay style for modern edge-to-edge transparent look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const IsharatyApp());
}
