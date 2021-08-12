import 'dart:convert';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/expense.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/contract/edit_expense_contract.dart';

class EditExpensePresenter implements Presenter {

  View _view;
  Expense _expenseToBeEdited;

  EditExpensePresenter(View view, Expense expenseToBeEdited) {
    this._view = view;
    this._expenseToBeEdited = expenseToBeEdited;
  }

  @override
  void validateInput(BuildContext context, String token, Expense inputData) {

    if(inputData.chamberID == null) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("choose_chamber_hint"));
    }
    else {

      if(inputData.categoryID == null) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_category_message"));
      }
      else {

        if(inputData.recipientName.isEmpty) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_name_message"));
        }
        else {

          if(inputData.amount.isEmpty) {

            _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_amount_message"));
          }
          else {

            _checkIfSameDataIsGiven(context, token, inputData);
          }
        }
      }
    }
  }


  void _checkIfSameDataIsGiven(BuildContext context, String token, Expense inputData) {

    if(inputData.recipientName == _expenseToBeEdited.recipientName && inputData.amount == _expenseToBeEdited.amount &&
        inputData.details == _expenseToBeEdited.details && inputData.chamberID == _expenseToBeEdited.chamberID &&
        inputData.categoryID == _expenseToBeEdited.categoryID) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("provide_new_information_message"));
    }
    else {

      _updateExpenseInfo(context, token, inputData);
    }
  }


  Future<void> _updateExpenseInfo(BuildContext context, String token, Expense inputData) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.UPDATE_EXPENSE_URL  + _expenseToBeEdited.id.toString()),
          body: inputData.toJson(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Update Expense Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              Expense updatedExpense = Expense.fromCreate(jsonData['expense']);

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Expense Updated", message: "Updated expense id: " +updatedExpense.id.toString());

              _expenseToBeEdited.chamberID = updatedExpense.chamberID;
              _expenseToBeEdited.categoryID = updatedExpense.categoryID;
              _expenseToBeEdited.recipientName = updatedExpense.recipientName;
              _expenseToBeEdited.amount = updatedExpense.amount;
              _expenseToBeEdited.details = updatedExpense.details;

              _view.onUpdateSuccess(context);
            }
            else {

              _failedToUpdateExpense(context);
            }
          }
          else {

            _failedToUpdateExpense(context);
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


  void _failedToUpdateExpense(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Update Expense", message: "Falied to update expense");
    _view.onUpdateFailure(context);
  }
}