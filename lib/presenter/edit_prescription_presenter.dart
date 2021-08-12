import 'dart:convert';
import 'package:doctory/contract/edit_prescription_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/medicine.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/model/prescription_medicine.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EditPrescriptionPresenter implements Presenter {

  View _view;
  Prescription _prescriptionToBeEdited;
  List<Prescription> _prescriptionList;

  EditPrescriptionPresenter(View view, Prescription prescriptionToBeEdited, List<Prescription> prescriptionList) {
    this._view = view;
    this._prescriptionToBeEdited = prescriptionToBeEdited;
    this._prescriptionList = prescriptionList;
  }

  @override
  Future<void> loadMedicineList() async {

    String jsonStringValues = await rootBundle.loadString("assets/json/medicines.json");

    var jsonData = json.decode(jsonStringValues);

    Medicines medicines = Medicines.fromJson(jsonData);

    _view.setMedicineList(medicines);
  }

  @override
  void validateMedicineInput(BuildContext context, PrescriptionMedicine input, bool reEdit, {int position}) {

    if(!input.isMedicineSelected) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_medicine_message"));
    }
    else {

      if(input.dosage.isEmpty) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_dosage_message"));
      }
      else {

        if(!input.isTimeSelected) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_time_message"));
        }
        else {

          if(input.duration.isEmpty) {

            _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_duration_message"));
          }
          else {

            if(reEdit) {

              _view.updateMedicineInList(input, position);
            }
            else {

              _view.addMedicineToList(input);
            }
          }
        }
      }
    }
  }

  @override
  void validateInput(BuildContext context, String token, Prescription inputData) {

    if(inputData.income.visitingFee.toString().isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_visiting_fee_message"));
    }
    else {

      if(inputData.chamberID == null) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_chamber_message"));
      }
      else {

        if(inputData.patientID == null) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_patient_message"));
        }
        else {

          if(inputData.investigations.isEmpty) {

            _view.onEmpty(AppLocalization.of(context).getTranslatedValue("add_investigation"));
          }
          else {

            if(inputData.prescriptionMedicineList.isEmpty) {

              _view.onEmpty(AppLocalization.of(context).getTranslatedValue("add_medicine_message"));
            }
            else {

              _checkIfSameDataIsGiven(context, token, inputData);
            }
          }
        }
      }
    }
  }


  void _checkIfSameDataIsGiven(BuildContext context, String token, Prescription inputData) {

    if(inputData.followUpDate == _prescriptionToBeEdited.followUpDate && inputData.chamberID == _prescriptionToBeEdited.chamberID &&
        inputData.patientID == _prescriptionToBeEdited.patientID && inputData.investigations == _prescriptionToBeEdited.investigations &&
        inputData.prescriptionMedicineList == _prescriptionToBeEdited.prescriptionMedicineList) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("provide_new_information_message"));
    }
    else {

      _checkWithOtherPrescriptions(context, token, inputData);
    }
  }


  _checkWithOtherPrescriptions(BuildContext context, String token, Prescription inputData) {

    bool _duplicate = false;

    for(int i=0; i<_prescriptionList.length; i++) {

      if(inputData.followUpDate == _prescriptionList[i].followUpDate && inputData.chamberID == _prescriptionList[i].chamberID &&
          inputData.patientID == _prescriptionList[i].patientID && inputData.investigations == _prescriptionList[i].investigations &&
          inputData.prescriptionMedicineList == _prescriptionList[i].prescriptionMedicineList) {

        _duplicate = true;
        break;
      }
    }

    if(_duplicate) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("prescription_exists_with_same_information"));
    }
    else {

      _updatePrescription(context, token, inputData);
    }
  }


  Future<void> _updatePrescription(BuildContext context, String token, Prescription inputData) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        print(inputData.toJson().toString());

        client.post(

          Uri.encodeFull(APIRoute.UPDATE_PRESCRIPTION_URL  + _prescriptionToBeEdited.id.toString()),
          body: inputData.toJson(),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Update Prescription Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              Prescription updatedPrescription = Prescription.fromCreate(jsonData['prescription']);

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Prescription Updated", message: "Prescription ID: " +updatedPrescription.id.toString());

              _view.onUpdateSuccess(context);
            }
            else {

              _failedToUpdatePrescription(context);
            }
          }
          else {

            _failedToUpdatePrescription(context);
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


  void _failedToUpdatePrescription(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Update Prescription", message: "Falied to update prescription");
    _view.onUpdateFailure(context);
  }
}