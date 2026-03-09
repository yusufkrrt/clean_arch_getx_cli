class CoreTemplates {
  static String mainDart(String projectName) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/di.dart';
import 'app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${_title(projectName)}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
''';

  static String diDart(String projectName) => '''
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/services/network_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Local storage initialization
    await GetStorage.init();

    // Core services
    Get.put<NetworkService>(NetworkService(), permanent: true);
  }
}
''';

  static String appTheme() => '''
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
''';

  static String appConstants() => '''
class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = '';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String tokenKey = 'auth_token';
}
''';

  static String extensions() => '''
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

extension StringExt on String {
  bool get isValidEmail =>
      RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(this);
  bool get isNullOrEmpty => isEmpty;
  String get capitalize =>
      isEmpty ? '' : '\${this[0].toUpperCase()}\${substring(1)}';
}

extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
''';

  static String loadingWidget() => '''
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
''';

  static String errorWidget() => '''
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
''';

  static String emptyWidget() => '''
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  final IconData? icon;

  const EmptyWidget({
    super.key,
    this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No data found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
''';

  static String widgetsExport() => '''
export 'loading_widget.dart';
export 'error_widget.dart';
export 'empty_widget.dart';
''';

  static String _title(String name) =>
      name.split('_').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ');
}
