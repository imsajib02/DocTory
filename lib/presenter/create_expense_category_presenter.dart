import 'dart:convert';

import 'package:doctory/contract/create_expense_category_contact.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateExpenseCategoryPresenter implements Presenter {

  View _view;
  List<ExpenseCategory> _categoryList;

  CreateExpenseCategoryPresenter(View view, List<ExpenseCategory> categoryList) {
    this._view = view;
    this._categoryList = categoryList;
  }

  @override
  void validateInput(BuildContext context, String token, ExpenseCategory inputData) {

    if(inputData.name.isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_category_name"));
    }
    else {

      _checkIfChamberExists(context, token, inputData);
    }
  }


  _checkIfChamberExists(BuildContext context, String token, ExpenseCategory inputData) {

    bool _duplicate = false;

    for(int i=0; i<_categoryList.length; i++) {

      if(inputData.name == _categoryList[i].name) {

        _duplicate = true;
        break;
      }
    }

    if(_duplicate) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("category_already_exists"));
    }
    else {

      _createChamber(context, token, inputData);
    }
  }


  Future<void> _createChamber(BuildContext context, String token, ExpenseCategory inputData) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.CREATE_EXPENSE_CATEGORY_URL),
          body: inputData.toJson(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Create Expense Category Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              ExpenseCategory newCategory = ExpenseCategory.fromJson(jsonData['expense_category']);

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Expense Category Created", message: "Category name: " +newCategory.name);

              _categoryList.add(newCategory);
              _view.onEntrySuccess(context);
            }
            else {

              _failedToCreateExpenseCategory(context);
            }
          }
          else {

            _failedToCreateExpenseCategory(context);
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


  void _failedToCreateExpenseCategory(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Create Expense Category", message: "Falied to create expense category");
    _view.onEntryFailure(context);
  }
}