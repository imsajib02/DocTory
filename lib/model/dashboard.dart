import 'package:doctory/model/chamber.dart';

class Dashboard {

  int patients;
  int appointments;
  int prescriptions;
  String income;
  String expense;
  String netIncome;
  List<Chamber> allChamber;

  Dashboard.fromJson(Map<String, dynamic> json) {

    patients =  json['patient'] == null ? 0 : json['patient'];
    appointments =  json['appointment'] == null ? 0 : json['appointment'];
    prescriptions =  json['prescription'] == null ? 0 : json['prescription'];
    income =  json['total_income'] == null ? "" : json['total_income'];
    expense =  json['total_expense'] == null ? "" : json['total_expense'];
    netIncome =  json['net_income'] == null ? "" : json['net_income'];

    allChamber = List();

    if(json['chamber_list'] != null) {

      json['chamber_list'].forEach((chamber) {

        allChamber.add(Chamber.fromJson(chamber));
      });
    }
  }
}