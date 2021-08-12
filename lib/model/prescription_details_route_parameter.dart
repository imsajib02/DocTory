import 'package:doctory/model/income.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

import 'prescription.dart';

class PrescriptionDetailsRouteParameter {

  User currentUser;
  Prescription prescription;

  PrescriptionDetailsRouteParameter({this.currentUser, this.prescription});
}