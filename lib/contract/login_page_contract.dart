import 'package:doctory/model/user.dart';
import 'package:flutter/material.dart';

abstract class View {

  void onEmpty(String message);
  void onInvalidInput(String message);
  void onError(String message);
  void hideProgressDialog();
  void showProgressDialog(String message);
  void updateProgressDialog(String message);
  void sendUserToHomePage(User loggedUser);
  void sendUserToProfilePage(User loggedUser);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void validateLoginInput(BuildContext context, User loginData);
}