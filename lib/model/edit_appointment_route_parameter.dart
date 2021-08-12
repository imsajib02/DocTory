import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

class EditAppointmentRouteParameter {

  User currentUser;
  Appointment appointment;
  List<Appointment> appointmentList;
  List<Chamber> chamberList;
  List<Patient> patientList;

  EditAppointmentRouteParameter({this.currentUser, this.appointment, this.appointmentList, this.chamberList, this.patientList});
}