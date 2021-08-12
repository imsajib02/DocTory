import 'dart:async';
import 'dart:convert';

import 'package:doctory/contract/phone_verification_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/model/registration_route_parameter.dart';
import 'package:doctory/resources/strings.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/utils/connection_check.dart';

class PhoneVerificationPresenter implements Presenter {

  View _view;
  FirebaseAuth _firebaseAuth;
  AuthCredential _authCredential;
  bool _failedToRegister;
  User _user;
  Timer _timer;

  PhoneVerificationPresenter(View view) {

    this._view = view;
    _failedToRegister = false;
    _firebaseAuth = FirebaseAuth.instance;
  }


  @override
  void startCountDown() {

    int timeOut = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {

      if(timeOut == 0) {

        timer.cancel();
        _view.allowResendingCode();
      }
      else if(timeOut > 0) {

        timeOut = timeOut - 1;
        _view.setRemainingTime(timeOut);
      }
    });
  }

  @override
  void resendCode(BuildContext context, User registrationData, bool allowed) {

    if(allowed) {

      checkInternetConnection().then((isConnected) {

        if(isConnected) {

          _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("resending_code_message"));

          String phoneNumber = "+88" + registrationData.mobile;

          _firebaseAuth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: Duration(seconds: 0),
            verificationCompleted: (authCredential) {
            },
            verificationFailed: (authException) {

              CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Phone Verification", message: authException.message);

              _view.hideProgressDialog();
              _view.onError(AppLocalization.of(context).getTranslatedValue("error_sending_code_message"));
            },
            codeSent: (verificationId, [token]) {

              //print(token);
            },
            codeAutoRetrievalTimeout: (verificationId) {

              CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Phone Verification", message: "OTP has been sent again");

              _view.hideProgressDialog();
              _view.onCodeResend();
              _view.showRemainingTimeView();
              startCountDown();
            },
          );
        }
        else {

          _view.onNoConnection();
        }
      });
    }
  }

  @override
  void verifyPhoneNumber(BuildContext context, bool recoveringPassword, String verificationID, String otpCode, User data) {

    if(otpCode.isNotEmpty) {

      checkInternetConnection().then((isConnected) {

        if(isConnected) {

          _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("verifying_code_message"));

          _authCredential = PhoneAuthProvider.getCredential(verificationId: verificationID, smsCode: otpCode);

          _firebaseAuth.signInWithCredential(_authCredential).then((authResult) async {

            if(authResult.user != null) {

              await stopCountDownTimer();

              if(recoveringPassword) {

                _view.goToSetNewPasswordPage(data);
              }
              else {

                _view.setPhoneVerificationStatus(true);
                _view.updateProgressDialog(AppLocalization.of(context).getTranslatedValue("verification_successful_message"));

                Timer(const Duration(milliseconds: 1000), () {

                  doRegistration(context, data);
                });
              }
            }
            else {

              CustomLogger.warning(trace: CustomTrace(StackTrace.current), tag: "Phone Verification", message: "OTP verification failed");

              await _phoneVerificationFailed();
              _view.onError(AppLocalization.of(context).getTranslatedValue("verification_failed_message"));
            }
          }).catchError((error) async {

            await _phoneVerificationFailed();

            if(error.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {

              CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Phone Verification", message: "Invalid OTP");

              _view.onError(AppLocalization.of(context).getTranslatedValue("invalid_verification_code_error"));
            }
            else {

              CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Phone Verification", message: "Failed to verify OTP");

              _view.onError(AppLocalization.of(context).getTranslatedValue("verification_failed_message"));
            }
          });
        }
        else {

          _view.onNoConnection();
        }
      });
    }
  }



  @override
  Future<void> doRegistration(BuildContext context, User registrationData) async {

    checkInternetConnection().then((isConnected) async {

      if(isConnected) {

        if(_failedToRegister) {

          _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("signing_up_message"));
        }
        else {

          _view.updateProgressDialog(AppLocalization.of(context).getTranslatedValue("signing_up_message"));
        }

        var client = http.Client();

        client.post(

            Uri.encodeFull(APIRoute.REGISTRATION_URL),
            body: registrationData.toRegistration(),
            headers: {"Accept" : "application/json"}

        ).then((response) async {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Registration Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            _user = User.fromRegistration(json.decode(response.body));

            if(jsonData['message'] == AppLocalization.of(context).getTranslatedValue("user_registration_successful_message")) {

              registrationData.userID = _user.userID;

              CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Registration Success", message: "UserId = " +registrationData.userID.toString());

              await _hideDialogAndClearPinFields();
              await stopCountDownTimer();

              _view.goToRegistrationSuccessPage();
            }
            else {

              CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Registration", message: "Registration failed");

              await _onRegistrationFailure(context);
            }
          }
          else {

            CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Registration", message: "Registration failed");

            await _onRegistrationFailure(context);
          }

        }).timeout(Duration(seconds: 15), onTimeout: () async {

          client.close();

          await _onTimeOutOrNoConnection();

          _view.onConnectionTimeOut();
        });
      }
      else {

        await _onTimeOutOrNoConnection();

        _view.onNoConnection();
      }
    });
  }


  Future<void> _onTimeOutOrNoConnection() async {

    _failedToRegister = true;

    _view.setRegistrationStatus(false);
    _view.clearPinCodeFields();
    _view.updateMainBody();
  }


  Future<void> _onRegistrationFailure(BuildContext context) async {

    _failedToRegister = true;

    _view.setRegistrationStatus(false);
    await _hideDialogAndClearPinFields();

    _view.updateMainBody();
    _view.onError(AppLocalization.of(context).getTranslatedValue("failed_to_sign_up"));
  }


  Future<void> _phoneVerificationFailed() async {

    _view.setPhoneVerificationStatus(false);
    await _hideDialogAndClearPinFields();
    _view.showPinErrorAnimation();
  }


  Future<void> _hideDialogAndClearPinFields() async {

    _view.hideProgressDialog();
    _view.clearPinCodeFields();
  }


  @override
  Future<bool> onBackPressed(BuildContext context, bool recoveringPassword, User data, RegistrationRouteParameter routeParameter) async {

    if(recoveringPassword) {

      return Future(() => true);
    }
    else {

      if(!routeParameter.isPhoneVerified && !routeParameter.isRegistered) {

        _view.sendBackToRegistrationPage();
        return Future(() => false);
      }
      else if(routeParameter.isPhoneVerified && !routeParameter.isRegistered) {

        _view.showPhoneVerifiedAlert(context);
        return Future(() => false);
      }
    }

    return Future(() => false);
  }

  @override
  Future<void> stopCountDownTimer() async {

    try {
      _timer.cancel();
    }
    catch(error) {
      print(error);
    }
  }
}