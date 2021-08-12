import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/income.dart';
import 'package:doctory/model/investigation.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/prescription_medicine.dart';

class Prescription {

  int id;
  String number;
  int patientID;
  int chamberID;
  int incomeID;
  String createdAt;
  String originalDate;
  String followUpDateTime;
  String followUpDate;
  String followUpTime;
  String updatedTime;
  String history;
  Income income;
  Chamber chamber;
  Patient patient;
  List<Investigation> investigations;
  List<PrescriptionMedicine> prescriptionMedicineList;

  Prescription({this.id, this.patientID, this.chamberID, this.incomeID, this.followUpDate, this.followUpTime, this.followUpDateTime, this.createdAt,
    this.updatedTime, this.income, this.chamber, this.patient, this.investigations, this.history, this.number, this.prescriptionMedicineList});

  Prescription.fromJson(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    number =  json['number'] == null ? "" : json['number'];
    history =  json['history'] == null ? "" : json['history'];

    investigations = List();

    if(json['investigations'] != null) {

      json['investigations'].forEach((investigationTopic) {

        investigations.add(Investigation.fromJson(investigationTopic));
      });
    }

    createdAt =  json['created_at'] == null ? "" : json['created_at'];
    originalDate =  json['created_at'] == null ? "" : json['created_at'];

    DateTime date = DateFormat('yyyy-MM-dd').parse(createdAt);
    createdAt = DateFormat('MMMM d, yyyy').format(date);

    followUpDateTime =  json['follow_up_date'] == null ? "" : json['follow_up_date'];

    var splitList = followUpDateTime.split(" ");

    date = DateFormat('yyyy-MM-dd').parse(splitList[0]);
    followUpDate = DateFormat('MMMM d, yyyy').format(date);

    followUpTime = splitList[1] + " " + splitList[2];

    updatedTime =  json['updated_at'] == null ? "" : json['updated_at'];
    income =  json['income'] == null ? Income() : Income.fromJson(json['income']);
    chamber =  json['chamber'] == null ? Chamber() : Chamber.fromJson(json['chamber']);
    patient =  json['patient'] == null ? Patient() : Patient.fromJson(json['patient']);
    patientID =  patient.id == null ? 0 : patient.id;
    chamberID =  chamber.id == null ? 0 : chamber.id;
    incomeID =  income.id == null ? 0 : income.id;

    prescriptionMedicineList = List();

    if(json['medicines'] != null) {

      json['medicines'].forEach((prescriptionMedicine) {

        prescriptionMedicineList.add(PrescriptionMedicine.fromJson(prescriptionMedicine));
      });
    }
  }

  Prescription.fromCreate(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    history =  json['history'] == null ? "" : json['history'];
    createdAt =  json['created_at'] == null ? "" : json['created_at'];
    originalDate =  json['created_at'] == null ? "" : json['created_at'];

    DateTime date = DateFormat('yyyy-MM-dd').parse(createdAt);
    createdAt = DateFormat('MMMM d, yyyy').format(date);

    followUpDate =  json['follow_up_date'] == null ? "" : json['follow_up_date'];
    updatedTime =  json['updated_at'] == null ? "" : json['updated_at'];
    income =  json['income'] == null ? Income() : Income.fromJson(json['income']);
    chamber =  json['chamber'] == null ? Chamber() : Chamber.fromJson(json['chamber']);
    patient =  json['patient'] == null ? Patient() : Patient.fromJson(json['patient']);
    patientID =  patient.id == null ? 0 : patient.id;
    chamberID =  chamber.id == null ? 0 : chamber.id;
    incomeID =  income.id == null ? 0 : income.id;

    prescriptionMedicineList = List();

    if(json['medicines'] != null) {

      json['medicines'].forEach((prescriptionMedicine) {

        prescriptionMedicineList.add(PrescriptionMedicine.fromJson(prescriptionMedicine));
      });
    }
  }

  Prescription.fromReport(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    number =  json['number'] == null ? "" : json['number'];
    createdAt =  json['created_at'] == null ? "" : json['created_at'];
    originalDate =  json['created_at'] == null ? "" : json['created_at'];

    DateTime date = DateFormat('yyyy-MM-dd').parse(createdAt);
    createdAt = DateFormat('MMMM d, yyyy').format(date);

    followUpDateTime =  json['follow_up_date'] == null ? "" : json['follow_up_date'];

    var splitList = followUpDateTime.split(" ");

    date = DateFormat('d/M/yyyy').parse(splitList[0].split("-").reversed.join("/"));
    followUpDate = DateFormat('MMMM d, yyyy').format(date);

    history =  json['history'] == null ? "" : json['history'];
    income =  json['income'] == null ? Income() : Income.fromJson(json['income']);
    chamber =  json['chamber'] == null ? Chamber() : Chamber.fromJson(json['chamber']);

    investigations = List();

    if(json['investigations'] != null) {

      json['investigations'].forEach((investigation) {

        investigations.add(Investigation.fromJson(investigation));
      });
    }

    prescriptionMedicineList = List();

    if(json['medicines'] != null) {

      json['medicines'].forEach((prescriptionMedicine) {

        prescriptionMedicineList.add(PrescriptionMedicine.fromJson(prescriptionMedicine));
      });
    }
  }

  toJson() {

    List<String> medicineList = List();
    List<String> dosageList = List();
    List<String> timeList = List();
    List<String> durationList = List();
    List<String> noteList = List();
    List<String> investigationList = List();
    List<String> resultList = List();

    if(prescriptionMedicineList != null) {

      prescriptionMedicineList.forEach((prescriptionMedicine) {

        medicineList.add(prescriptionMedicine.medicine.id.toString());
        dosageList.add(prescriptionMedicine.dosage);

        switch (prescriptionMedicine.timeIndex) {

          case 0:
            timeList.add("before-meal");
            break;

          case 1:
            timeList.add("after-meal");
            break;

          case 2:
            timeList.add("anytime");
            break;

          default:
            timeList.add("anytime");
            break;
        }

        durationList.add(prescriptionMedicine.duration);
        noteList.add(prescriptionMedicine.note);
      });
    }

    if(investigations != null) {

      investigations.forEach((item) {

        investigationList.add(item.id.toString());
        resultList.add(item.result);
      });
    }

    return {
      "visiting_fee" : income.visitingFee == null ? "0" : income.visitingFee.toString(),
      "follow_up_date" : followUpDate == null ? "" : followUpDate,
      "chamber_id" : chamberID == null ? "0" : chamberID.toString(),
      "patient_id" : patientID == null ? "0" : patientID.toString(),
      "history" : history == null ? "" : history,
      "investigation" : json.encode(investigationList),
      "result" : json.encode(resultList),
      "medicine" : json.encode(medicineList),
      "dosage" : json.encode(dosageList),
      "time" : json.encode(timeList),
      "duration" : json.encode(durationList),
      "details" : json.encode(noteList)
    };
  }
}


class Prescriptions {

  List<Prescription> list;
  List<Patient> patientList;
  List<Chamber> chamberList;
  List<Investigation> investigationTopics;

  Prescriptions({this.list, this.chamberList, this.patientList});

  Prescriptions.fromJson(Map<String, dynamic> json) {

    list = List();
    patientList = List();
    chamberList = List();
    investigationTopics = List();

    if(json['prescription_list'] != null) {

      json['prescription_list'].forEach((prescription) {

        list.add(Prescription.fromJson(prescription));
      });
    }

    if(json['investigations'] != null) {

      json['investigations'].forEach((investigation) {

        investigationTopics.add(Investigation.fromJson(investigation));
      });
    }

    if(json['patient_list'] != null) {

      json['patient_list'].forEach((patient) {

        patientList.add(Patient.fromJson(patient));
      });
    }

    if(json['chamber_list'] != null) {

      json['chamber_list'].forEach((chamber) {

        chamberList.add(Chamber.fromJson(chamber));
      });
    }
  }
}