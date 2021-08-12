import 'dart:convert';
import 'package:doctory/contract/create_expense_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/expense.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateExpensePresenter implements Presenter {

  View _view;
  List<Expense> _expenseList;

  CreateExpensePresenter(View view, List<Expense> expenseList) {
    this._view = view;
    this._expenseList = expenseList;
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

            _createExpense(context, token, inputData);
          }
        }
      }
    }
  }


  Future<void> _createExpense(BuildContext context, String token, Expense inputData) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.CREATE_EXPENSE_URL),
          body: inputData.toJson(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Create Expense Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              Expense newExpense = Expense.fromCreate(jsonData['expense']);

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Expense Created", message: "Paid to: " +newExpense.recipientName);

              //_expenseList.add(newExpense);
              _view.onEntrySuccess(context);
            }
            else {

              _failedToCreateExpense(context);
            }
          }
          else {

            _failedToCreateExpense(context);
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


  void _failedToCreateExpense(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Create Expense", message: "Falied to create expense");
    _view.onEntryFailure(context);
  }
}