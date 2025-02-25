import 'package:auto_route/auto_route.dart';
import 'package:my_books_to_read/core/auth/auth_provider.dart';
import 'package:my_books_to_read/core/utils/snackbar_utils.dart';
import 'package:my_books_to_read/pages/auth/view/auth_page.dart';
import 'package:my_books_to_read/pages/dashboard/view/dashboard_page.dart';
import 'package:my_books_to_read/pages/home/view/home_page.dart';
import 'package:my_books_to_read/pages/saved_books/view/saved_books_page.dart';
import 'package:my_books_to_read/pages/settings/view/settings_page.dart';
import 'package:provider/provider.dart';

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
        AutoRoute(page: SavedBooksRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: AuthRoute.page, guards: [AuthGuard()]),
  ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    final authProvider = context!.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      SnackbarUtils.showSnackBar(context, message: 'Already logged in');
      router.replaceAll([const DashboardRoute()]);
    } else {
      resolver.next();
    }
  }
}
