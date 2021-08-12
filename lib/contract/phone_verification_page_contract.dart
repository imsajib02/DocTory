import 'package:doctory/model/user.dart';
import 'package:doctory/model/registration_route_parameter.dart';
import 'package:flutter/material.dart';

abstract class View {

  void setRemainingTime(int remainingTime);
  void allowResendingCode();
  void showRemainingTimeView();
  void onError(String message);
  void showProgressDialog(String message);
  void updateProgressDialog(String message);
  void hideProgressDialog();
  void onCodeResend();
  void showPinErrorAnimation();
  void clearPinCodeFields();
  void updateMainBody();
  void setPhoneVerificationStatus(bool status);
  void setRegistrationStatus(bool status);
  void showPhoneVerifiedAlert(BuildContext context);
  void goToSetNewPasswordPage(User data);
  void sendBackToRegistrationPage();
  void goToRegistrationSuccessPage();
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void startCountDown();
  void resendCode(BuildContext context, User registrationData, bool allowed);
  void verifyPhoneNumber(BuildContext context, bool recoveringPassword, String verificationID, String otpCode, User data);
  Future<void> doRegistration(BuildContext context, User registrationData);
  Future<bool> onBackPressed(BuildContext context, bool recoveringPassword, User data, RegistrationRouteParameter routeParameter);
  Future<void> stopCountDownTimer();
}