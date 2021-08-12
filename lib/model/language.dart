import 'package:doctory/resources/images.dart';

class Language {

  String languageCode;
  String englishName;
  String localName;
  String flag;
  bool isSelected;

  Language(this.languageCode, this.englishName, this.localName, this.flag, {this.isSelected = false});
}

class SupportedLanguage {

  List<Language> list;

  SupportedLanguage() {

    this.list = [
      Language("en", "English", "English", Images.usaFlag),
      Language("bn", "Bangla", "বাংলা", Images.bdFlag)
    ];
  }
}
