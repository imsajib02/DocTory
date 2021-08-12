import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/patient.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showProgressIndicator();
  void hideProgressDialog();
  void showProgressDialog(String message);
  void showPatientList(Patients patients);
  void showFailedToLoadDataView();
  void onDeleteSuccess(BuildContext context, int patientID);
  void onDeleteFailed(BuildContext context);
  void storeOriginalData(Patients patients);
  void showSearchedList(List<Patient> resultList, bool isSearched);
  void onSearchCleared();
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void getPatientList(BuildContext context, String token);
  void deletePatient(BuildContext context, int patientID, String token);
  void searchPatient(BuildContext context, String pattern, List<Patient> patientList);
  void onTextChanged(BuildContext context, String value);
}