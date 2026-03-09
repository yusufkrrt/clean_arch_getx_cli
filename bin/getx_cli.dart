import 'package:args/command_runner.dart';
import 'package:clean_arch_getx_cli/src/commands/create_command.dart';
import 'package:clean_arch_getx_cli/src/commands/module_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner<void>(
    'getx_cli',
    '🚀 Flutter GetX Clean Architecture CLI\n'
        'Generate production-ready Flutter projects with GetX clean architecture.\n',
  )
    ..addCommand(CreateCommand())
    ..addCommand(ModuleCommand());

  try {
    await runner.run(arguments);
  } catch (e) {
    print('❌ Error: $e');
  }
}
