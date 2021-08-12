import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:doctory/contract/income_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/income.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IncomePagePresenter implements Presenter {

  View _view;
  Incomes _incomes;

  IncomePagePresenter(this._view);

  @override
  Future<void> getIncomes(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.INCOME_LIST_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "IncomePage Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _incomes = Incomes.fromJson(jsonData);

              _incomes.list.sort((a, b) => a.originalDate.compareTo(b.originalDate));

              _view.storeOriginalData(_incomes);
            }
            else {

              _failedToGetIncomes(context);
            }
          }
          else {

            _failedToGetIncomes(context);
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          client.close();

          _view.showFailedToLoadDataView(context);
          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.showFailedToLoadDataView(context);
        _view.onNoConnection();
      }
    });
  }

  void _failedToGetIncomes(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "IncomePage", message: "Falied to get income data");
    _view.showFailedToLoadDataView(context);
  }

  @override
  Future<void> searchIncome(BuildContext context, String pattern, String chamberName, List<Income> incomeList, String fromDate, String toDate) async {

    List<Income> result = List();

    if(pattern.isNotEmpty) {

      _view.showProgressIndicator();

      List<Income> filterList = await _sortDateWise(incomeList, fromDate, toDate);

      filterList.forEach((income) {

        if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

          if(income.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(income);
          }
        }
        else {

          if(chamberName == income.chamber.name && income.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(income);
          }
        }
      });

      _view.showSearchedAndFilteredList(result, true);
    }
  }

  @override
  Future<void> filterDataChamberWise(BuildContext context, String pattern, String chamberName, List<Income> incomeList, bool isSearched, String fromDate, String toDate) async {

    List<Income> result = List();

    _view.showProgressIndicator();

    List<Income> filterList = await _sortDateWise(incomeList, fromDate, toDate);

    filterList.forEach((income) {

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        if(!isSearched) {

          result.add(income);
        }
        else {

          if(income.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(income);
          }
        }
      }
      else {

        if(!isSearched) {

          if(chamberName == income.chamber.name) {

            result.add(income);
          }
        }
        else {

          if(chamberName == income.chamber.name && income.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(income);
          }
        }
      }
    });

    _view.showSearchedAndFilteredList(result, isSearched);
  }

  @override
  Future<void> onTextChanged(BuildContext context, String value, String chamberName, List<Income> incomeList, String fromDate, String toDate) async {

    if(value.length == 0) {

      List<Income> result = List();

      List<Income> filterList = await _sortDateWise(incomeList, fromDate, toDate);

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        _view.onSearchCleared(filterList);
      }
      else {

        filterList.forEach((income) {

          if(chamberName == income.chamber.name) {

            result.add(income);
          }
        });

        _view.onSearchCleared(result);
      }
    }
  }

  Future<List<Income>> _sortDateWise(List<Income> incomeList, String fromDate, String toDate) async {

    List<Income> list = List();

    if((fromDate.isNotEmpty && fromDate != "- - - -") && (toDate.isNotEmpty && toDate != "- - - -")) {

      incomeList.forEach((income) {

        DateTime date1 = DateFormat('dd-MM-yyyy').parse(fromDate);
        DateTime date2 = DateFormat('dd-MM-yyyy').parse(toDate);

        DateTime incDate = DateFormat('MMMM d, yyyy').parse(income.createdAt);

        final diff1 = DateTime(incDate.year, incDate.month, incDate.day).difference(DateTime(date1.year, date1.month, date1.day)).inDays;
        final diff2 = DateTime(incDate.year, incDate.month, incDate.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays;

        if(diff1 >= 0 && diff2 <= 0) {

          list.add(income);
        }
      });
    }
    else {

      list = incomeList;
    }

    return list;
  }
}