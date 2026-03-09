import 'dart:io';
import '../utils/logger.dart';
import 'templates/core_templates.dart';
import 'templates/data_templates.dart';
import 'templates/route_templates.dart';
import 'templates/module_templates.dart';

class ProjectGenerator {
  static Future<void> generate({
    required Directory projectDir,
    required String projectName,
    required String org,
  }) async {
    final libDir = Directory('${projectDir.path}${Platform.pathSeparator}lib');

    // Clean existing lib
    if (libDir.existsSync()) {
      libDir.deleteSync(recursive: true);
    }
    libDir.createSync(recursive: true);

    final sep = Platform.pathSeparator;

    // ── Directory structure ──────────────────────────────────
    final dirs = [
      'app${sep}core${sep}theme',
      'app${sep}core${sep}widgets',
      'app${sep}core${sep}utils',
      'app${sep}core${sep}constants',
      'app${sep}data${sep}entities',
      'app${sep}data${sep}models',
      'app${sep}data${sep}providers',
      'app${sep}data${sep}repositories',
      'app${sep}data${sep}services',
      'app${sep}data${sep}usecases',
      'app${sep}modules${sep}splash${sep}bindings',
      'app${sep}modules${sep}splash${sep}controllers',
      'app${sep}modules${sep}splash${sep}views',
      'app${sep}routes',
      'app${sep}widgets',
    ];

    for (final d in dirs) {
      Directory('${libDir.path}$sep$d').createSync(recursive: true);
    }

    CliLogger.step('Creating files...');

    final files = <String, String>{
      // ── Root ────────────────────────────────────────────────
      'main.dart': CoreTemplates.mainDart(projectName),
      'app${sep}di.dart': CoreTemplates.diDart(projectName),

      // ── Core ────────────────────────────────────────────────
      'app${sep}core${sep}theme${sep}app_theme.dart': CoreTemplates.appTheme(),
      'app${sep}core${sep}constants${sep}app_constants.dart': CoreTemplates.appConstants(),
      'app${sep}core${sep}utils${sep}extensions.dart': CoreTemplates.extensions(),
      'app${sep}core${sep}widgets${sep}loading_widget.dart': CoreTemplates.loadingWidget(),
      'app${sep}core${sep}widgets${sep}error_widget.dart': CoreTemplates.errorWidget(),
      'app${sep}core${sep}widgets${sep}empty_widget.dart': CoreTemplates.emptyWidget(),
      'app${sep}core${sep}widgets${sep}widgets.dart': CoreTemplates.widgetsExport(),

      // ── Data ────────────────────────────────────────────────
      'app${sep}data${sep}services${sep}network_service.dart': DataTemplates.networkService(projectName),
      'app${sep}data${sep}providers${sep}base_provider.dart': DataTemplates.baseProvider(projectName),
      'app${sep}data${sep}repositories${sep}base_repository.dart': DataTemplates.baseRepository(projectName),

      // ── Routes ──────────────────────────────────────────────
      'app${sep}routes${sep}app_routes.dart': RouteTemplates.appRoutes(),
      'app${sep}routes${sep}app_pages.dart': RouteTemplates.appPages(projectName),
      'app${sep}routes${sep}routes.dart': RouteTemplates.routesExport(projectName),

      // ── Splash module ────────────────────────────────────────
      'app${sep}modules${sep}splash${sep}bindings${sep}splash_binding.dart':
          ModuleTemplates.binding(projectName, 'splash'),
      'app${sep}modules${sep}splash${sep}controllers${sep}splash_controller.dart':
          ModuleTemplates.controller(projectName, 'splash'),
      'app${sep}modules${sep}splash${sep}views${sep}splash_view.dart':
          ModuleTemplates.splashView(projectName),
    };

    for (final entry in files.entries) {
      final file = File('${libDir.path}$sep${entry.key}');
      file.writeAsStringSync(entry.value);
      CliLogger.file('lib${sep}${entry.key}');
    }

    // ── Update pubspec.yaml ─────────────────────────────────
    await _updatePubspec(projectDir, projectName);
  }

  static Future<void> _updatePubspec(Directory projectDir, String projectName) async {
    final pubspecFile = File(
      '${projectDir.path}${Platform.pathSeparator}pubspec.yaml',
    );
    if (!pubspecFile.existsSync()) return;

    CliLogger.step('Updating pubspec.yaml with required dependencies...');

    String content = pubspecFile.readAsStringSync();

    const deps = '''
  # State management & navigation
  get: ^4.6.6

  # Network
  dio: ^5.4.0

  # Local storage
  get_storage: ^2.1.1

  # Flutter dotenv
  flutter_dotenv: ^5.1.0
''';

    // Insert after "dependencies:" line
    if (!content.contains('get:') && content.contains('dependencies:')) {
      content = content.replaceFirst(
        RegExp(r'dependencies:\s*\n  flutter:'),
        'dependencies:\n$deps  flutter:',
      );
      pubspecFile.writeAsStringSync(content);
      CliLogger.success('  pubspec.yaml updated.');
    }
  }
}
