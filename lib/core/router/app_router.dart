import 'package:auto_route/auto_route.dart';
import 'package:my_books_to_read/pages/dashboard/view/dashboard_page.dart';
import 'package:my_books_to_read/pages/home/view/home_page.dart';
import 'package:my_books_to_read/pages/saved/view/saved_page.dart';
import 'package:my_books_to_read/pages/settings/view/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: DashboardRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SavedRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
  ];
}
