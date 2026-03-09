class RouteTemplates {
  static String appRoutes() => '''
abstract class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  // Add more routes here
}
''';

  static String appPages(String projectName) => '''
import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    // Add more pages here
  ];
}
''';

  static String routesExport(String projectName) => '''
export 'app_routes.dart';
export 'app_pages.dart';
''';
}
