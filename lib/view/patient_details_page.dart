import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/patient_details_route_parameter.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';

class PatientDetails extends StatefulWidget {

  final PatientDetailsRouteParameter _parameter;

  PatientDetails(this._parameter);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {

  TextEditingController _historyController = TextEditingController();
  int _maxLine;

  @override
  void initState() {

    _historyController.text = widget._parameter.patient.history;
    _maxLine = (widget._parameter.patient.history.length / 40).round() + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 2,
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranslatedValue("patient_details_title"),
            style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            return SafeArea(
              child: ScrollConfiguration(
                behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(top: 5 * SizeConfig.heightSizeMultiplier, left: 10 * SizeConfig.widthSizeMultiplier,
                      right: 10 * SizeConfig.widthSizeMultiplier,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              children: <Widget>[

                                Text(AppLocalization.of(context).getTranslatedValue("patient_name"),
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Text(widget._parameter.patient.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              children: <Widget>[

                                Text(AppLocalization.of(context).getTranslatedValue("patient_age"),
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Text(widget._parameter.patient.age,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              children: <Widget>[

                                Text(AppLocalization.of(context).getTranslatedValue("patient_gender"),
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Text(widget._parameter.patient.gender,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              children: <Widget>[

                                Text(AppLocalization.of(context).getTranslatedValue("patient_phone"),
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Text(widget._parameter.patient.mobile,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.875 * SizeConfig.heightSizeMultiplier),
                            child: Row(
                              children: <Widget>[

                                Text(AppLocalization.of(context).getTranslatedValue("patient_address"),
                                  style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                                ),

                                SizedBox(width: 3 * SizeConfig.widthSizeMultiplier,),

                                Text(widget._parameter.patient.address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: Text(AppLocalization.of(context).getTranslatedValue("patient_history"),
                            style: Theme.of(context).textTheme.subtitle.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),

                        SizedBox(height: 2 * SizeConfig.heightSizeMultiplier,),

                        Flexible(
                          child: TextField(
                            controller: _historyController,
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

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.TOTAL_PATIENT_ROUTE, arguments: widget._parameter.currentUser);

    return Future(() => false);
  }
}