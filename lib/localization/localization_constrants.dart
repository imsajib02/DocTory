import 'package:doctory/localization/app_localization.dart';
import 'package:flutter/material.dart';

const String ENGLISH = "en";
const String BANGLA = "bn";

Locale getLocale(String languageCode) {

  Locale _locale;

  switch(languageCode) {

    case ENGLISH:
      _locale = Locale(languageCode, "US");
      break;

    case BANGLA:
      _locale = Locale(languageCode, "BD");
      break;

    default:
      _locale = Locale(ENGLISH, "US");
  }

  return _locale;
}