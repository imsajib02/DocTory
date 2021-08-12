import 'package:doctory/model/phone_verification_route_parameter.dart';
import 'package:doctory/model/user.dart';
import 'package:flutter/material.dart';

abstract class View {

  void onEmpty(String message);
  void onInvalidInput(String message);
  void onError(String message);
  void showProgressDialog(String message);
  void updateProgressDialog(String message);
  void hideProgressDialog();
  void goToPhoneVerificationPage(PhoneVerificationRouteParameter routeParameter);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void validateInput(BuildContext context, User recoveryData);
}