import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:doctory/contract/appointment_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/utils/connection_check.dart';

class AppointmentPresenter implements Presenter {

  View _view;
  Appointments _appointments;
  Chambers _chambers;
  Patients _patients;

  AppointmentPresenter(this._view);

  @override
  Future<void> getAppointments(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.APPOINTMENT_LIST_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "AppointmentPage Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _appointments = Appointments.fromJson(jsonData);
              _chambers = Chambers.fromJson(jsonData);
              _patients = Patients.fromJson(jsonData);

              _appointments.list.sort((a, b) => a.dateTime.compareTo(b.dateTime));

              _view.storeOriginalData(_appointments, _chambers, _patients);
            }
            else {

              _failedToGetData(false, "AppointmentPage", "Falied to get appointment data");
            }
          }
          else {

            _failedToGetData(false, "AppointmentPage", "Falied to get appointment data");
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


  void _failedToGetData(bool isFilteredData, String tag, String message) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: tag, message: message);
    _view.showFailedToLoadDataView();
  }

  @override
  Future<void> deleteAppointment(BuildContext context, int appointmentID, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.DELETE_APPOINTMENT_URL + appointmentID.toString()),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Appointment Delete Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Appointment Delete Successful",
                  message: "Deleted appointment id: " + appointmentID.toString());

              _view.onDeleteSuccess(context, appointmentID);
            }
            else {

              _failedToDeleteAppointment(context);
            }
          }
          else {

            _failedToDeleteAppointment(context);
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

  void _failedToDeleteAppointment(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Appointment Delete", message: "Falied to delete appointment");
    _view.onDeleteFailed(context);
  }


  @override
  Future<void> searchAppointment(BuildContext context, String pattern, String chamberName, List<Appointment> appointmentList, String fromDate, String toDate) async {

    List<Appointment> result = List();

    if(pattern.isNotEmpty) {

      _view.showProgressIndicator();

      List<Appointment> filterList = await _sortDateWise(appointmentList, fromDate, toDate);

      filterList.forEach((appointment) {

        if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

          if(appointment.patientName.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(appointment);
          }
        }
        else {

          if(chamberName == appointment.chamber.name && appointment.patientName.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(appointment);
          }
        }
      });

      _view.showSearchedAndFilteredList(result, true);
    }
  }


  @override
  Future<void> onTextChanged(BuildContext context, String value, String chamberName, List<Appointment> appointmentList, String fromDate, String toDate) async {

    if(value.length == 0) {

      List<Appointment> result = List();

      List<Appointment> filterList = await _sortDateWise(appointmentList, fromDate, toDate);

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        _view.onSearchCleared(filterList);
      }
      else {

        filterList.forEach((appointment) {

          if(chamberName == appointment.chamber.name) {

            result.add(appointment);
          }
        });

        _view.onSearchCleared(result);
      }
    }
  }


  @override
  Future<void> filterDataChamberWise(BuildContext context, String pattern, String chamberName, List<Appointment> appointmentList, bool isSearched, String fromDate, String toDate) async {

    List<Appointment> result = List();

    _view.showProgressIndicator();

    List<Appointment> filterList = await _sortDateWise(appointmentList, fromDate, toDate);

    filterList.forEach((appointment) {

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        if(!isSearched) {

          result.add(appointment);
        }
        else {

          if(appointment.patientName.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(appointment);
          }
        }
      }
      else {

        if(!isSearched) {

          if(chamberName == appointment.chamber.name) {

            result.add(appointment);
          }
        }
        else {

          if(chamberName == appointment.chamber.name && appointment.patientName.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(appointment);
          }
        }
      }
    });

    _view.showSearchedAndFilteredList(result, isSearched);
  }


  Future<List<Appointment>> _sortDateWise(List<Appointment> appointmentList, String fromDate, String toDate) async {

    List<Appointment> list = List();

    if((fromDate.isNotEmpty && fromDate != "- - - -") && (toDate.isNotEmpty && toDate != "- - - -")) {

      appointmentList.forEach((appointment) {

        DateTime date1 = DateFormat('dd-MM-yyyy').parse(fromDate);
        DateTime date2 = DateFormat('dd-MM-yyyy').parse(toDate);

        DateTime appDate = DateFormat('MMMM d, yyyy').parse(appointment.date);

        final diff1 = DateTime(appDate.year, appDate.month, appDate.day).difference(DateTime(date1.year, date1.month, date1.day)).inDays;
        final diff2 = DateTime(appDate.year, appDate.month, appDate.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays;

        if(diff1 >= 0 && diff2 <= 0) {

          list.add(appointment);
        }
      });
    }
    else {

      DateTime currentDateTime = DateTime.now();

      appointmentList.forEach((appointment) {

        DateTime date = DateFormat('MMMM d, yyyy').parse(appointment.date);

        final diff = DateTime(date.year, date.month, date.day).difference(DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day)).inDays;

        if(diff >= 0) {

          list.add(appointment);
        }
      });
    }

    return list;
  }
}