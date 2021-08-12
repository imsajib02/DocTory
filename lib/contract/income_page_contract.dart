import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/income.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showProgressIndicator();
  void hideProgressDialog();
  void showProgressDialog(String message);
  void showIncomeList(Incomes incomes);
  void showFailedToLoadDataView(BuildContext context);
  void storeOriginalData(Incomes incomes);
  void showSearchedAndFilteredList(List<Income> resultList, bool isSearched);
  void onSearchCleared(List<Income> incomeList);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void getIncomes(BuildContext context, String token);
  void searchIncome(BuildContext context, String pattern, String chamberName, List<Income> incomeList, String fromDate, String toDate);
  void filterDataChamberWise(BuildContext context, String pattern, String chamberName, List<Income> incomeList, bool isSearched, String fromDate, String toDate);
  void onTextChanged(BuildContext context, String value, String chamberName, List<Income> incomeList, String fromDate, String toDate);
}