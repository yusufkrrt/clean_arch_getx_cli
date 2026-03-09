import 'dart:io';
import '../utils/logger.dart';
import 'templates/module_templates.dart';

class ModuleGenerator {
  static Future<void> generate({
    required Directory projectDir,
    required String moduleName,
  }) async {
    final sep = Platform.pathSeparator;

    // Detect project name from pubspec.yaml
    final projectName = _readProjectName(projectDir);

    final snake = _snake(moduleName);
    final moduleBase =
        '${projectDir.path}${sep}lib${sep}app${sep}modules$sep$snake';

    final dirs = [
      '${moduleBase}${sep}bindings',
      '${moduleBase}${sep}controllers',
      '${moduleBase}${sep}views',
    ];

    for (final d in dirs) {
      Directory(d).createSync(recursive: true);
    }

    CliLogger.step('Generating module files...');

    final files = <String, String>{
      '${moduleBase}${sep}bindings${sep}${snake}_binding.dart':
          ModuleTemplates.binding(projectName, moduleName),
      '${moduleBase}${sep}controllers${sep}${snake}_controller.dart':
          ModuleTemplates.controller(projectName, moduleName),
      '${moduleBase}${sep}views${sep}${snake}_view.dart':
          ModuleTemplates.view(projectName, moduleName),
    };

    for (final entry in files.entries) {
      final file = File(entry.key);
      file.writeAsStringSync(entry.value);
      final relative = entry.key.replaceAll('${projectDir.path}$sep', '');
      CliLogger.file(relative);
    }

    // Auto-update routes if they exist
    await _updateRoutes(projectDir, moduleName, projectName, snake);
  }

  static Future<void> _updateRoutes(
    Directory projectDir,
    String moduleName,
    String projectName,
    String snake,
  ) async {
    final sep = Platform.pathSeparator;
    final pascal = _pascal(moduleName);
    final camel = _camel(moduleName);

    // Update app_routes.dart
    final routesFile = File(
      '${projectDir.path}${sep}lib${sep}app${sep}routes${sep}app_routes.dart',
    );
    if (routesFile.existsSync()) {
      final content = routesFile.readAsStringSync();
      if (!content.contains("static const $camel")) {
        final updated = content.replaceFirst(
          '// Add more routes here',
          "static const $camel = '/$snake';\n  // Add more routes here",
        );
        routesFile.writeAsStringSync(updated);
        CliLogger.file('lib/app/routes/app_routes.dart  (updated)');
      }
    }

    // Update app_pages.dart
    final pagesFile = File(
      '${projectDir.path}${sep}lib${sep}app${sep}routes${sep}app_pages.dart',
    );
    if (pagesFile.existsSync()) {
      String content = pagesFile.readAsStringSync();

      final importBinding =
          "import '../modules/$snake/bindings/${snake}_binding.dart';";
      final importView =
          "import '../modules/$snake/views/${snake}_view.dart';";

      if (!content.contains(importBinding)) {
        // Add imports at the top after existing imports
        content = content.replaceFirst(
          "import 'app_routes.dart';",
          "$importBinding\n$importView\nimport 'app_routes.dart';",
        );
      }

      if (!content.contains("AppRoutes.$camel")) {
        content = content.replaceFirst(
          '// Add more pages here',
          '''GetPage(
      name: AppRoutes.$camel,
      page: () => const ${pascal}View(),
      binding: ${pascal}Binding(),
    ),
    // Add more pages here''',
        );
      }

      pagesFile.writeAsStringSync(content);
      CliLogger.file('lib/app/routes/app_pages.dart  (updated)');
    }
  }

  static String _readProjectName(Directory projectDir) {
    try {
      final pubspec = File(
        '${projectDir.path}${Platform.pathSeparator}pubspec.yaml',
      );
      final content = pubspec.readAsStringSync();
      final match = RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(content);
      return match?.group(1) ?? 'app';
    } catch (_) {
      return 'app';
    }
  }

  static String _pascal(String s) => s
      .split(RegExp(r'[_\-\s]+'))
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join();

  static String _camel(String s) {
    final p = _pascal(s);
    return p.isEmpty ? '' : '${p[0].toLowerCase()}${p.substring(1)}';
  }

  static String _snake(String s) => s
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .replaceAll(RegExp(r'[\-\s]+'), '_')
      .toLowerCase();
}
