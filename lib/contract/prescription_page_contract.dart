import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/prescription.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showProgressIndicator();
  void hideProgressDialog();
  void showProgressDialog(String message);
  void showPrescriptionList(Prescriptions prescriptions);
  void showFailedToLoadDataView();
  void onDeleteSuccess(BuildContext context, int prescriptionID);
  void onDeleteFailed(BuildContext context);
  void onPrintFailed(BuildContext context);
  void storeOriginalData(Prescriptions prescriptions);
  void showSearchedAndFilteredList(List<Prescription> resultList, bool isSearched);
  void onSearchCleared(List<Prescription> prescriptionList);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void getPrescriptions(BuildContext context, String token);
  void deletePrescription(BuildContext context, int prescriptionID, String token);
  void searchPrescription(BuildContext context, String pattern, String chamberName, List<Prescription> prescriptionList, String fromDate, String toDate);
  void filterDataChamberWise(BuildContext context, String pattern, String chamberName, List<Prescription> prescriptionList, bool isSearched, String fromDate, String toDate);
  void onTextChanged(BuildContext context, String value, String chamberName, List<Prescription> prescriptionList, String fromDate, String toDate);
  void printPrescription(BuildContext context, int prescriptionID, int userID);
}