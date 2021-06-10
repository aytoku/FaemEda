import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AppLocalizations{
  Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationDelegate();

  static AppLocalizations of (BuildContext context){
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  AppLocalizations(this.locale);

  Map<String, String> languageMap = Map();
  Future load() async {
    final fileString =
        await rootBundle.loadString('assets/languages/${locale.languageCode}.json');
    final Map<String, dynamic> mapData = json.decode(fileString);
    languageMap = mapData.map((key, value) => MapEntry(key, value.toString()));
  }

  getTranslation(key){
    return languageMap[key];
  }
}


class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations>{

  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale){
    return ['ru', 'Акции и новинки'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async{
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}