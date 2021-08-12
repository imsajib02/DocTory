import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:doctory/contract/expense_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/expense.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExpensePresenter implements Presenter {

  View _view;
  Expenses _expenses;

  ExpensePresenter(this._view);

  @override
  Future<void> getExpenses(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.EXPENSE_LIST_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "ExpensePage Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _expenses = Expenses.fromJson(jsonData);

              _expenses.list.sort((a, b) => a.originalDate.compareTo(b.originalDate));

              _view.storeOriginalData(_expenses);
            }
            else {

              _failedToGetExpenses();
            }
          }
          else {

            _failedToGetExpenses();
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

  void _failedToGetExpenses() {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "ExpensePage", message: "Falied to get expense data");
    _view.showFailedToLoadDataView();
  }

  @override
  Future<void> deleteExpense(BuildContext context, int expenseID, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.DELETE_EXPENSE_URL + expenseID.toString()),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Expense Delete Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Expense Delete Successful",
                  message: "Deleted expense id: " + expenseID.toString());

              _view.onDeleteSuccess(context, expenseID);
            }
            else {

              _failedToDeleteExpense(context);
            }
          }
          else {

            _failedToDeleteExpense(context);
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

  void _failedToDeleteExpense(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Expense Delete", message: "Falied to delete expense");
    _view.onDeleteFailed(context);
  }

  @override
  Future<void> filterDataChamberAndCategoryWise(BuildContext context, String pattern, String chamberName, String categoryName, List<Expense> expenseList, bool isSearched, String fromDate, String toDate) async {

    List<Expense> result = List();

    _view.showProgressIndicator();

    List<Expense> filterList = await _sortDateWise(expenseList, fromDate, toDate);

    filterList.forEach((expense) {

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        if(categoryName == AppLocalization.of(context).getTranslatedValue("all_category_filter")) {

          if(!isSearched) {

            result.add(expense);
          }
          else {

            if(expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

              result.add(expense);
            }
          }
        }
        else {

          if(categoryName == expense.category.name) {

            if(!isSearched) {

              result.add(expense);
            }
            else {

              if(expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

                result.add(expense);
              }
            }
          }
        }
      }
      else {

        if(chamberName == expense.chamber.name) {

          if(categoryName == AppLocalization.of(context).getTranslatedValue("all_category_filter")) {

            if(!isSearched) {

              result.add(expense);
            }
            else {

              if(expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

                result.add(expense);
              }
            }
          }
          else {

            if(categoryName == expense.category.name) {

              if(!isSearched) {

                result.add(expense);
              }
              else {

                if(expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

                  result.add(expense);
                }
              }
            }
          }
        }
      }
    });

    _view.showSearchedAndFilteredList(result, isSearched);
  }

  @override
  Future<void> onTextChanged(BuildContext context, String value, String chamberName, String categoryName, List<Expense> expenseList, String fromDate, String toDate) async {

    if(value.length == 0) {

      List<Expense> result = List();

      List<Expense> filterList = await _sortDateWise(expenseList, fromDate, toDate);

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        if(categoryName == AppLocalization.of(context).getTranslatedValue("all_category_filter")) {

          _view.onSearchCleared(filterList);
        }
        else {

          filterList.forEach((expense) {

            if(categoryName == expense.category.name) {

              result.add(expense);
            }
          });

          _view.onSearchCleared(result);
        }
      }
      else {

        filterList.forEach((expense) {

          if(chamberName == expense.chamber.name) {

            if(categoryName == AppLocalization.of(context).getTranslatedValue("all_category_filter")) {

              result.add(expense);
            }
            else {

              if(categoryName == expense.category.name) {

                result.add(expense);
              }
            }
          }
        });

        _view.onSearchCleared(result);
      }
    }
  }

  @override
  Future<void> searchExpense(BuildContext context, String pattern, String chamberName, String categoryName, List<Expense> expenseList, String fromDate, String toDate) async {

    List<Expense> result = List();

    if(pattern.isNotEmpty) {

      _view.showProgressIndicator();

      List<Expense> filterList = await _sortDateWise(expenseList, fromDate, toDate);

      filterList.forEach((expense) {

        if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

          if(categoryName == AppLocalization.of(context).getTranslatedValue("all_category_filter")) {

            if(expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

              result.add(expense);
            }
          }
          else {

            if(expense.category.name == categoryName && expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

              result.add(expense);
            }
          }
        }
        else {

          if(chamberName == expense.chamber.name) {

            if(categoryName == AppLocalization.of(context).getTranslatedValue("all_category_filter")) {

              if(expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

                result.add(expense);
              }
            }
            else {

              if(expense.category.name == categoryName && expense.recipientName.toLowerCase().startsWith(pattern.toLowerCase())) {

                result.add(expense);
              }
            }
          }
        }
      });

      _view.showSearchedAndFilteredList(result, true);
    }
  }

  Future<List<Expense>> _sortDateWise(List<Expense> expenseList, String fromDate, String toDate) async {

    List<Expense> list = List();

    if((fromDate.isNotEmpty && fromDate != "- - - -") && (toDate.isNotEmpty && toDate != "- - - -")) {

      expenseList.forEach((expense) {

        DateTime date1 = DateFormat('dd-MM-yyyy').parse(fromDate);
        DateTime date2 = DateFormat('dd-MM-yyyy').parse(toDate);

        DateTime expDate = DateFormat('MMMM d, yyyy').parse(expense.createdAt);

        final diff1 = DateTime(expDate.year, expDate.month, expDate.day).difference(DateTime(date1.year, date1.month, date1.day)).inDays;
        final diff2 = DateTime(expDate.year, expDate.month, expDate.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays;

        if(diff1 >= 0 && diff2 <= 0) {

          list.add(expense);
        }
      });
    }
    else {

      list = expenseList;
    }

    return list;
  }
}