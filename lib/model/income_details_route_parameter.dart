import 'package:doctory/model/income.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

class IncomeDetailsRouteParameter {

  User currentUser;
  Income income;

  IncomeDetailsRouteParameter({this.currentUser, this.income});
}