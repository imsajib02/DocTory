import 'package:doctory/model/chamber.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showProgressIndicator();
  void hideProgressDialog();
  void showProgressDialog(String message);
  void showChamberList(Chambers chambers);
  void showFailedToLoadDataView();
  void onDeleteSuccess(int chamberID);
  void onDeleteFailed();
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void getChambers(BuildContext context, String token);
  void deleteChamber(BuildContext context, int chamberID, String token);
}