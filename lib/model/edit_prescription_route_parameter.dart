import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/investigation.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/model/user.dart';

class EditPrescriptionRouteParameter {

  User currentUser;
  Prescription prescription;
  List<Prescription> prescriptionList;
  List<Chamber> chamberList;
  List<Patient> patientList;
  List<Investigation> investigationList;

  EditPrescriptionRouteParameter({this.currentUser, this.prescription, this.prescriptionList, this.chamberList, this.patientList, this.investigationList});
}