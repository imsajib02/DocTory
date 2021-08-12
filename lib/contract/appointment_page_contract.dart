import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/patient.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showProgressIndicator();
  void hideProgressDialog();
  void showProgressDialog(String message);
  void showAppointmentList(Appointments appointments);
  void showSearchedAndFilteredList(List<Appointment> resultList, bool isSearched);
  void showFailedToLoadDataView();
  void onDeleteSuccess(BuildContext context, int appointmentID);
  void onDeleteFailed(BuildContext context);
  void storeOriginalData(Appointments appointments, Chambers chambers, Patients patients);
  void onSearchCleared(List<Appointment> appointmentList);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void getAppointments(BuildContext context, String token);
  void deleteAppointment(BuildContext context, int appointmentID, String token);
  void searchAppointment(BuildContext context, String pattern, String chamberName, List<Appointment> appointmentList, String fromDate, String toDate);
  void onTextChanged(BuildContext context, String value, String chamberName, List<Appointment> appointmentList, String fromDate, String toDate);
  void filterDataChamberWise(BuildContext context, String pattern, String chamberName, List<Appointment> appointmentList, bool isSearched, String fromDate, String toDate);
}