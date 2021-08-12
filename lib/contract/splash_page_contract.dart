import 'package:flutter/material.dart';
import '../model/user.dart';

abstract class View {

  void showNoInternetView();
  void showTimeOutView();
  void showTurnOnConnectionView();
  void showSplashView();
  void showErrorView();
  void showForceUpdateView(BuildContext context, String appLink);
  void showOptionalUpdateView(BuildContext context, String appLink);
  void goToLoginPage();
  void sendUserToDashboard(User loggedUser);
}

abstract class Presenter {

  void getAppDetails(BuildContext context, bool isRetrying);
}