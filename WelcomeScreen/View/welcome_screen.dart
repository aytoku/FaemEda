import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Color(0xFFFF311D)),
    );
    return Scaffold(
      backgroundColor: Color(0xFFFF311D),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 88, vertical: 178),
            child: Lottie.asset(
              'assets/gif/pomidor_without_leaf.json',
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 39),
                child: Text(
                  'В настоящий момент сервис доступен только по приглашениям.',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 31, vertical: 27),
                child: MaterialButton(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.5),
                  minWidth: MediaQuery.of(context).size.width,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => AuthGetBloc(),
                          child: AuthScreen(),
                        ),
                      ),
                    );
                    AmplitudeAnalytics.analytics.logEvent('have_access ', eventProperties: {
                      'phone': necessaryDataForAuth.phone_number
                    });
                  },
                  child: Text(
                    'У меня уже есть доступ',
                    style: TextStyle(color: Color(0xFFFF311D), fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(height: 26),
            ],
          ),
        ],
      ),
    );
  }
}
