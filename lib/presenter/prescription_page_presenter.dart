import 'dart:convert';
import 'package:doctory/contract/prescription_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/utils/connection_check.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrescriptionPagePresenter implements Presenter {

  View _view;
  Prescriptions _prescriptions;

  PrescriptionPagePresenter(this._view);


  @override
  Future<void> getPrescriptions(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.PRESCRIPTION_LIST_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Prescription Page Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              _prescriptions = Prescriptions.fromJson(jsonData);

              _prescriptions.list.sort((a, b) => a.originalDate.compareTo(b.originalDate));

              _view.storeOriginalData(_prescriptions);
            }
            else {

              _failedToGetPrescriptions();
            }
          }
          else {

            _failedToGetPrescriptions();
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          client.close();

          _view.showFailedToLoadDataView();
          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.showFailedToLoadDataView();
        _view.onNoConnection();
      }
    });
  }


  void _failedToGetPrescriptions() {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Prescription Page", message: "Falied to get prescription data");
    _view.showFailedToLoadDataView();
  }


  @override
  Future<void> deletePrescription(BuildContext context, int prescriptionID, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var client = http.Client();

        client.post(

          Uri.encodeFull(APIRoute.DELETE_PRESCRIPTION_URL + prescriptionID.toString()),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Prescription Delete Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Prescription Delete Successful",
                  message: "Deleted prescription id: " + prescriptionID.toString());

              _view.onDeleteSuccess(context, prescriptionID);
            }
            else {

              _failedToDeletePrescription(context);
            }
          }
          else {

            _failedToDeletePrescription(context);
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          client.close();

          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.onNoConnection();
      }
    });
  }

  void _failedToDeletePrescription(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Prescription Delete", message: "Falied to delete prescription");
    _view.onDeleteFailed(context);
  }

  @override
  Future<void> filterDataChamberWise(BuildContext context, String pattern, String chamberName, List<Prescription> prescriptionList, bool isSearched, String fromDate, String toDate) async {

    List<Prescription> result = List();

    _view.showProgressIndicator();

    List<Prescription> filterList = await _sortDateWise(prescriptionList, fromDate, toDate);

    filterList.forEach((prescription) {

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        if(!isSearched) {

          result.add(prescription);
        }
        else {

          if(prescription.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(prescription);
          }
        }
      }
      else {

        if(!isSearched) {

          if(chamberName == prescription.chamber.name) {

            result.add(prescription);
          }
        }
        else {

          if(chamberName == prescription.chamber.name && prescription.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(prescription);
          }
        }
      }
    });

    _view.showSearchedAndFilteredList(result, isSearched);
  }

  @override
  Future<void> onTextChanged(BuildContext context, String value, String chamberName, List<Prescription> prescriptionList, String fromDate, String toDate) async {

    if(value.length == 0) {

      List<Prescription> result = List();

      List<Prescription> filterList = await _sortDateWise(prescriptionList, fromDate, toDate);

      if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

        _view.onSearchCleared(filterList);
      }
      else {

        filterList.forEach((prescription) {

          if(chamberName == prescription.chamber.name) {

            result.add(prescription);
          }
        });

        _view.onSearchCleared(result);
      }
    }
  }

  @override
  Future<void> searchPrescription(BuildContext context, String pattern, String chamberName, List<Prescription> prescriptionList, String fromDate, String toDate) async {

    List<Prescription> result = List();

    if(pattern.isNotEmpty) {

      _view.showProgressIndicator();

      List<Prescription> filterList = await _sortDateWise(prescriptionList, fromDate, toDate);

      filterList.forEach((prescription) {

        if(chamberName == AppLocalization.of(context).getTranslatedValue("all_chamber_filter")) {

          if(prescription.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(prescription);
          }
        }
        else {

          if(chamberName == prescription.chamber.name && prescription.patient.name.toLowerCase().startsWith(pattern.toLowerCase())) {

            result.add(prescription);
          }
        }
      });

      _view.showSearchedAndFilteredList(result, true);
    }
  }

  Future<List<Prescription>> _sortDateWise(List<Prescription> prescriptionList, String fromDate, String toDate) async {

    List<Prescription> list = List();

    if((fromDate.isNotEmpty && fromDate != "- - - -") && (toDate.isNotEmpty && toDate != "- - - -")) {

      prescriptionList.forEach((prescription) {

        DateTime date1 = DateFormat('dd-MM-yyyy').parse(fromDate);
        DateTime date2 = DateFormat('dd-MM-yyyy').parse(toDate);

        DateTime presDate = DateFormat('MMMM d, yyyy').parse(prescription.createdAt);

        final diff1 = DateTime(presDate.year, presDate.month, presDate.day).difference(DateTime(date1.year, date1.month, date1.day)).inDays;
        final diff2 = DateTime(presDate.year, presDate.month, presDate.day).difference(DateTime(date2.year, date2.month, date2.day)).inDays;

        if(diff1 >= 0 && diff2 <= 0) {

          list.add(prescription);
        }
      });
    }
    else {

      list = prescriptionList;
    }

    return list;
  }

  @override
  void printPrescription(BuildContext context, int prescriptionID, int userID) {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("generating_pdf"));

        var client = http.Client();

        //generate with prescription id
        client.get(

          Uri.encodeFull(APIRoute.PRESCRIPTION_GENERATE_URL + prescriptionID.toString()),

        ).then((response) {

          if(response.statusCode == 200 || response.statusCode == 201) {

            //download with user id
            client.get(

              Uri.encodeFull(APIRoute.BASE_URL + userID.toString() + "-prescription.pdf"),

            ).then((response) async {

              if(response.statusCode == 200 || response.statusCode == 201) {

                _view.hideProgressDialog();

                var pdfData = response.bodyBytes;
                await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
              }
              else {

                _view.onPrintFailed(context);
              }

            }).timeout(Duration(seconds: 10), onTimeout: () {

              client.close();
              _view.onConnectionTimeOut();
            });
          }
          else {

            _view.onPrintFailed(context);
          }

        }).timeout(Duration(seconds: 10), onTimeout: () {

          client.close();
          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.onNoConnection();
      }
    });
  }
}