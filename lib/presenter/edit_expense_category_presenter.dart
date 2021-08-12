import 'dart:convert';

import 'package:doctory/contract/edit_expense_category_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditExpenseCategoryPresenter implements Presenter {

  View _view;
  ExpenseCategory _categoryToBeEdited;
  List<ExpenseCategory> _categoryList;

  EditExpenseCategoryPresenter(View view, ExpenseCategory categoryToBeEdited, List<ExpenseCategory> categoryList) {
    this._view = view;
    this._categoryToBeEdited = categoryToBeEdited;
    this._categoryList = categoryList;
  }

  @override
  void validateInput(BuildContext context, String token, ExpenseCategory inputData) {

    if(inputData.name.isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_category_name"));
    }
    else {

      _checkIfSameDataIsGiven(context, token, inputData);
    }
  }


  void _checkIfSameDataIsGiven(BuildContext context, String token, ExpenseCategory inputData) {

    if(inputData.name == _categoryToBeEdited.name) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("provide_new_information_message"));
    }
    else {

      _checkWithOtherCategories(context, token, inputData);
    }
  }


  _checkWithOtherCategories(BuildContext context, String token, ExpenseCategory inputData) {

    bool _duplicate = false;

    for(int i=0; i<_categoryList.length; i++) {

      if(_categoryList[i].id != _categoryToBeEdited.id) {

        if(inputData.name == _categoryList[i].name) {

          _duplicate = true;
          break;
        }
      }
    }

    if(_duplicate) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("category_exists_with_same_information"));
    }
    else {

      _updateChamber(context, token, inputData);
    }
  }


  Future<void> _updateChamber(BuildContext context, String token, ExpenseCategory inputData) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.UPDATE_EXPENSE_CATEGORY_URL  + _categoryToBeEdited.id.toString()),
          body: inputData.toJson(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Update Expense Category Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              ExpenseCategory updatedCategory = ExpenseCategory.fromJson(jsonData['expense_category']);

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Expense Category Updated", message: "Updated category id: " +updatedCategory.id.toString());

              _categoryToBeEdited.name = updatedCategory.name;

              _view.onUpdateSuccess(context);
            }
            else {

              _failedToUpdateExpenseCategory(context);
            }
          }
          else {

            _failedToUpdateExpenseCategory(context);
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


  void _failedToUpdateExpenseCategory(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Update Expense Category", message: "Falied to update expense category");
    _view.onUpdateFailure(context);
  }
}