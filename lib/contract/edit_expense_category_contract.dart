import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:flutter/material.dart';

abstract class View {

  void onEmpty(String message);
  void onError(String message);
  void hideProgressDialog();
  void showProgressDialog(String message);
  void onUpdateSuccess(BuildContext context);
  void onUpdateFailure(BuildContext context);
  void backToExpenseCategoryPage();
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void validateInput(BuildContext context, String token, ExpenseCategory inputData);
}