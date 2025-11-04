import 'package:capek_mikir/config/router.dart';
import 'package:capek_mikir/provider/app_state_provider.dart';
import 'package:capek_mikir/provider/user_state_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool enableDynamicColor;

  const MyApp({
    super.key,
    this.enableDynamicColor = true
  });

  static final _defaultLightColorScheme = ColorScheme.fromSeed(
      seedColor: Color(0xFF01197E),
      brightness: Brightness.light
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
      seedColor: Color(0xFF01197E),
      brightness: Brightness.dark
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final lightColorScheme = enableDynamicColor && lightDynamic != null ? lightDynamic : _defaultLightColorScheme;
        final darkColorScheme = enableDynamicColor && darkDynamic != null ? darkDynamic : _defaultDarkColorScheme;

        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => UserStateProvider()),
              ChangeNotifierProxyProvider<UserStateProvider, AppStateProvider>(
                create: (context) => AppStateProvider(context.read<UserStateProvider>()),
                update: (context, userProvider, appState) {
                  appState ??= AppStateProvider(userProvider);
                  appState.restartQuiz(userProvider);
                  return appState;
                },
              ),
            ],
            child: MaterialApp.router(
              title: "Capek Mikir",
              theme: ThemeData(
                  fontFamily: "Delius",
                  colorScheme: lightColorScheme
              ),
              darkTheme: ThemeData(
                  fontFamily: "Delius",
                  colorScheme: darkColorScheme
              ),
              routerConfig: createRouter(),
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
            )
        );
      },
    );
  }
}