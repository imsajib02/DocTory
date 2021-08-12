import 'dart:convert';

import 'package:doctory/contract/set_new_password_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/utils/connection_check.dart';

class SetNewPasswordPresenter implements Presenter {

  View _view;

  SetNewPasswordPresenter(this._view);

  @override
  void validateInput(BuildContext context, User user) {

    if(user.password.isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("password_field_empty"));
    }
    else {

      if(user.confirmPassword.isEmpty) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("confirm_password_field_empty"));
      }
      else {

        if(user.password != user.confirmPassword) {

          _view.onError(AppLocalization.of(context).getTranslatedValue("new_password_do_not_match"));
        }
        else {

          _resetPassword(context, user);
        }
      }
    }
  }

  Future<void> _resetPassword(BuildContext context, User user) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

            Uri.encodeFull(APIRoute.PASSWORD_RESET_URL),
            body: user.toPasswordReset(),
            headers: {"Accept" : "application/json"}

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Password Reset Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['message'] == AppLocalization.of(context).getTranslatedValue("password_changed_successfully_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Password Reset Successful", message: "User: " +user.email);

              _view.goToPasswordResetSuccessPage();
            }
          }
          else {

            CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Password Reset", message: "Failed to reset password");

            _view.hideProgressDialog();
            _view.onError(AppLocalization.of(context).getTranslatedValue("failed_to_reset_password_message"));
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