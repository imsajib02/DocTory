import 'dart:convert';
import 'dart:io';

import 'package:doctory/contract/login_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/utils/connection_check.dart';

import 'package:doctory/utils/local_memory.dart';

class LoginPresenter implements Presenter {

  View _view;
  User _user;
  LocalMemory _localMemory;

  LoginPresenter(View view) {

    this._view = view;
    _user = User();
    _localMemory = LocalMemory();
  }

  @override
  void validateLoginInput(BuildContext context, User loginData) {

    if(loginData.email.isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("email_field_empty"));
    }
    else {

      if(!loginData.email.contains("@") && !loginData.email.contains(".")) {

        _view.onInvalidInput(AppLocalization.of(context).getTranslatedValue("invalid_email_address"));
      }
      else {

        if(loginData.password.isEmpty) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("password_field_empty"));
        }
        else {

          _doLogin(context, loginData);
        }
      }
    }
  }

  Future<void> _doLogin(BuildContext context, User loginData) async {

    checkInternetConnection().then((isConnected) async {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

            Uri.encodeFull(APIRoute.LOGIN_URL),
            body: loginData.toLogin(),
            headers: {"Accept" : "application/json"}

        ).then((response) async {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Login Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _user = User.fromLogin(jsonData);

              if(_user.accessToken != null) {

                CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Login", message: "Successful");

                CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Current User", message: "Email: " +_user.email);

                _view.hideProgressDialog();

                //_user.password = loginData.password;
                await _localMemory.saveUser(_user);

                bool isFirstOpen = await _localMemory.isFirstOpen();

                if(isFirstOpen) {

                  _view.sendUserToProfilePage(_user);
                }
                else {

                  _view.sendUserToHomePage(_user);
                }
              }
            }
            else {

              if(jsonData['message'] == AppLocalization.of(context).getTranslatedValue("email_must_be_valid")) {

                CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Login", message: "Invalid email");

                _view.hideProgressDialog();
                _view.onError(AppLocalization.of(context).getTranslatedValue("email_invalid_message"));
              }
            }
          }
          else if(response.statusCode == 401) {

            if(jsonData['message'] == AppLocalization.of(context).getTranslatedValue("unauthorized_login_response")) {

              CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Login", message: "No user found");

              _view.hideProgressDialog();
              _view.onError(AppLocalization.of(context).getTranslatedValue("user_not_found_message"));
            }
          }
          else {

            CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Login", message: "Login failed");

            _view.hideProgressDialog();
            _view.onError(AppLocalization.of(context).getTranslatedValue("login_failed_message"));
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          client.close();

          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.onNoConnection();
      }
    });
  }
}