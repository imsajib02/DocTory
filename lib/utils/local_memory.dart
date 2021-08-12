import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctory/localization/localization_constrants.dart';

import '../model/user.dart';

class LocalMemory {

  Future<SharedPreferences> _prefs;

  static const String LANGUAGE_CODE = "bhj6GF4Bu7gY";
  static const String LOGGED_USER = "gG5DTRD6chG";
  static const String FIRST_OPEN = "bbJHFVf56rtG";

  LocalMemory() {

    _prefs = SharedPreferences.getInstance();
  }


  Future<Locale> saveLanguageCode(String languageCode) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setString(LANGUAGE_CODE, languageCode);

    return getLocale(languageCode);
  }

  Future<Locale> getLanguageCode() async {

    final SharedPreferences prefs = await _prefs;
    String languageCode = prefs.getString(LANGUAGE_CODE) ?? ENGLISH;

    return getLocale(languageCode);
  }

  saveUser(User user) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setString(LOGGED_USER, json.encode(user.toLocal()));
  }

  Future<User> getUser() async {

    final SharedPreferences prefs = await _prefs;
    User user = User(auth: false);

    if(prefs.containsKey(LOGGED_USER)) {

      var data = json.decode(await prefs.get(LOGGED_USER));
      user = User.fromLocal(data);
      user.auth = true;
    }

    return user;
  }

  setFirstOpenOrNot(bool value) async {

    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(FIRST_OPEN, value);
  }

  Future<bool> isFirstOpen() async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(FIRST_OPEN)) {

      return false;
    }

    return true;
  }

  Future<Set<String>> getAllKeys() async {

    final SharedPreferences prefs = await _prefs;
    return prefs.getKeys();
  }

  Future<bool> clearAllData() async {

    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  Future remove(String key) async {

    final SharedPreferences prefs = await _prefs;

    if(prefs.containsKey(key)) {

      await prefs.remove(key);
    }
  }
}