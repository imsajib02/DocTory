import 'package:doctory/model/user.dart';
import 'package:flutter/material.dart';

abstract class View {

  void onEmpty(String message);
  void onError(String message);
  void showProgressDialog(String message);
  void hideProgressDialog();
  void goToPasswordResetSuccessPage();
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void validateInput(BuildContext context, User user);
}