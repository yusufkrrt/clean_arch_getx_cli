import 'dart:io';
import 'package:args/command_runner.dart';
import '../generators/project_generator.dart';
import '../utils/logger.dart';

class CreateCommand extends Command<void> {
  @override
  String get name => 'create';

  @override
  String get description =>
      'Creates a new Flutter project with GetX Clean Architecture structure.\n'
      'Usage: getx_cli create <project_name> [options]';

  CreateCommand() {
    argParser
      ..addOption(
        'org',
        abbr: 'o',
        help: 'Organization identifier (e.g. com.example)',
        defaultsTo: 'com.example',
      )
      ..addFlag(
        'no-flutter',
        negatable: false,
        help: 'Skip running "flutter create" (apply structure to existing project).',
      );
  }

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    if (args.isEmpty) {
      CliLogger.error('Please provide a project name.');
      CliLogger.info('Usage: getx_cli create <project_name>');
      exit(1);
    }

    final projectName = args.first;
    final org = argResults!['org'] as String;
    final noFlutter = argResults!['no-flutter'] as bool;

    CliLogger.header('🚀 GetX Clean Architecture Generator');
    CliLogger.info('Project: $projectName');
    CliLogger.info('Organization: $org');

    final targetDir = Directory(
      '${Directory.current.path}${Platform.pathSeparator}$projectName',
    );

    if (!noFlutter) {
      CliLogger.step('Running flutter create...');
      final result = await Process.run(
        'flutter',
        ['create', '--org', org, projectName],
        workingDirectory: Directory.current.path,
        runInShell: true,
      );
      if (result.exitCode != 0) {
        CliLogger.error('flutter create failed:\n${result.stderr}');
        exit(1);
      }
      CliLogger.success('Flutter project created.');
    } else {
      if (!targetDir.existsSync()) {
        CliLogger.error('Directory not found: ${targetDir.path}');
        exit(1);
      }
    }

    CliLogger.step('Generating GetX Clean Architecture structure...');
    await ProjectGenerator.generate(
      projectDir: targetDir,
      projectName: projectName,
      org: org,
    );

    CliLogger.success('\n✅ Project "$projectName" is ready!');
    _printNextSteps(projectName);
  }

  void _printNextSteps(String projectName) {
    print('\n📋 Next Steps:');
    print('  cd $projectName');
    print('  flutter pub get');
    print('  flutter run');
    print('\n💡 Add a new module:');
    print('  cd $projectName && getx_cli module <module_name>');
  }
}
