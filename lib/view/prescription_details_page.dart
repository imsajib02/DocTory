import 'package:doctory/contract/prescription_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/model/prescription_details_route_parameter.dart';
import 'package:doctory/presenter/prescription_page_presenter.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';
import '../model/dashboard_route_parameter.dart';

class PrescriptionDetails extends StatefulWidget {

  final PrescriptionDetailsRouteParameter _parameter;

  PrescriptionDetails(this._parameter);

  @override
  _PrescriptionDetailsState createState() => _PrescriptionDetailsState();
}

class _PrescriptionDetailsState extends State<PrescriptionDetails> implements View {

  Presenter _presenter;
  MyWidget _myWidget;
  BuildContext _scaffoldContext;

  TextEditingController _detailsController = TextEditingController();
  int _maxLine;

  @override
  void initState() {

    _presenter = PrescriptionPagePresenter(this);
    _myWidget = MyWidget(context);

    _detailsController.text = widget._parameter.prescription.history;
    _maxLine = (widget._parameter.prescription.history.length / 40).round() + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: BackButton(
              color: Colors.white
          ),
          backgroundColor: Colors.deepOrangeAccent,
          brightness: Brightness.dark,
          elevation: 2,
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranslatedValue("prescription_details"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            _scaffoldContext = context;

            return SafeArea(
              child: ScrollConfiguration(
                behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(top: 5 * SizeConfig.heightSizeMultiplier,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        Flexible(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                              child: Text(AppLocalization.of(context).getTranslatedValue("bdt_sign") + widget._parameter.prescription.income.visitingFee.toString(),
                                style: Theme.of(context).textTheme.display4.copyWith(color: Colors.green),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 3 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            decoration: BoxDecoration(
                                border: Border(top: BorderSide(width: 1, color: Colors.black38))
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(AppLocalization.of(context).getTranslatedValue("follow_up_date_text") + widget._parameter.prescription.followUpDate,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal)
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                      onTap: () {

                                        _presenter.printPrescription(context, widget._parameter.prescription.id, widget._parameter.currentUser.userID);
                                      },
                                      child: Icon(Icons.print, color: Colors.blueGrey, size: 8.97 * SizeConfig.imageSizeMultiplier,)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey
                            ),
                            child: Text(AppLocalization.of(context).getTranslatedValue("chamber_info"),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Expanded(
                                  flex: 1,
                                  child: Text(AppLocalization.of(context).getTranslatedValue("patient_name"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                Expanded(
                                  flex: 5,
                                  child: Text(widget._parameter.prescription.chamber.name,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.875 * SizeConfig.heightSizeMultiplier, right: 1.875 * SizeConfig.heightSizeMultiplier,
                                bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Flexible(
                                  child: Text(AppLocalization.of(context).getTranslatedValue("chamber_location"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Flexible(
                                  child: Text(widget._parameter.prescription.chamber.address,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey
                            ),
                            child: Text(AppLocalization.of(context).getTranslatedValue("patient_info"),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Expanded(
                                  flex: 1,
                                  child: Text(AppLocalization.of(context).getTranslatedValue("patient_name"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                Expanded(
                                  flex: 5,
                                  child: Text(widget._parameter.prescription.patient.name,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.875 * SizeConfig.heightSizeMultiplier, right: 1.875 * SizeConfig.heightSizeMultiplier,
                                bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Flexible(
                                  child: Text(AppLocalization.of(context).getTranslatedValue("patient_age"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Flexible(
                                  child: Text(widget._parameter.prescription.patient.age,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.875 * SizeConfig.heightSizeMultiplier, right: 1.875 * SizeConfig.heightSizeMultiplier,
                                bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Flexible(
                                  child: Text(AppLocalization.of(context).getTranslatedValue("patient_gender"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Flexible(
                                  child: Text(widget._parameter.prescription.patient.gender,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.875 * SizeConfig.heightSizeMultiplier, right: 1.875 * SizeConfig.heightSizeMultiplier,
                                bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Flexible(
                                  child: Text(AppLocalization.of(context).getTranslatedValue("patient_phone"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Flexible(
                                  child: Text(widget._parameter.prescription.patient.mobile,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.875 * SizeConfig.heightSizeMultiplier, right: 1.875 * SizeConfig.heightSizeMultiplier,
                                bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Flexible(
                                  child: Text(AppLocalization.of(context).getTranslatedValue("patient_address"),
                                    style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal, color: Colors.black54),
                                  ),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Flexible(
                                  child: Text(widget._parameter.prescription.patient.address,
                                    style: Theme.of(context).textTheme.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey
                            ),
                            child: Text(AppLocalization.of(context).getTranslatedValue("patient_history_hint"),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: widget._parameter.prescription.history.length > 0,
                          child: SizedBox(height: 1.5 * SizeConfig.heightSizeMultiplier,),
                        ),

                        Flexible(
                          child: Visibility(
                            visible: widget._parameter.prescription.history.length > 0,
                            child: TextField(
                              controller: _detailsController,
                              keyboardType: TextInputType.text,
                              enabled: false,
                              maxLines: _maxLine,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none,),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                                fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 4 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey
                            ),
                            child: Text(AppLocalization.of(context).getTranslatedValue("investigation_info_hint"),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 1.5 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                            child: Wrap(
                              children: widget._parameter.prescription.investigations.map((item) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 3 * SizeConfig.widthSizeMultiplier, vertical: 1 * SizeConfig.heightSizeMultiplier),
                                margin: EdgeInsets.only(left: 1.28 * SizeConfig.widthSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier,
                                    bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[700], width: .512 * SizeConfig.widthSizeMultiplier),
                                  borderRadius: BorderRadius.all(Radius.circular(2.5 * SizeConfig.heightSizeMultiplier))
                                ),
                                child: Text(item.topic,
                                  style: Theme.of(context).textTheme.subtitle
                                ),
                              )).toList(),
                            ),
                          ),
                        ),

                        SizedBox(height: 4 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey
                            ),
                            child: Text(AppLocalization.of(context).getTranslatedValue("medicine_info"),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 3 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 5 * SizeConfig.widthSizeMultiplier, right: 5 * SizeConfig.widthSizeMultiplier,
                                bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: widget._parameter.prescription.prescriptionMedicineList.length,
                                itemBuilder: (BuildContext context, int index) {

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 1.5 * SizeConfig.heightSizeMultiplier),
                                    child: Container(
                                      child: Material(
                                        elevation: 10,
                                        color: Theme.of(context).primaryColor,
                                        shadowColor: AppThemeNotifier().isDarkModeOn ? Colors.black12 : Colors.black45,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[

                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                                  child: Text(widget._parameter.prescription.prescriptionMedicineList[index].medicine.brandName,
                                                    style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.indigo),
                                                  ),
                                                ),
                                              ),

                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                                  child: Text(widget._parameter.prescription.prescriptionMedicineList[index].dosage,
                                                    style: Theme.of(context).textTheme.subhead,
                                                  ),
                                                ),
                                              ),

                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                                  child: Text(AppLocalization.of(context).getTranslatedValue("med_taking_time") + widget._parameter.prescription.prescriptionMedicineList[index].time,
                                                    style: Theme.of(context).textTheme.subhead
                                                  ),
                                                ),
                                              ),

                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                                  child: Text(AppLocalization.of(context).getTranslatedValue("duration_text") + widget._parameter.prescription.prescriptionMedicineList[index].duration,
                                                    style: Theme.of(context).textTheme.subhead
                                                  ),
                                                ),
                                              ),

                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                                  child: Text(AppLocalization.of(context).getTranslatedValue("note_text") + widget._parameter.prescription.prescriptionMedicineList[index].note,
                                                    style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _backPressed() {

    DashboardRouteParameter parameter = DashboardRouteParameter(currentUser: widget._parameter.currentUser, pageNumber: 3);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.DASHBOARD_ROUTE, arguments: parameter);

    return Future(() => false);
  }

  @override
  void hideProgressDialog() {

    _myWidget.hideProgressDialog();
  }

  @override
  void onConnectionTimeOut() {

    hideProgressDialog();
    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("connection_time_out"), Colors.red, 3);
  }

  @override
  void onDeleteFailed(BuildContext context) {
  }

  @override
  void onDeleteSuccess(BuildContext context, int prescriptionID) {
  }

  @override
  void onNoConnection() {

    hideProgressDialog();
    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("no_internet_available"), Colors.red, 3);
  }

  @override
  void onPrintFailed(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_generate_pdf"),
        Colors.red, 3);
  }

  @override
  void onSearchCleared(List<Prescription> prescriptionList) {
  }

  @override
  void showFailedToLoadDataView() {
  }

  @override
  void showPrescriptionList(Prescriptions prescriptions) {
  }

  @override
  void showProgressDialog(String message) {

    _myWidget.showProgressDialog(message);
  }

  @override
  void showProgressIndicator() {
  }

  @override
  void showSearchedAndFilteredList(List<Prescription> resultList, bool isSearched) {
  }

  @override
  void storeOriginalData(Prescriptions prescriptions) {
  }
}