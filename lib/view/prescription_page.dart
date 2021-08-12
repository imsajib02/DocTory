import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/localization/localization_constrants.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/create_prescription_route_parameter.dart';
import 'package:doctory/model/edit_prescription_route_parameter.dart';
import 'package:doctory/model/investigation.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/model/prescription_details_route_parameter.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/presenter/prescription_page_presenter.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/local_memory.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:doctory/contract/prescription_page_contract.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class PrescriptionPage extends StatefulWidget {

  final User _currentUser;

  PrescriptionPage(this._currentUser);

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  Widget _body;
  MyWidget _myWidget;

  List<Prescription> _prescriptionList;
  List<Prescription> _resultList;
  List<Patient> _patientList;
  List<Chamber> _chamberList;
  List<Investigation> _investigationList;

  List<String> _chamberFilterList;
  List<String> _timeFilterList;
  String _selectedChamber;

  Locale _locale;
  LocalMemory _localMemory;

  bool _visibility;
  bool _isSearched;
  FocusNode _focusNode;

  TextEditingController _searchController = TextEditingController();
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  BuildContext _scaffoldContext;

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _presenter = PrescriptionPagePresenter(this);
    _body = Container();
    _myWidget = MyWidget(context);

    _localMemory = LocalMemory();

    _localMemory.getLanguageCode().then((locale) {

      _locale = locale;
    });

    _visibility = false;

    _prescriptionList = List();
    _resultList = List();

    _focusNode = FocusNode();
    _isSearched = false;

    _dateController1.text = "- - - -";
    _dateController2.text = "- - - -";

    super.initState();
  }

  @override
  void didChangeDependencies() {

    try {

      _chamberFilterList = [AppLocalization.of(context).getTranslatedValue("all_chamber_filter")];

      _timeFilterList = [AppLocalization.of(context).getTranslatedValue("today_filter"),
        AppLocalization.of(context).getTranslatedValue("from_yesterday_filter"),
        AppLocalization.of(context).getTranslatedValue("from_last_week_filter"),
        AppLocalization.of(context).getTranslatedValue("from_last_month_filter"),
        AppLocalization.of(context).getTranslatedValue("from_last_year_filter")];

      _selectedChamber = _chamberFilterList[0];

      _presenter.getPrescriptions(context, widget._currentUser.accessToken);
    }
    catch(error) {

      print(error);
    }

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {

        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            _scaffoldContext = context;

            return SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Visibility(
                      visible: _visibility,
                      child: Column(
                        children: <Widget>[

                          Container(
                            width: double.infinity,
                            height: 5.5 * SizeConfig.heightSizeMultiplier,
                            margin: EdgeInsets.only(left: 5 * SizeConfig.widthSizeMultiplier, right: 5 * SizeConfig.widthSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.deepOrangeAccent,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      keyboardType: TextInputType.text,
                                      focusNode: _focusNode,
                                      onChanged: (value) {

                                        _presenter.onTextChanged(context, value, _selectedChamber, _prescriptionList, _dateController1.text, _dateController2.text);
                                      },
                                      decoration: InputDecoration(
                                        hintText: AppLocalization.of(context).getTranslatedValue("search_by_patient_name"),
                                        hintStyle: Theme.of(context).textTheme.caption,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {

                                      _focusNode.unfocus();

                                      String pattern = _searchController.text;
                                      _presenter.searchPrescription(context, pattern, _selectedChamber, _prescriptionList, _dateController1.text, _dateController2.text);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.deepOrangeAccent,
                                          style: BorderStyle.solid,
                                        ),
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                                      ),
                                      child: Text(AppLocalization.of(context).getTranslatedValue("search_btn"),
                                        style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                          Container(
                            padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[

                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                    height: 5 * SizeConfig.heightSizeMultiplier,
                                    width: 38.46 * SizeConfig.widthSizeMultiplier,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) : Colors.black26,
                                        width: .3846 * SizeConfig.widthSizeMultiplier,),
                                    ),
                                    child: DropdownButton(
                                      value: _selectedChamber,
                                      isExpanded: true,
                                      isDense: true,
                                      underline: SizedBox(),
                                      items: _chamberFilterList.map((value) {

                                        return DropdownMenuItem(child: Text(value), value: value);
                                      }).toList(),
                                      onChanged: (value) {

                                        setState(() {

                                          if(value != _selectedChamber) {

                                            _selectedChamber = value;
                                            String pattern = _searchController.text;

                                            _presenter.filterDataChamberWise(context, pattern, _selectedChamber, _prescriptionList, _isSearched, _dateController1.text, _dateController2.text);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5.12 * SizeConfig.widthSizeMultiplier,),

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {

                                      _showDateSelectionDialog(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 5.89 * SizeConfig.imageSizeMultiplier,
                                      child: Icon(Icons.date_range,
                                        size: 6.41 * SizeConfig.imageSizeMultiplier,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5.12 * SizeConfig.widthSizeMultiplier,),

                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {

                                      CreatePrescriptionRouteParameter parameter = CreatePrescriptionRouteParameter(currentUser: widget._currentUser,
                                          prescriptionList: _prescriptionList, chamberList: _chamberList, patientList: _patientList, investigationList: _investigationList);

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed(RouteManager.CREATE_PRESCRIPTION_ROUTE, arguments: parameter);
                                    },
                                    child: CircleAvatar(
                                      radius: 5.89 * SizeConfig.imageSizeMultiplier,
                                      backgroundColor: Colors.blue,
                                      child: Icon(Icons.add,
                                        size: 6.41 * SizeConfig.imageSizeMultiplier,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),
                        ],
                      ),
                    ),

                    _body,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  void _showDateSelectionDialog(BuildContext scaffoldContext) async {

    return showDialog(
        context: context,
        builder: (BuildContext context) {

          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,

            child: Container(
              height: 25 * SizeConfig.heightSizeMultiplier,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Text(AppLocalization.of(context).getTranslatedValue("from"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Text(AppLocalization.of(context).getTranslatedValue("to"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showDatePicker(context, _dateController1);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      enabled: false,
                                      controller: _dateController1,
                                      style: Theme.of(context).textTheme.subhead,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(width: 1, style: BorderStyle.solid,),
                                        ),
                                        filled: true,
                                        contentPadding: EdgeInsets.all(1.5 * SizeConfig.heightSizeMultiplier),
                                        fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 5.12 * SizeConfig.widthSizeMultiplier,),

                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _showDatePicker(context, _dateController2);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: TextField(
                                      enabled: false,
                                      controller: _dateController2,
                                      style: Theme.of(context).textTheme.subhead,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(width: 1, style: BorderStyle.none,),
                                        ),
                                        filled: true,
                                        contentPadding: EdgeInsets.all(1.5 * SizeConfig.heightSizeMultiplier),
                                        fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.red,
                                child: Text(AppLocalization.of(context).getTranslatedValue("cancel_text"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();

                                String pattern = _searchController.text;
                                _presenter.filterDataChamberWise(context, pattern, _selectedChamber, _prescriptionList, _isSearched, _dateController1.text, _dateController2.text);
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.blue,
                                child: Text(AppLocalization.of(context).getTranslatedValue("ok_message"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  _showDatePicker(BuildContext scaffoldContext, TextEditingController controller) {

    var pickerFormat = DateFormat('yyyy-MM-dd');

    DateTime currentDateTime = DateTime.now();
    String currentDate = pickerFormat.format(currentDateTime);

    String minDate = "2001-01-01";

    var dateSplitList = currentDate.split("-");
    dateSplitList[0] = (int.tryParse(dateSplitList[0]) + 10).toString();

    String maxDate = "${dateSplitList[0]}-12-12";

    String dateFormat = 'MMM-d-yyyy';

    try {

      showDialog(
          context: scaffoldContext,
          builder: (BuildContext context) {

            return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,

              child: Container(
                height: 50 * SizeConfig.heightSizeMultiplier,
                child: DatePickerWidget(
                  onMonthChangeStartWithFirstDate: false,
                  minDateTime: DateTime.tryParse(minDate),
                  maxDateTime: DateTime.tryParse(maxDate),
                  initialDateTime: DateTime.tryParse(currentDate),
                  dateFormat: dateFormat,
                  locale: DateTimePickerLocale.en_us,
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: Theme.of(context).primaryColor,
                    itemTextStyle: TextStyle(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black),
                    cancel: Text(AppLocalization.of(context).getTranslatedValue("cancel_text"),
                      style: TextStyle(
                        fontSize: 1.75 * SizeConfig.textSizeMultiplier,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    confirm: Text(AppLocalization.of(context).getTranslatedValue("done_text"),
                      style: TextStyle(
                        fontSize: 1.75 * SizeConfig.textSizeMultiplier,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                    ),
                    pickerHeight: 40 * SizeConfig.heightSizeMultiplier,
                    itemHeight: 3.75 * SizeConfig.heightSizeMultiplier,
                  ),
                  onConfirm: (selectedDateTime, selectedIndexList) {

                    setState(() {
                      controller.text = DateFormat('dd-MM-yyyy').format(selectedDateTime);
                    });
                  },
                ),
              ),
            );
          }
      );
    }
    catch(error) {

      print(error);
    }
  }


  @override
  void showProgressIndicator() {

    setState(() {

      _visibility = false;

      _body = Flexible(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }

  @override
  void showProgressDialog(String message) {

    _myWidget.showProgressDialog(message);
  }

  @override
  void hideProgressDialog() {

    _myWidget.hideProgressDialog();
  }

  @override
  void storeOriginalData(Prescriptions prescriptions) {

    _prescriptionList = prescriptions.list;
    _chamberList = prescriptions.chamberList;
    _patientList = prescriptions.patientList;
    _investigationList = prescriptions.investigationTopics;

    prescriptions.chamberList.forEach((chamber) {

      _chamberFilterList.add(chamber.name);
    });

    showPrescriptionList(prescriptions);
  }

  @override
  void showPrescriptionList(Prescriptions prescriptions) {

    _focusNode.unfocus();

    setState(() {

      _visibility = true;

      _body = Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Flexible(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier,
                        left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                    itemCount: prescriptions.list.length,
                    itemBuilder: (BuildContext context, int index) {

                      return GestureDetector(
                        onTap: () {

                          PrescriptionDetailsRouteParameter parameter = PrescriptionDetailsRouteParameter(currentUser: widget._currentUser, prescription: prescriptions.list[index]);

                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(RouteManager.PRESCRIPTION_DETAILS_ROUTE, arguments: parameter);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
                          child: Container(
                            child: Material(
                              elevation: 10,
                              color: Theme.of(context).primaryColor,
                              shadowColor: AppThemeNotifier().isDarkModeOn ? Colors.black12 : Colors.black45,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: <Widget>[

                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(prescriptions.list[index].patient.name,
                                                style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[

                                                  Text(AppLocalization.of(context).getTranslatedValue("age_text") + (prescriptions.list[index].patient.age == null ?
                                                  "" : prescriptions.list[index].patient.age),
                                                    style: Theme.of(context).textTheme.body1.copyWith(fontSize: 1.44 * SizeConfig.textSizeMultiplier),
                                                  ),

                                                  SizedBox(width: 5.128 * SizeConfig.widthSizeMultiplier,),

                                                  Text(AppLocalization.of(context).getTranslatedValue("gender_text") + (prescriptions.list[index].patient.gender == null ?
                                                  "" : prescriptions.list[index].patient.gender),
                                                    style: Theme.of(context).textTheme.body1.copyWith(fontSize: 1.44 * SizeConfig.textSizeMultiplier),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("chamber_text") + ": " + prescriptions.list[index].chamber.name,
                                                style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.green),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("date_text") + prescriptions.list[index].createdAt,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("follow_up_date_text") + prescriptions.list[index].followUpDate,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier,),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("time_text") + prescriptions.list[index].followUpTime,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            SizedBox(height: 1.25 * SizeConfig.heightSizeMultiplier,),
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[

                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: GestureDetector(
                                                  onTap: () {

                                                    _presenter.printPrescription(context, prescriptions.list[index].id, widget._currentUser.userID);
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 2.5 * SizeConfig.heightSizeMultiplier,
                                                    backgroundColor: Colors.lightBlue.shade200,
                                                    child: Icon(Icons.print),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: <Widget>[

                                                  Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                      onTap: () {

                                                        EditPrescriptionRouteParameter parameter = EditPrescriptionRouteParameter(currentUser: widget._currentUser, prescription: prescriptions.list[index],
                                                            prescriptionList: _prescriptionList, chamberList: _chamberList, patientList: _patientList, investigationList: _investigationList);

                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pushNamed(RouteManager.EDIT_PRESCRIPTION_ROUTE, arguments: parameter);
                                                      },
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: CircleAvatar(
                                                          radius: 2.5 * SizeConfig.heightSizeMultiplier,
                                                          backgroundColor: Colors.lightGreen.shade300,
                                                          child: Icon(Icons.edit),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(width: 5.128 * SizeConfig.widthSizeMultiplier,),

                                                  Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                      onTap: () {

                                                        _showDeleteAlert(context, prescriptions.list[index]);
                                                      },
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: CircleAvatar(
                                                          radius: 2.5 * SizeConfig.heightSizeMultiplier,
                                                          backgroundColor: Colors.redAccent.shade200,
                                                          child: Icon(Icons.delete),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void showFailedToLoadDataView() {

    setState(() {

      _body = Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                child: Text(AppLocalization.of(context).getTranslatedValue("could_not_load_data"),
                  style: TextStyle(
                    color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) : Colors.black54,
                    fontSize: 2.8 * SizeConfig.textSizeMultiplier,
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) : Colors.black26),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(5),
                    icon: Icon(
                      Icons.refresh,
                      size: 9 * SizeConfig.imageSizeMultiplier,
                      color: Colors.lightBlueAccent,
                    ),
                    onPressed: () {

                      _presenter.getPrescriptions(context, widget._currentUser.accessToken);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showDeleteAlert(BuildContext scaffoldContext, Prescription prescription) {

    showDialog(
        context: scaffoldContext,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return WillPopScope(
            onWillPop: () {
              return Future(() => false);
            },
            child: AlertDialog(
              elevation: 10,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text(AppLocalization.of(context).getTranslatedValue("alert_message"), textAlign: TextAlign.center,),
              titlePadding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier,
                  left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
              titleTextStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 2.5 * SizeConfig.textSizeMultiplier,
                fontWeight: FontWeight.bold,
              ),
              content: Text(_locale.languageCode == ENGLISH ? (AppLocalization.of(context).getTranslatedValue("delete_prescription_text") + "\"" + prescription.patient.name + "\"?") :
                  ("\"" + prescription.patient.name + "\"" + AppLocalization.of(context).getTranslatedValue("delete_prescription_text")),
                textAlign: TextAlign.center,
              ),
              contentTextStyle: TextStyle(
                color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,
                fontSize: 2.125 * SizeConfig.textSizeMultiplier,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier,
                  left: 5 * SizeConfig.widthSizeMultiplier, right: 5 * SizeConfig.widthSizeMultiplier),
              actions: <Widget>[

                FlatButton(
                  onPressed: () {

                    Navigator.of(context).pop();
                    _presenter.deletePrescription(scaffoldContext, prescription.id, widget._currentUser.accessToken);
                  },
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  child: Text(AppLocalization.of(context).getTranslatedValue("yes_message"), style: TextStyle(

                    fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                  ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
                  child: FlatButton(
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    child: Text(AppLocalization.of(context).getTranslatedValue("no_message"), style: TextStyle(

                      fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                    ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  void onDeleteFailed(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_delete_prescription"),
        Colors.red, 3);
  }

  @override
  void onDeleteSuccess(BuildContext context, int prescriptionID) {

    hideProgressDialog();

    for(int i=0; i<_prescriptionList.length; i++) {

      if(_prescriptionList[i].id == prescriptionID) {

        _prescriptionList.removeAt(i);
        break;
      }
    }

    String pattern = _searchController.text;
    _presenter.filterDataChamberWise(context, pattern, _selectedChamber, _prescriptionList, _isSearched, _dateController1.text, _dateController2.text);

    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("successfully_deleted_prescription"),
        Colors.green, 3);
  }

  @override
  void showSearchedAndFilteredList(List<Prescription> resultList, bool isSearched) {

    _isSearched = isSearched;
    _resultList = resultList;

    Prescriptions prescriptions = Prescriptions(list: resultList);

    showPrescriptionList(prescriptions);
  }

  @override
  void onSearchCleared(List<Prescription> prescriptionList) {

    _isSearched = false;
    _resultList.clear();

    Prescriptions prescriptions = Prescriptions(list: prescriptionList);

    showPrescriptionList(prescriptions);
  }

  @override
  void onNoConnection() {

    hideProgressDialog();

    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("no_internet_available"), Colors.red, 3);
  }

  @override
  void onConnectionTimeOut() {

    hideProgressDialog();

    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("connection_time_out"), Colors.red, 3);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onPrintFailed(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_generate_pdf"),
        Colors.red, 3);
  }
}