import 'package:doctory/model/user.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showSelectedTab(int index, Widget tab, {Widget appbarTitle});
  void showAlertOnExit();
}

abstract class Presenter {

  void onTabSelected(BuildContext context, int index, User currentUser);
  Future<bool> onBackPress(int currentTab, User currentUser);
}