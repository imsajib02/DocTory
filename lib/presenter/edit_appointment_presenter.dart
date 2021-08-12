import 'dart:convert';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/appointment.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/contract/edit_appointment_contract.dart';

class EditAppointmentPresenter implements Presenter {

  View _view;
  Appointment _appointmentToBeEdited;
  List<Appointment> _appointmentList;
  List<Patient> _patientList;

  EditAppointmentPresenter(View view, Appointment appointmentToBeEdited, List<Appointment> appointmentList, List<Patient> patientList) {
    this._view = view;
    this._appointmentToBeEdited = appointmentToBeEdited;
    this._appointmentList = appointmentList;
    this._patientList = patientList;
  }

  @override
  void validateInput(BuildContext context, String token, Appointment inputData) {

    if(inputData.chamberID == null) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("choose_chamber_hint"));
    }
    else {

      if(inputData.patientName.isEmpty) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_patient_or_enter_patient_name"));
      }
      else {

        if(inputData.patientMobile.isEmpty) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_patient_or_enter_patient_phone"));
        }
        else {

          if(inputData.date.isEmpty) {

            _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_date_text"));
          }
          else {

            if(inputData.time.isEmpty) {

              _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_time_text"));
            }
            else {

              _checkIfSameDataIsGiven(context, token, inputData);
            }
          }
        }
      }
    }
  }


  void _checkIfSameDataIsGiven(BuildContext context, String token, Appointment inputData) {

    if(inputData.chamberID == _appointmentToBeEdited.chamberID && inputData.patientName == _appointmentToBeEdited.patientName &&
        inputData.patientMobile == _appointmentToBeEdited.patientMobile &&
        inputData.date == _appointmentToBeEdited.date && inputData.time == _appointmentToBeEdited.time) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("provide_new_information_message"));
    }
    else {

      _checkWithOtherAppointments(context, token, inputData);
    }
  }


  _checkWithOtherAppointments(BuildContext context, String token, Appointment inputData) {

    bool _duplicate = false;

    for(int i=0; i<_appointmentList.length; i++) {

      if(_appointmentList[i].id != _appointmentToBeEdited.id) {

        if(inputData.chamberID == _appointmentList[i].chamberID && inputData.patientName == _appointmentList[i].patientName &&
            inputData.patientMobile == _appointmentList[i].patientMobile &&
            inputData.date == _appointmentList[i].date && inputData.time == _appointmentList[i].time) {

          _duplicate = true;
          break;
        }
      }
    }

    if(_duplicate) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("appointment_exists_with_same_information"));
    }
    else {

      _updateAppointment(context, token, inputData);
    }
  }


  Future<void> _updateAppointment(BuildContext context, String token, Appointment inputData) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.UPDATE_APPOINTMENT_URL  + _appointmentToBeEdited.id.toString()),
          body: inputData.toJson(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Update Appointment Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              Appointment updatedAppointment = Appointment.fromCreate(jsonData['appointment']);

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Appointment Updated", message: "Updated appointment id: " +updatedAppointment.id.toString());

              _appointmentToBeEdited.chamberID = updatedAppointment.chamberID;
              _appointmentToBeEdited.patientName = updatedAppointment.patientName;
              _appointmentToBeEdited.patientMobile = updatedAppointment.patientMobile;
              _appointmentToBeEdited.date = updatedAppointment.date;
              _appointmentToBeEdited.time = updatedAppointment.time;

              _view.onUpdateSuccess(context);
            }
            else {

              _failedToUpdateAppointment(context);
            }
          }
          else {

            _failedToUpdateAppointment(context);
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


  void _failedToUpdateAppointment(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Update Appointment", message: "Falied to update appointment");
    _view.onUpdateFailure(context);
  }
}