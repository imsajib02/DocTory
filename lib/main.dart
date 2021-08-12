import 'dart:async';

import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/app_theme.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/local_memory.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(
      ChangeNotifierProvider<AppThemeNotifier>(
        create: (context) => AppThemeNotifier(),
        child: MyApp(),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();


  static void setLocale(BuildContext context, Locale locale) {

    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {

  Locale _locale;
  LocalMemory _localMemory;

  @override
  void initState() {

    _localMemory = LocalMemory();
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _localMemory.getLanguageCode().then((locale) {

      setLocale(locale);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (context, constraints) {

          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);

              return Consumer<AppThemeNotifier>(
                builder: (context, appThemeState, child) {

                  return MaterialApp(
                    title: "Doctory",
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: appThemeState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
                    locale: _locale,
                    localizationsDelegates: [
                      AppLocalization.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: [
                      Locale("en", "US"),
                      Locale("bn", "BD"),
                    ],
                    localeResolutionCallback: (Locale deviceLocale, Iterable<Locale> supportedLocales) {

                      for(var locale in supportedLocales) {

                        if(locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode) {

                          return deviceLocale;
                        }
                      }

                      return supportedLocales.first;
                    },
                    onGenerateRoute: RouteManager.generate,
                    initialRoute: RouteManager.SPLASH_PAGE_ROUTE,
                  );
                },
              );
            },
          );
        }
    );
  }


  void setLocale(Locale locale) {

    CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "App Language", message: locale.languageCode);

    setState(() {
      _locale = locale;
    });
  }
}
