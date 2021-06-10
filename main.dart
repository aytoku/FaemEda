import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app.dart';

void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, // Color for Android
      statusBarBrightness: Brightness.light // Dark == white status bar -- for IOS.
  ));
  runApp(App());
}
