import 'package:doctory/contract/appointment_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/localization/localization_constrants.dart';
import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/create_appointment_route_parameter.dart';
import 'package:doctory/model/edit_appointment_route_parameter.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/presenter/appointment_page_presenter.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/local_memory.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {

  final User _currentUser;

  AppointmentPage(this._currentUser);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> implements View {

  List _chamberFilterList;
  List _timeFilterList;
  String _selectedChamber;

  Presenter _presenter;
  Widget _body;
  MyWidget _myWidget;

  bool _visibility;

  List<Appointment> _appointmentList;
  List<Appointment> _resultList;
  List<Chamber> _chamberList;
  List<Patient> _patientList;

  Locale _locale;
  LocalMemory _localMemory;

  bool _isSearched;
  FocusNode _focusNode;

  BuildContext _scaffoldContext;

  TextEditingController _searchController = TextEditingController();
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  @override
  void initState() {

    _myWidget = MyWidget(context);

    _localMemory = LocalMemory();

    _localMemory.getLanguageCode().then((locale) {
      _locale = locale;
    });

    _presenter = AppointmentPresenter(this);
    _body = Container();

    _focusNode = FocusNode();
    _isSearched = false;
    _visibility = false;

    _resultList = List();
    _appointmentList = List();

    _dateController1.text = "- - - -";
    _dateController2.text = "- - - -";

    super.initState();
  }


  @override
  void didChangeDependencies() {

    try {

      _chamberFilterList = [AppLocalization.of(context).getTranslatedValue("all_chamber_filter")];

      _timeFilterList = [AppLocalization.of(context).getTranslatedValue("today_filter"),
        AppLocalization.of(context).getTranslatedValue("yesterday_filter"),
        AppLocalization.of(context).getTranslatedValue("last_week_filter"),
        AppLocalization.of(context).getTranslatedValue("last_month_filter"),
        AppLocalization.of(context).getTranslatedValue("last_year_filter")];

      _selectedChamber = _chamberFilterList[0];

      _presenter.getAppointments(context, widget._currentUser.accessToken);
    }
    catch(error) {

      print(error);
    }

    super.didChangeDependencies();
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

                                        _presenter.onTextChanged(context, value, _selectedChamber, _appointmentList, _dateController1.text, _dateController2.text);
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
                                      _presenter.searchAppointment(context, pattern, _selectedChamber, _appointmentList, _dateController1.text, _dateController2.text);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                                            _presenter.filterDataChamberWise(context, pattern, _selectedChamber, _appointmentList, _isSearched, _dateController1.text, _dateController2.text);
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

                                      CreateAppointmentRouteParameter _parameter = CreateAppointmentRouteParameter(currentUser: widget._currentUser,
                                          appointmentList: _appointmentList, patientList: _patientList, chamberList: _chamberList);

                                      Navigator.pop(context);
                                      Navigator.of(context).pushNamed(RouteManager.CREATE_APPOINTMENT_ROUTE, arguments: _parameter);
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
                                _presenter.filterDataChamberWise(context, pattern, _selectedChamber, _appointmentList, _isSearched, _dateController1.text, _dateController2.text);
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
  void storeOriginalData(Appointments appointments, Chambers chambers, Patients patients) {

    _appointmentList = appointments.list;
    _chamberList = chambers.list;
    _patientList = patients.list;

    chambers.list.forEach((chamber) {

      _chamberFilterList.add(chamber.name);
    });

    Appointments toShow = Appointments(list: List());

    DateTime currentDateTime = DateTime.now();

    appointments.list.forEach((appointment) {

      DateTime date = DateFormat('MMMM d, yyyy').parse(appointment.date);

      final diff = DateTime(date.year, date.month, date.day).difference(DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day)).inDays;

      if(diff >= 0) {

        toShow.list.add(appointment);
      }
    });

    showAppointmentList(toShow);
  }

  @override
  void showAppointmentList(Appointments appointments) {

    _focusNode.unfocus();

    setState(() {

      _visibility = true;

      _body = Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

            Flexible(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier, bottom: 2 * SizeConfig.heightSizeMultiplier,
                        left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                    itemCount: appointments.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
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
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Padding(
                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                            child: Text(appointments.list[index].patientName,
                                              style: Theme.of(context).textTheme.title.copyWith(color: Colors.blue),
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                            child: Row(
                                              children: <Widget>[

                                                Icon(Icons.phone, size: 4.2 * SizeConfig.imageSizeMultiplier, color: Colors.black38,),

                                                SizedBox(width: 1.3 * SizeConfig.widthSizeMultiplier,),

                                                Text(appointments.list[index].patientMobile,
                                                  style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[

                                                Text(AppLocalization.of(context).getTranslatedValue("age_text") + (appointments.list[index].patient.age == null ?
                                                "" : appointments.list[index].patient.age),
                                                  style: Theme.of(context).textTheme.body1.copyWith(fontSize: 1.44 * SizeConfig.textSizeMultiplier),
                                                ),

                                                SizedBox(width: 5.128 * SizeConfig.widthSizeMultiplier,),

                                                Text(AppLocalization.of(context).getTranslatedValue("gender_text") + (appointments.list[index].patient.gender == null ?
                                                "" : appointments.list[index].patient.gender),
                                                  style: Theme.of(context).textTheme.body1.copyWith(fontSize: 1.44 * SizeConfig.textSizeMultiplier),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                            child: Text(AppLocalization.of(context).getTranslatedValue("chamber_text") + ": " + appointments.list[index].chamber.name,
                                              style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.green),
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[

                                                Flexible(
                                                  flex: 1,
                                                  child: Icon(Icons.location_on, size: 2.25 * SizeConfig.heightSizeMultiplier,
                                                    color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) :
                                                    Colors.black38,
                                                  ),
                                                ),

                                                SizedBox(width: 1.28 * SizeConfig.widthSizeMultiplier,),

                                                Flexible(
                                                  flex: 10,
                                                  child: Text(appointments.list[index].chamber.address,
                                                      style: Theme.of(context).textTheme.body1.copyWith(fontSize: 1.44 * SizeConfig.textSizeMultiplier)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier),
                                            child: Text(AppLocalization.of(context).getTranslatedValue("date_text") + appointments.list[index].date + "  -  " +
                                                appointments.list[index].time,
                                              style: Theme.of(context).textTheme.subhead,
                                            ),
                                          ),

                                          SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,)
                                        ],
                                      ),
                                    ),

                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[

                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {

                                                EditAppointmentRouteParameter _parameter = EditAppointmentRouteParameter(currentUser: widget._currentUser,
                                                    appointment: appointments.list[index], appointmentList: _appointmentList,
                                                    patientList: _patientList, chamberList: _chamberList);

                                                Navigator.pop(context);
                                                Navigator.of(context).pushNamed(RouteManager.EDIT_APPOINTMENT_ROUTE, arguments: _parameter);
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

                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {

                                                _showDeleteAlert(context, appointments.list[index]);
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


  void _showDeleteAlert(BuildContext scaffoldContext, Appointment appointment) {

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
              content: Text(_locale.languageCode == ENGLISH ? AppLocalization.of(context).getTranslatedValue("delete_appointment_text") + "\"" + appointment.patientName + "\"?" :
              "\"" + appointment.patientName + "\"" + AppLocalization.of(context).getTranslatedValue("delete_appointment_text"),
                maxLines: 2,
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
                    _presenter.deleteAppointment(scaffoldContext, appointment.id, widget._currentUser.accessToken);
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
  void showProgressDialog(String message) {

    _myWidget.showProgressDialog(message);
  }

  @override
  void hideProgressDialog() {

    _myWidget.hideProgressDialog();
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

                      _presenter.getAppointments(context, widget._currentUser.accessToken);
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
  void onDeleteFailed(BuildContext context) {

    hideProgressDialog();

    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_delete_appointment"),
        Colors.red, 3);
  }

  @override
  void onDeleteSuccess(BuildContext context, int appointmentID) {

    hideProgressDialog();

    for(int i=0; i<_appointmentList.length; i++) {

      if(_appointmentList[i].id == appointmentID) {

        _appointmentList.removeAt(i);
        break;
      }
    }

    String pattern = _searchController.text;
    _presenter.filterDataChamberWise(context, pattern, _selectedChamber, _appointmentList, _isSearched, _dateController1.text, _dateController2.text);

    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("successfully_deleted_appointment"),
        Colors.green, 3);
  }

  @override
  void showSearchedAndFilteredList(List<Appointment> resultList, bool isSearched) {

    _isSearched = isSearched;
    _resultList = resultList;

    Appointments appointments = Appointments(list: resultList);

    showAppointmentList(appointments);
  }

  @override
  void onSearchCleared(List<Appointment> appointmentList) {

    _isSearched = false;
    _resultList.clear();

    Appointments appointments = Appointments(list: appointmentList);

    showAppointmentList(appointments);
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
}