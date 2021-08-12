import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

class CreateAppointmentRouteParameter {

  User currentUser;
  List<Appointment> appointmentList;
  List<Chamber> chamberList;
  List<Patient> patientList;

  CreateAppointmentRouteParameter({this.currentUser, this.appointmentList, this.chamberList, this.patientList});
}