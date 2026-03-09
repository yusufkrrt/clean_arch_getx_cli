import 'dart:io';
import 'package:args/command_runner.dart';
import '../generators/module_generator.dart';
import '../utils/logger.dart';

class ModuleCommand extends Command<void> {
  @override
  String get name => 'module';

  @override
  String get description =>
      'Generates a new GetX module (binding, controller, view) in an existing project.\n'
      'Usage: getx_cli module <module_name>';

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    if (args.isEmpty) {
      CliLogger.error('Please provide a module name.');
      CliLogger.info('Usage: getx_cli module <module_name>');
      exit(1);
    }

    final moduleName = args.first;
    final projectDir = Directory.current;

    // Validate we are inside a Flutter project
    final pubspec = File('${projectDir.path}${Platform.pathSeparator}pubspec.yaml');
    if (!pubspec.existsSync()) {
      CliLogger.error('No pubspec.yaml found. Run this command from the root of a Flutter project.');
      exit(1);
    }

    CliLogger.header('📦 GetX Module Generator');
    CliLogger.info('Module: $moduleName');
    CliLogger.info('Target: ${projectDir.path}');

    await ModuleGenerator.generate(
      projectDir: projectDir,
      moduleName: moduleName,
    );

    CliLogger.success('\n✅ Module "$moduleName" created!');
    _printRouteHints(moduleName);
  }

  void _printRouteHints(String moduleName) {
    final pascal = _toPascalCase(moduleName);
    final snake = _toSnakeCase(moduleName);
    final camel = _toCamelCase(moduleName);

    print('\n📋 Add to lib/app/routes/app_routes.dart:');
    print("  static const $camel = '/$snake';");

    print('\n📋 Add to lib/app/routes/app_pages.dart:');
    print("  GetPage(");
    print("    name: AppRoutes.$camel,");
    print("    page: () => ${pascal}View(),");
    print("    binding: ${pascal}Binding(),");
    print("  ),");
  }

  String _toPascalCase(String s) {
    return s
        .split(RegExp(r'[_\-\s]+'))
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join();
  }

  String _toCamelCase(String s) {
    final pascal = _toPascalCase(s);
    return pascal.isEmpty ? '' : '${pascal[0].toLowerCase()}${pascal.substring(1)}';
  }

  String _toSnakeCase(String s) {
    return s
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]}_${m[2]}')
        .replaceAll(RegExp(r'[\-\s]+'), '_')
        .toLowerCase();
  }
}
