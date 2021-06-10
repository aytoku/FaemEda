import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Localization/app_localizations.dart';
import 'package:flutter_app/Preloader/device_id_screen.dart';
import 'package:flutter_app/Screens/PaymentScreen/View/payment_screen.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Preloader/device_id_screen.dart';
import 'data/data.dart';

class App extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: "Помидор",
      theme: ThemeData(
        primaryColor: AppColor.mainColor,
        cursorColor: AppColor.mainColor,
        unselectedWidgetColor: AppColor.mainColor,
        selectedRowColor: AppColor.mainColor,
        toggleableActiveColor: AppColor.mainColor,
      ),
      home: DeviceIdScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocaleList) {
        for (var v in supportedLocaleList) {
          if (v.languageCode == locale.languageCode &&
              v.countryCode == locale.countryCode) {
            return locale;
          }
        }
        return supportedLocaleList.first;
      },
      supportedLocales: [
        const Locale('ru', 'RU'),
        const Locale('en', 'US'),
      ],
    );
  }
}
