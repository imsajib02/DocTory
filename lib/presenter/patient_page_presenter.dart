import 'dart:convert';

import 'package:doctory/contract/patient_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/utils/connection_check.dart';

class PatientPresenter implements Presenter {

  View _view;
  Patients _patients;

  PatientPresenter(this._view);

  @override
  Future<void> getPatientList(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.PATIENT_LIST_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "PatientPage Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _patients = Patients.fromJson(jsonData);

              _patients.list.sort((a, b) => a.name.compareTo(b.name));

              _view.storeOriginalData(_patients);
            }
            else {

              _failedToGetPatients();
            }
          }
          else {

            _failedToGetPatients();
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

  void _failedToGetPatients() {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "PatientPage", message: "Falied to get patient data");
    _view.showFailedToLoadDataView();
  }

  @override
  Future<void> deletePatient(BuildContext context, int patientID, String token) async {

    checkInternetConnection().then((isConnected) async {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.DELETE_PATIENT_URL + patientID.toString()),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Patient Delete Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Patient Delete Successful",
                  message: "Deleted patient id: " + patientID.toString());

              _view.onDeleteSuccess(context, patientID);
            }
            else {

              _failedToDeletePatient(context);
            }
          }
          else {

            _failedToDeletePatient(context);
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

  void _failedToDeletePatient(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Patient Delete", message: "Falied to delete patient");
    _view.onDeleteFailed(context);
  }

  @override
  void onTextChanged(BuildContext context, String value) {

    if(value.length == 0) {

      _view.onSearchCleared();
    }
  }

  @override
  void searchPatient(BuildContext context, String pattern, List<Patient> patientList) {

    List<Patient> result = List();

    if(pattern.isNotEmpty) {

      _view.showProgressIndicator();

      patientList.forEach((patient) {

        if(patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

          result.add(patient);
        }
      });

      _view.showSearchedList(result, true);
    }
    else {

      Patients patients = Patients(list: patientList);
      _view.showPatientList(patients);
    }
  }
}