class ModuleTemplates {
  static String binding(String projectName, String moduleName) {
    final pascal = _pascal(moduleName);
    final snake = _snake(moduleName);
    return '''
import 'package:get/get.dart';

import '../controllers/${snake}_controller.dart';

class ${pascal}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pascal}Controller>(
      () => ${pascal}Controller(),
    );
  }
}
''';
  }

  static String controller(String projectName, String moduleName) {
    final pascal = _pascal(moduleName);
    return '''
import 'package:get/get.dart';

class ${pascal}Controller extends GetxController {
  // Observables
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    // TODO: Initialize
  }
}
''';
  }

  static String view(String projectName, String moduleName) {
    final pascal = _pascal(moduleName);
    final snake = _snake(moduleName);
    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/${snake}_controller.dart';

class ${pascal}View extends GetView<${pascal}Controller> {
  const ${pascal}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$pascal'),
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Center(
                child: Text('$pascal Page'),
              ),
      ),
    );
  }
}
''';
  }

  static String splashView(String projectName) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../../../routes/app_routes.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              '${_title(projectName)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
''';

  static String _pascal(String s) => s
      .split(RegExp(r'[_\-\s]+'))
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join();

  static String _snake(String s) => s
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '\${m[1]}_\${m[2]}')
      .replaceAll(RegExp(r'[\-\s]+'), '_')
      .toLowerCase();

  static String _title(String name) => name
      .split('_')
      .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
