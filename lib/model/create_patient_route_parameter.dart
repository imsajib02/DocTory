import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

class CreatePatientRouteParameter {

  User currentUser;
  List<Patient> patientList;

  CreatePatientRouteParameter({this.currentUser, this.patientList});
}