import 'dart:convert';

import 'package:doctory/contract/change_password_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPresenter implements Presenter {

  View _view;

  ChangePasswordPresenter(this._view);

  @override
  void validateInput(BuildContext context, User input, String token) {

    if(input.oldPassword.isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_old_password"));
    }
    else {

      if(input.password.isEmpty) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_new_password"));
      }
      else {

        if(input.confirmPassword.isEmpty) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("confirm_new_password"));
        }
        else {

          if(input.password != input.confirmPassword) {

            _view.onError(AppLocalization.of(context).getTranslatedValue("new_password_do_not_match"));
          }
          else {

            _changePassword(context, input, token);
          }
        }
      }
    }
  }

  Future<void> _changePassword(BuildContext context, User input, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.PASSWORD_CHANGE_URL),
          body: input.toPasswordChange(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Change Password Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['message'] == AppLocalization.of(context).getTranslatedValue("password_modified_successfully_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Change Password", message: "Password successfuly changed");

              _view.onChangeSuccess(context);
            }
            else if(jsonData['message'] == AppLocalization.of(context).getTranslatedValue("credential_do_not_match")) {

              CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Change Password", message: "Old password do not match");

              _view.onChangeFailure(context, AppLocalization.of(context).getTranslatedValue("old_password_not_correct"));
            }
            else {

              _failedToChangePassword(context);
            }
          }
          else {

            _failedToChangePassword(context);
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

  void _failedToChangePassword(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Change Password", message: "Failed to change password");

    _view.onChangeFailure(context, AppLocalization.of(context).getTranslatedValue("failed_to_change_password"));
  }
}