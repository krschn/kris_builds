import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

import 'core/navigation/app_auth_navigation.dart';
import 'core/router/app_router.dart';

/// Example custom theme configuration.
///
/// Uncomment and modify to customize the app's colors and typography.
// const appThemeConfig = AppThemeConfig(
//   primaryLight: Color(0xFF2563EB),  // Custom blue
//   primaryDark: Color(0xFF60A5FA),
//   fontFamily: 'Inter',  // Custom font
// );

/// The root widget of the application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    // To use custom theming, uncomment the config above and pass it:
    // theme: AppTheme.light(appThemeConfig),
    // darkTheme: AppTheme.dark(appThemeConfig),

    return AuthNavigationProvider(
      delegate: const AppAuthNavigationDelegate(),
      child: MaterialApp.router(
        title: 'Example App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router(authBloc),
      ),
    );
  }
}
