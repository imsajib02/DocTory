import 'package:doctory/model/phone_verification_route_parameter.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/model/registration_route_parameter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class View {

  void fillInTextFields();
  void onEmpty(String message);
  void onInvalidInput(String message);
  void onError(String message);
  void showProgressDialog(String message);
  void updateProgressDialog(String message);
  void hideProgressDialog();
  void gotToPhoneVerificationPage(PhoneVerificationRouteParameter routeParameter);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void isPhoneVerified(RegistrationRouteParameter routeParameter);
  void validateInput(BuildContext context, User registrationData, String previousNumberInput, FirebaseUser firebaseUser);
}