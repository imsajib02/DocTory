import 'package:doctory/model/expense.dart';
import 'package:flutter/material.dart';

abstract class View {

  void onEmpty(String message);
  void onError(String message);
  void hideProgressDialog();
  void showProgressDialog(String message);
  void onEntrySuccess(BuildContext context);
  void onEntryFailure(BuildContext context);
  void backToExpensePage();
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void validateInput(BuildContext context, String token, Expense inputData);
}