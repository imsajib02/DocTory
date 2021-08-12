import 'package:doctory/model/medicine.dart';

class PrescriptionMedicine {

  int id;
  int medicineID;
  Medicine medicine;
  String dosage;
  String time;
  int timeIndex;
  String duration;
  String note;
  bool isMedicineSelected;
  bool isTimeSelected;

  PrescriptionMedicine({this.medicine, this.dosage, this.time, this.timeIndex, this.id,
    this.duration, this.note, this.isMedicineSelected, this.isTimeSelected, this.medicineID});

  PrescriptionMedicine.fromJson(Map<String, dynamic> json) {

    id = json['id'] == null ? 0 : json['id'];
    dosage = json['dosage'] == null ? "" : json['dosage'];
    time = json['time'] == null ? "" : json['time'];

    if(time.startsWith("after")) {

      timeIndex = 1;
    }
    else if(time.startsWith("before")) {

      timeIndex = 0;
    }
    else if(time.startsWith("any")) {

      timeIndex = 2;
    }

    time[0].toUpperCase();

    if(time.contains("-")) {

      time.replaceAll("-", " ");
    }

    duration = json['duration'] == null ? "" : json['duration'];
    note = json['details'] == null ? "" : json['details'];
    medicineID = json['medicine_id'] == null ? 0 : json['medicine_id'];
    medicine = json['medicine'] == null ? Medicine() : Medicine.fromJson(json['medicine']);
  }

  toJson() {

    return {
      "dosage" : dosage == null ? "" : dosage,
      "time" : timeIndex == null ? "" : timeIndex == 0 ? "before-meal" : timeIndex == 1 ? "after-meal" : "anytime",
      "duration" : duration == null ? "" : duration,
      "details" : note == null ? "" : note,
      "medicine_id" : medicineID == null ? "0" : medicineID.toString(),
    };
  }
}