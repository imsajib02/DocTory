import 'dart:convert';

import 'package:doctory/contract/expense_category_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExpenseCategoryPresenter implements Presenter {

  View _view;
  ExpenseCategories _expenseCategories;

  ExpenseCategoryPresenter(this._view);


  @override
  Future<void> getCategories(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.EXPENSE_CATEGORY_LIST_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Expesne Category Page Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _expenseCategories = ExpenseCategories.fromJson(jsonData);

              _expenseCategories.list.sort((a, b) => a.name.compareTo(b.name));

              _view.showCategoryList(_expenseCategories);
            }
            else {

              _failedToGetCategories();
            }
          }
          else {

            _failedToGetCategories();
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          client.close();

          _view.showFailedToLoadDataView();
          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.showFailedToLoadDataView();
        _view.onNoConnection();
      }
    });
  }


  void _failedToGetCategories() {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Expesne Category Page", message: "Falied to get category data");
    _view.showFailedToLoadDataView();
  }


  @override
  Future<void> deleteCategory(BuildContext context, int categoryID, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.DELETE_EXPENSE_CATEGORY_URL + categoryID.toString()),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Category Delete Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Category Delete Successful",
                  message: "Deleted category id: " + categoryID.toString());

              _view.onDeleteSuccess(context, categoryID);
            }
            else {

              _failedToDeleteCategory(context);
            }
          }
          else {

            _failedToDeleteCategory(context);
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


  void _failedToDeleteCategory(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Category Delete", message: "Falied to delete category");
    _view.onDeleteFailed(context);
  }
}