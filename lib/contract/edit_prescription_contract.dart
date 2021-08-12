import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/expense.dart';
import 'package:doctory/model/medicine.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/model/prescription_medicine.dart';
import 'package:flutter/material.dart';

abstract class View {

  void onEmpty(String message);
  void onError(String message);
  void hideProgressDialog();
  void showProgressDialog(String message);
  void onUpdateSuccess(BuildContext context);
  void onUpdateFailure(BuildContext context);
  void backToPrescriptionPage();
  void setMedicineList(Medicines medicines);
  void addMedicineToList(PrescriptionMedicine prescriptionMedicine);
  void updateMedicineInList(PrescriptionMedicine prescriptionMedicine, int position);
  void onNoConnection();
  void onConnectionTimeOut();
}

abstract class Presenter {

  void validateInput(BuildContext context, String token, Prescription inputData);
  void validateMedicineInput(BuildContext context, PrescriptionMedicine input, bool reEdit, {int position});
  void loadMedicineList();
}