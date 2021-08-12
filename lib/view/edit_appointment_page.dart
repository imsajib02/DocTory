import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/dashboard_route_parameter.dart';
import 'package:doctory/model/edit_appointment_route_parameter.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/presenter/edit_appointment_presenter.dart';
import 'package:doctory/presenter/edit_patient_presenter.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctory/contract/edit_appointment_contract.dart';
import 'package:intl/intl.dart';

class EditAppointmentPage extends StatefulWidget {

  final EditAppointmentRouteParameter _parameter;

  EditAppointmentPage(this._parameter);

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  MyWidget _myWidget;
  Appointment _appointment;

  TextEditingController _chamberNameController = TextEditingController();
  TextEditingController _patientController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  BuildContext _scaffoldContext;

  DateTime _currentDateTime;
  var _formatter;

  final _bounceStateKey1 = GlobalKey<BounceState>();
  final _bounceStateKey2 = GlobalKey<BounceState>();
  final _bounceStateKey3 = GlobalKey<BounceState>();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _formatter = DateFormat.yMMMMd('en_US');

    widget._parameter.appointment.date = _formatter.format(DateTime.tryParse(widget._parameter.appointment.originalDate));

    _presenter = EditAppointmentPresenter(this, widget._parameter.appointment, widget._parameter.appointmentList, widget._parameter.patientList);
    _myWidget = MyWidget(context);
    _appointment = Appointment();

    _appointment.chamberID = widget._parameter.appointment.chamberID;
    _chamberNameController.text = widget._parameter.appointment.chamber.name;
    _appointment.patientID = widget._parameter.appointment.patientID;
    _patientNameController.text = widget._parameter.appointment.patientName;
    _mobileController.text = widget._parameter.appointment.patientMobile;
    _dateController.text = widget._parameter.appointment.date;
    _timeController.text = widget._parameter.appointment.time;

    super.initState();
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

        backToAppointmentPage();
        return Future(() => false);
      },
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
          title: Text(AppLocalization.of(context).getTranslatedValue("update_appointment_info"),
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
                    margin: EdgeInsets.only(top: 4 * SizeConfig.heightSizeMultiplier, left: 8 * SizeConfig.widthSizeMultiplier,
                      right: 8 * SizeConfig.widthSizeMultiplier,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: _chamberNameController,
                              style: Theme.of(context).textTheme.subhead,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("choose_chamber_hint"),
                                hintStyle: Theme.of(context).textTheme.subhead,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                                fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                              )
                          ),
                          suggestionsCallback: (pattern) async {
                            return await _getChamberSuggestions(pattern);
                          },
                          itemBuilder: (BuildContext context, Chamber chamber) {
                            return ListTile(
                              title: Text(chamber.name, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal),
                              ),
                            );
                          },
                          onSuggestionSelected: (Chamber chamber) {

                            _chamberNameController.text = chamber.name;
                            _appointment.chamberID = chamber.id;
                          },
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: _patientController,
                              style: Theme.of(context).textTheme.subhead,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("choose_patient_hint"),
                                hintStyle: Theme.of(context).textTheme.subhead,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                                fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                              )
                          ),
                          suggestionsCallback: (pattern) async {
                            return await _getPatientSuggestions(pattern);
                          },
                          itemBuilder: (BuildContext context, Patient patient) {
                            return ListTile(
                              title: Text(patient.name, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal),
                              ),
                            );
                          },
                          onSuggestionSelected: (Patient patient) {

                            //_patientController.text = patient.name;
                            _patientNameController.text = patient.name;
                            _mobileController.text = patient.mobile;
                            _appointment.patientID = patient.id;
                          },
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _patientNameController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("patient_name_hint"),
                            hintStyle: Theme.of(context).textTheme.subhead,
                            helperText: AppLocalization.of(context).getTranslatedValue("enter_patient_name_note"),
                            helperMaxLines: 2,
                            helperStyle: AppThemeNotifier().isDarkModeOn == false ? TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                            ) : TextStyle(
                              color: Colors.white.withOpacity(.4),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 0, style: BorderStyle.none,),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                            fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                          ),
                        ),

                        SizedBox(height: 3.2 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("patient_mobile_hint"),
                            hintStyle: Theme.of(context).textTheme.subhead,
                            helperText: AppLocalization.of(context).getTranslatedValue("enter_patient_mobile_note"),
                            helperMaxLines: 2,
                            helperStyle: AppThemeNotifier().isDarkModeOn == false ? TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                            ) : TextStyle(
                              color: Colors.white.withOpacity(.4),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 0, style: BorderStyle.none,),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                            fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                          ),
                        ),

                        SizedBox(height: 3.2 * SizeConfig.heightSizeMultiplier,),

                        Row(
                          children: <Widget>[

                            Flexible(
                              flex: 6,
                              child: TextField(
                                enabled: false,
                                controller: _dateController,
                                style: Theme.of(context).textTheme.subhead,
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

                            SizedBox(width: 2.56 * SizeConfig.widthSizeMultiplier,),

                            Flexible(
                              flex: 3,
                              child: BounceAnimation(
                                key: _bounceStateKey2,
                                childWidget: RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  elevation: 5,
                                  onPressed: () {

                                    _bounceStateKey2.currentState.animationController.forward();
                                    FocusScope.of(context).unfocus();

                                    _showDatePicker(context);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  textColor: Colors.white,
                                  child: Container(
                                    width: 55 * SizeConfig.widthSizeMultiplier,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Colors.deepPurple,
                                            Color(0xFF9E1E1E),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                                    ),
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Text(
                                      AppLocalization.of(context).getTranslatedValue("pick_text"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 2 * SizeConfig.textSizeMultiplier,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        Row(
                          children: <Widget>[

                            Flexible(
                              flex: 6,
                              child: TextField(
                                enabled: false,
                                controller: _timeController,
                                style: Theme.of(context).textTheme.subhead,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context).getTranslatedValue("time_hint_text"),
                                  hintStyle: Theme.of(context).textTheme.subhead,
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

                            SizedBox(width: 2.56 * SizeConfig.widthSizeMultiplier,),

                            Flexible(
                              flex: 3,
                              child: BounceAnimation(
                                key: _bounceStateKey3,
                                childWidget: RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  elevation: 5,
                                  onPressed: () {

                                    _bounceStateKey3.currentState.animationController.forward();
                                    FocusScope.of(context).unfocus();

                                    _showTimePicker(context);
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  textColor: Colors.white,
                                  child: Container(
                                    width: 55 * SizeConfig.widthSizeMultiplier,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Colors.deepPurple,
                                            Color(0xFF9E1E1E),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                                    ),
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Text(
                                      AppLocalization.of(context).getTranslatedValue("pick_text"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 2 * SizeConfig.textSizeMultiplier,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8 * SizeConfig.heightSizeMultiplier,),

                        Align(
                          alignment: Alignment.center,
                          child: BounceAnimation(
                            key: _bounceStateKey1,
                            childWidget: RaisedButton(
                              padding: EdgeInsets.all(0),
                              elevation: 5,
                              onPressed: () {

                                _bounceStateKey1.currentState.animationController.forward();
                                FocusScope.of(context).unfocus();

                                _appointment.patientName = _patientNameController.text;
                                _appointment.patientMobile = _mobileController.text;
                                _appointment.date = _dateController.text;
                                _appointment.time = _timeController.text;

                                _presenter.validateInput(context, widget._parameter.currentUser.accessToken, _appointment);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              textColor: Colors.white,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.deepPurple,
                                        Color(0xFF9E1E1E),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                ),
                                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                child: Text(
                                  AppLocalization.of(context).getTranslatedValue("update_button"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 5 * SizeConfig.heightSizeMultiplier,),
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


  Future<List<Chamber>> _getChamberSuggestions(pattern) async {

    List<Chamber> list = List();

    for(int i=0; i<widget._parameter.chamberList.length; i++) {

      if(widget._parameter.chamberList[i].name.toLowerCase().startsWith(pattern.toString().toLowerCase())) {

        list.add(widget._parameter.chamberList[i]);
      }
    }

    return list;
  }

  Future<List<Patient>> _getPatientSuggestions(pattern) async {

    List<Patient> list = List();

    for(int i=0; i<widget._parameter.patientList.length; i++) {

      if(widget._parameter.patientList[i].name.toLowerCase().startsWith(pattern.toString().toLowerCase())) {

        list.add(widget._parameter.patientList[i]);
      }
    }

    return list;
  }


  _showDatePicker(BuildContext scaffoldContext) {

    var pickerFormat = DateFormat('yyyy-MM-dd');

    _currentDateTime = DateTime.now();
    String currentDate = pickerFormat.format(_currentDateTime);

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

                    _appointment.date = _formatter.format(selectedDateTime);

                    setState(() {
                      _dateController.text = _formatter.format(selectedDateTime);
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


  _showTimePicker(BuildContext scaffoldContext) {

    var pickerFormat = DateFormat.jm();

    _currentDateTime = DateTime.now();
    String currentTime = pickerFormat.format(_currentDateTime);

    String timeFormat = 'H:mm';

    try {

      showDialog(
          context: scaffoldContext,
          builder: (BuildContext context) {

            return Dialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,

              child: Container(
                height: 50 * SizeConfig.heightSizeMultiplier,
                child: TimePickerWidget(
                  initDateTime: DateTime.tryParse(currentTime),
                  dateFormat: timeFormat,
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

                    _appointment.time = pickerFormat.format(selectedDateTime);

                    setState(() {
                      _timeController.text = pickerFormat.format(selectedDateTime);
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
  void onEmpty(String message) {

    _myWidget.showToastMessage(message, 2000, ToastGravity.BOTTOM, Colors.black, 0.7, Colors.white, 1.0);
  }

  @override
  void onError(String message) {

    _myWidget.showToastMessage(message, 3000, ToastGravity.BOTTOM, Colors.white, 1.0, Colors.red.shade400, 1.0);
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
  void onUpdateFailure(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_update_appointment_info"),
        Colors.red, 3);
  }

  @override
  Future<void> onUpdateSuccess(BuildContext context) async {

    hideProgressDialog();
    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("appointment_successfully_updated"), Colors.green, 3);
  }

  Future<void> _clearInputFields() async {

    _chamberNameController.clear();
    _appointment.patientID = null;
    _patientController.clear();
    _patientNameController.clear();
    _mobileController.clear();
    _timeController.clear();
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
  Future<void> backToAppointmentPage() async {

    await _clearInputFields();

    try {
      _bounceStateKey1.currentState.animationController.dispose();
      _bounceStateKey2.currentState.animationController.dispose();
      _bounceStateKey3.currentState.animationController.dispose();
    }
    catch(error) {}

    DashboardRouteParameter _parameter = DashboardRouteParameter(pageNumber: 1, currentUser: widget._parameter.currentUser);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.DASHBOARD_ROUTE, arguments: _parameter);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}