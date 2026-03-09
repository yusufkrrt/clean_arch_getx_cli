class CliLogger {
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _cyan = '\x1B[36m';
  static const _blue = '\x1B[34m';

  static void header(String msg) => print('\n$_bold$_cyan$msg$_reset');
  static void step(String msg) => print('$_blue  ▶ $msg$_reset');
  static void success(String msg) => print('$_green$msg$_reset');
  static void info(String msg) => print('$_yellow  $msg$_reset');
  static void error(String msg) => print('$_red❌ $msg$_reset');
  static void file(String path) => print('$_green    ✔ $path$_reset');
}
