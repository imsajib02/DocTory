import 'package:doctory/model/language.dart';
import 'package:flutter/material.dart';

abstract class View {

  void setSelection(int index);
  void removeSelection(int index);
}

abstract class Presenter {

  void isLanguageSelected(Language language, int index);
  void changeLanguage(BuildContext context, Language language, SupportedLanguage supportedLanguage);
}