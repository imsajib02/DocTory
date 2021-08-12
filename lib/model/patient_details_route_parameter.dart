import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

class PatientDetailsRouteParameter {

  User currentUser;
  Patient patient;

  PatientDetailsRouteParameter({this.currentUser, this.patient});
}