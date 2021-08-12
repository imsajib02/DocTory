import 'package:doctory/contract/create_prescription_contract.dart';
import 'package:doctory/localization/localization_constrants.dart';
import 'package:doctory/model/appointment.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/create_appointment_route_parameter.dart';
import 'package:doctory/model/create_prescription_route_parameter.dart';
import 'package:doctory/model/dashboard_route_parameter.dart';
import 'package:doctory/model/income.dart';
import 'package:doctory/model/investigation.dart';
import 'package:doctory/model/medicine.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/prescription.dart';
import 'package:doctory/model/prescription_medicine.dart';
import 'package:doctory/presenter/create_appointmnet_presenter.dart';
import 'package:doctory/presenter/create_prescription_presenter.dart';
import 'package:doctory/utils/local_memory.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class CreatePrescriptionPage extends StatefulWidget {

  final CreatePrescriptionRouteParameter _parameter;

  CreatePrescriptionPage(this._parameter);

  @override
  _CreatePrescriptionPageState createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  MyWidget _myWidget;

  TextEditingController _visitingFeeController = TextEditingController();
  TextEditingController _chamberNameController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _historyController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _followUpDateController = TextEditingController();
  TextEditingController _investigationController = TextEditingController();
  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _dosageController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  List<String> _timeFilterList;

  Prescription _prescription;
  List<PrescriptionMedicine> _prescriptionMedicineList;
  List<Investigation> _selectedInvestigationList;
  Medicines _medicines;

  DateTime _currentDateTime;
  var _formatter;

  final _bounceStateKey1 = GlobalKey<BounceState>();
  final _bounceStateKey2 = GlobalKey<BounceState>();
  final _bounceStateKey3 = GlobalKey<BounceState>();
  final _bounceStateKey4 = GlobalKey<BounceState>();

  BuildContext _scaffoldContext;

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);
                                                       
    _presenter = CreatePrescriptionPresenter(this, widget._parameter.prescriptionList);
    _presenter.loadMedicineList();

    _myWidget = MyWidget(context);
    _prescription = Prescription();
    _prescription.income = Income();
    _medicines = Medicines();
    _prescriptionMedicineList = List();
    _selectedInvestigationList = List();

    _formatter = DateFormat.yMMMMd('en_US');
    _setCurrentDate();

    super.initState();
  }

  @override
  void didChangeDependencies() {

    _timeFilterList = [AppLocalization.of(context).getTranslatedValue("before_meal"),
      AppLocalization.of(context).getTranslatedValue("after_meal"),
      AppLocalization.of(context).getTranslatedValue("any_time")];

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

        backToPrescriptionPage();
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
          title: Text(AppLocalization.of(context).getTranslatedValue("create_prescription"),
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

                        Row(
                          children: <Widget>[

                            Flexible(
                              flex: 6,
                              child: TextField(
                                enabled: false,
                                controller: _followUpDateController,
                                style: Theme.of(context).textTheme.subhead,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context).getTranslatedValue("follow_up_date_hint"),
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

                        SizedBox(height: 3.2 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _visitingFeeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("visiting_fee_hint"),
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

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

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
                            _prescription.chamberID = chamber.id;
                          },
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: _patientNameController,
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

                            _patientNameController.text = patient.name;
                            _mobileController.text = patient.mobile;
                            _ageController.text = patient.age;
                            _addressController.text = patient.address;
                            _historyController.text = patient.history;
                            _prescription.patientID = patient.id;
                          },
                        ),

                        SizedBox(height: 3.2 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _mobileController,
                          enabled: false,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("patient_mobile_hint"),
                            hintStyle: Theme.of(context).textTheme.subhead,
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

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _ageController,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("patient_age_hint"),
                            hintStyle: Theme.of(context).textTheme.subhead,
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

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _addressController,
                          enabled: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("patient_address_hint"),
                            hintStyle: Theme.of(context).textTheme.subhead,
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

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: TextField(
                            controller: _historyController,
                            enabled: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: AppLocalization.of(context).getTranslatedValue("patient_history_hint"),
                              hintStyle: Theme.of(context).textTheme.subhead,
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
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              style: Theme.of(context).textTheme.subhead,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("investigation"),
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
                            return await _getInvestigationSuggestions(pattern);
                          },
                          itemBuilder: (BuildContext context, Investigation investigation) {
                            return ListTile(
                              title: Text(investigation.topic, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal),
                              ),
                            );
                          },
                          onSuggestionSelected: (Investigation investigation) {

                            setState(() {
                              _selectedInvestigationList.add(investigation);
                            });
                          },
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                            child: Wrap(
                              children: _selectedInvestigationList.map((item) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 3 * SizeConfig.widthSizeMultiplier, vertical: 1 * SizeConfig.heightSizeMultiplier),
                                margin: EdgeInsets.only(left: 1.28 * SizeConfig.widthSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier,
                                    bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[700], width: .512 * SizeConfig.widthSizeMultiplier),
                                    borderRadius: BorderRadius.all(Radius.circular(2.5 * SizeConfig.heightSizeMultiplier))
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Text(item.topic,
                                        style: Theme.of(context).textTheme.subtitle
                                    ),

                                    SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                    GestureDetector(
                                      onTap: () {
                                        _removeTopic(item);
                                      },
                                      child: Icon(Icons.cancel, color: Colors.red, size: 25,),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.5 * SizeConfig.heightSizeMultiplier,),

                        Align(
                          alignment: Alignment.centerRight,
                          child: BounceAnimation(
                            key: _bounceStateKey3,
                            childWidget: RaisedButton(
                              padding: EdgeInsets.all(0),
                              elevation: 5,
                              onPressed: () {

                                _addMedicine(context);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              textColor: Colors.white,
                              child: Container(
                                width: 30 * SizeConfig.widthSizeMultiplier,
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
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Text(
                                  AppLocalization.of(context).getTranslatedValue("add_medicine_btn"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 1.7 * SizeConfig.textSizeMultiplier,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 4.5 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: _prescriptionMedicineList.length,
                                itemBuilder: (BuildContext context, int index) {

                                  return GestureDetector(
                                    onTap: () {

                                      _addMedicine(context, prescriptionMedicine: _prescriptionMedicineList[index], position: index);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 1.5 * SizeConfig.heightSizeMultiplier),
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
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                                          child: Text(_prescriptionMedicineList[index].medicine.brandName,
                                                            style: Theme.of(context).textTheme.subtitle
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                                          child: Text(_prescriptionMedicineList[index].dosage,
                                                            style: Theme.of(context).textTheme.subhead,
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                                          child: Text(AppLocalization.of(context).getTranslatedValue("med_taking_time") + _prescriptionMedicineList[index].time,
                                                            style: Theme.of(context).textTheme.subhead
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                                                          child: Text(AppLocalization.of(context).getTranslatedValue("duration_text") + _prescriptionMedicineList[index].duration,
                                                            style: Theme.of(context).textTheme.subhead
                                                          ),
                                                        ),

                                                        Flexible(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                                            child: Text(AppLocalization.of(context).getTranslatedValue("note_text") + _prescriptionMedicineList[index].note,
                                                              style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {

                                                          setState(() {
                                                            _prescriptionMedicineList.removeAt(index);
                                                          });
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

                        SizedBox(height: 4.5 * SizeConfig.heightSizeMultiplier,),

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

                                _prescription.income.visitingFee = int.tryParse(_visitingFeeController.text);
                                _prescription.followUpDate = _followUpDateController.text;
                                _prescription.history = _historyController.text;
                                _prescription.investigations = _selectedInvestigationList;
                                _prescription.prescriptionMedicineList = _prescriptionMedicineList;

                                _presenter.validateInput(context, widget._parameter.currentUser.accessToken, _prescription);
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
                                  AppLocalization.of(context).getTranslatedValue("create_text"),
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

  Future<List<Medicine>> _getMedicineSuggestions(pattern) async {

    List<Medicine> list = List();

    for(int i=0; i<_medicines.list.length; i++) {

      if(_medicines.list[i].brandName.toLowerCase().startsWith(pattern.toString().toLowerCase())) {

        list.add(_medicines.list[i]);
      }
    }

    return list;
  }

  Future<List<Investigation>> _getInvestigationSuggestions(pattern) async {

    List<Investigation> list = List();

    for(int i=0; i<widget._parameter.investigationList.length; i++) {

      if(widget._parameter.investigationList[i].topic.toLowerCase().startsWith(pattern.toString().toLowerCase())) {

        list.add(widget._parameter.investigationList[i]);
      }
    }

    return list;
  }


  void _removeTopic(Investigation item) {

    for(int i=0; i<_selectedInvestigationList.length; i++) {

      if(_selectedInvestigationList[i].id == item.id) {

        setState(() {
          _selectedInvestigationList.removeAt(i);
        });

        break;
      }
    }
  }


  void _addMedicine(BuildContext scaffoldContext, {PrescriptionMedicine prescriptionMedicine, int position}) {

    _medicineNameController.clear();
    _dosageController.clear();
    _durationController.clear();
    _noteController.clear();

    String _selectedTime;

    PrescriptionMedicine _prescriptionMedicine;

    if(prescriptionMedicine != null) {

      _medicineNameController.text = prescriptionMedicine.medicine.brandName;
      _dosageController.text = prescriptionMedicine.dosage;
      _selectedTime = _timeFilterList[prescriptionMedicine.timeIndex];
      _durationController.text = prescriptionMedicine.duration;
      _noteController.text = prescriptionMedicine.note;

      _prescriptionMedicine = prescriptionMedicine;
    }
    else {

      _prescriptionMedicine = PrescriptionMedicine(isMedicineSelected: false, isTimeSelected: false);
    }

    showDialog(
        context: scaffoldContext,
        builder: (BuildContext context) {

          return Dialog(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {

                return Wrap(
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(height: 3 * SizeConfig.heightSizeMultiplier,),

                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                controller: _medicineNameController,
                                style: Theme.of(context).textTheme.subhead,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context).getTranslatedValue("select_medicine_text"),
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
                              return await _getMedicineSuggestions(pattern);
                            },
                            itemBuilder: (BuildContext context, Medicine medicine) {
                              return ListTile(
                                title: Text(medicine.brandName, overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal),
                                ),
                              );
                            },
                            onSuggestionSelected: (Medicine medicine) {

                              _medicineNameController.text = medicine.brandName;
                              _prescriptionMedicine.medicine = medicine;
                              _prescriptionMedicine.medicineID = medicine.id;
                              _prescriptionMedicine.isMedicineSelected = true;
                            },
                          ),

                          SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                          Flexible(
                            child: TextField(
                              controller: _dosageController,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("dosage_hint"),
                                hintStyle: Theme.of(context).textTheme.subhead,
                                helperText: AppLocalization.of(context).getTranslatedValue("dosage_helper"),
                                helperMaxLines: 1,
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
                          ),

                          SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                          Container(
                            padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                            height: 5 * SizeConfig.heightSizeMultiplier,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) : Colors.black26,
                                width: .3846 * SizeConfig.widthSizeMultiplier,
                              ),
                            ),
                            child: DropdownButton(
                                value: _selectedTime,
                                isExpanded: true,
                                isDense: true,
                                hint: Text(AppLocalization.of(context).getTranslatedValue("select_time_text_hint"),
                                ),
                                underline: SizedBox(),
                                items: _timeFilterList.map((value) {

                                  return DropdownMenuItem(child: Text(value), value: value);
                                }).toList(),
                                onChanged: (value) {

                                  setState(() {

                                    _selectedTime = value;
                                    _prescriptionMedicine.time = value;
                                    _prescriptionMedicine.timeIndex = _timeFilterList.indexOf(_selectedTime);
                                    _prescriptionMedicine.isTimeSelected = true;
                                  });
                                }
                            ),
                          ),

                          SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                          Flexible(
                            child: TextField(
                              controller: _durationController,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("duration_hint"),
                                hintStyle: Theme.of(context).textTheme.subhead,
                                helperText: AppLocalization.of(context).getTranslatedValue("duration_helper"),
                                helperMaxLines: 1,
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
                          ),

                          SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                          Flexible(
                            child: TextField(
                              controller: _noteController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100),
                              ],
                              maxLines: 4,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("note_hint"),
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

                          SizedBox(height: 3 * SizeConfig.heightSizeMultiplier,),

                          Align(
                            alignment: Alignment.center,
                            child: BounceAnimation(
                              key: _bounceStateKey4,
                              childWidget: RaisedButton(
                                padding: EdgeInsets.all(0),
                                elevation: 5,
                                onPressed: () {

                                  _bounceStateKey4.currentState.animationController.forward();
                                  FocusScope.of(context).unfocus();

                                  _prescriptionMedicine.dosage = _dosageController.text;
                                  _prescriptionMedicine.duration = _durationController.text;
                                  _prescriptionMedicine.note = _noteController.text;

                                  prescriptionMedicine == null ? _presenter.validateMedicineInput(scaffoldContext, _prescriptionMedicine, false)
                                  : _presenter.validateMedicineInput(scaffoldContext, _prescriptionMedicine, true, position: position);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                textColor: Colors.white,
                                child: Container(
                                  width: double.infinity,
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
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(prescriptionMedicine == null ? AppLocalization.of(context).getTranslatedValue("add_btn")
                                    : AppLocalization.of(context).getTranslatedValue("save_btn"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 1.8 * SizeConfig.textSizeMultiplier,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 3 * SizeConfig.heightSizeMultiplier,),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
    );
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

                    _prescription.followUpDate = _formatter.format(selectedDateTime);

                    setState(() {
                      _followUpDateController.text = _formatter.format(selectedDateTime);
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


  void _setCurrentDate() {

    _currentDateTime = DateTime.now();
    _dateController.text = _formatter.format(_currentDateTime);
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
  void onEntryFailure(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_create_prescription"),
        Colors.red, 3);
  }

  @override
  Future<void> onEntrySuccess(BuildContext context) async {

    await _clearInputFields();

    hideProgressDialog();

    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("successfully_created_prescription"),
        Colors.green, 3);
  }

  @override
  void setMedicineList(Medicines medicines) {

    _medicines = medicines;
  }

  @override
  void addMedicineToList(PrescriptionMedicine prescriptionMedicine) {

    try {
      _bounceStateKey4.currentState.animationController.dispose();
    }
    catch(error) {}

    setState(() {
      _prescriptionMedicineList.add(prescriptionMedicine);
    });

    Navigator.pop(context);
  }

  @override
  void updateMedicineInList(PrescriptionMedicine prescriptionMedicine, int position) {

    try {
      _bounceStateKey4.currentState.animationController.dispose();
    }
    catch(error) {}

    setState(() {
      _prescriptionMedicineList[position] = prescriptionMedicine;
    });

    Navigator.pop(context);
  }

  Future<void> _clearInputFields() async {

    _setCurrentDate();

    _followUpDateController.clear();
    _visitingFeeController.clear();
    _chamberNameController.clear();
    _patientNameController.clear();
    _mobileController.clear();
    _ageController.clear();
    _addressController.clear();
    _historyController.clear();
    _investigationController.clear();

    setState(() {
      _selectedInvestigationList.clear();
      _prescriptionMedicineList.clear();
    });
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
  Future<void> backToPrescriptionPage() async {

    await _clearInputFields();

    try {
      _bounceStateKey1.currentState.animationController.dispose();
      _bounceStateKey2.currentState.animationController.dispose();
      _bounceStateKey3.currentState.animationController.dispose();
      _bounceStateKey4.currentState.animationController.dispose();
    }
    catch(error) {}

    DashboardRouteParameter _parameter = DashboardRouteParameter(pageNumber: 3, currentUser: widget._parameter.currentUser);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.DASHBOARD_ROUTE, arguments: _parameter);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}