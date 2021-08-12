import 'dart:async';

import 'package:doctory/contract/phone_verification_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/model/phone_verification_route_parameter.dart';
import 'package:doctory/model/registration_route_parameter.dart';
import 'package:doctory/presenter/phone_verification_page_presenter.dart';
import 'package:doctory/resources/images.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PhoneVerificationPage extends StatefulWidget {

  final PhoneVerificationRouteParameter _routeParameter;

  PhoneVerificationPage(this._routeParameter);

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> with WidgetsBindingObserver implements View {

  int _timeOut;
  bool _allowed;
  bool _failedToRegister;

  Presenter _presenter;
  MyWidget _myWidget;

  String _resendText;
  Color _resendTextColor;

  RegistrationRouteParameter _routeParameter;

  final _bounceStateKey = GlobalKey<BounceState>();

  BuildContext _scaffoldContext;

  TextEditingController _pinCodeController = TextEditingController();
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _allowed = false;
    _failedToRegister = false;
    _myWidget = MyWidget(context);
    _routeParameter = RegistrationRouteParameter(isPhoneVerified: false, isRegistered: false);
    _presenter = PhoneVerificationPresenter(this);

    super.initState();
  }

  @override
  void didChangeDependencies() async {

    _timeOut = 30;
    _resendText = AppLocalization.of(context).getTranslatedValue("resend_code_in")+"$_timeOut";
    _resendTextColor = AppThemeNotifier().isDarkModeOn == false ? Colors.black : Colors.white;

    _presenter.startCountDown();

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

        return _presenter.onBackPressed(context, widget._routeParameter.isRecoveringPassword, widget._routeParameter.user, _routeParameter);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Builder(
            builder: (BuildContext context) {

              _scaffoldContext = context;

              return Container(
                height: double.infinity,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 7.5 * SizeConfig.heightSizeMultiplier,
                  left: 12.82 * SizeConfig.widthSizeMultiplier,
                  right: 12.82 * SizeConfig.widthSizeMultiplier,
                ),
                child: ScrollConfiguration(
                  behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: _failedToRegister == false ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 1.875 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                          child: SizedBox(
                            width: 30 * SizeConfig.widthSizeMultiplier,
                            height: 14.5 * SizeConfig.heightSizeMultiplier,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(Images.smsReceivedImage,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("verification_code_sent_text"),
                            style: Theme.of(context).textTheme.headline,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 3.75 * SizeConfig.heightSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("enter_code_sent_text"),
                            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 2.25 * SizeConfig.textSizeMultiplier, fontWeight: FontWeight.w500),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 2.25 * SizeConfig.heightSizeMultiplier, bottom: 2.25 * SizeConfig.heightSizeMultiplier,
                              left: 3.85 * SizeConfig.widthSizeMultiplier, right: 3.85 * SizeConfig.widthSizeMultiplier),
                          child: PinCodeTextField(
                            length: 6,
                            obsecureText: false,
                            animationType: AnimationType.fade,
                            autoDisposeControllers: false,
                            textInputType: TextInputType.number,
                            textStyle: Theme.of(context).textTheme.headline.copyWith(color: Colors.black),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.circle,
                              fieldHeight: 4.375 * SizeConfig.heightSizeMultiplier,
                              fieldWidth: 8.928 * SizeConfig.widthSizeMultiplier,
                              borderWidth: 0.5,
                              activeFillColor: Colors.white,
                              disabledColor: AppThemeNotifier().isDarkModeOn == false ? Colors.grey.withOpacity(.2) : Colors.white.withOpacity(.5),
                              activeColor: Colors.lightBlue,
                              inactiveColor: AppThemeNotifier().isDarkModeOn == false ? Colors.grey.withOpacity(.2) : Colors.white.withOpacity(.5),
                              inactiveFillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.grey.withOpacity(.2) : Colors.white.withOpacity(.5),
                              selectedColor: AppThemeNotifier().isDarkModeOn == false ? Colors.grey.withOpacity(.2) : Colors.white.withOpacity(.5),
                              selectedFillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.grey.withOpacity(.2) : Colors.white.withOpacity(.5),
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: Theme.of(context).primaryColor,
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: _pinCodeController,
                            onCompleted: (code) {

                              FocusScope.of(context).unfocus();
                              _presenter.verifyPhoneNumber(context, widget._routeParameter.isRecoveringPassword, widget._routeParameter.smsVerificationID, code, widget._routeParameter.user);
                            },
                            onChanged: (code) {

                            },
                            beforeTextPaste: (text) {

                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return false;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 3.75 * SizeConfig.heightSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("did_not_receive_code"),
                            style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 1.8 * SizeConfig.textSizeMultiplier),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {

                            _presenter.resendCode(context, widget._routeParameter.user, _allowed);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier, bottom: 6.25 * SizeConfig.heightSizeMultiplier),
                            child: Text(_resendText,
                              style: TextStyle(
                                color: _resendTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 1.8 * SizeConfig.textSizeMultiplier,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 1.875 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                          child: SizedBox(
                            width: 30 * SizeConfig.widthSizeMultiplier,
                            height: 14.5 * SizeConfig.heightSizeMultiplier,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(Images.smsReceivedImage,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("number_has_been_verified_text"),
                            style: Theme.of(context).textTheme.headline.copyWith(color: Colors.green),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 7.5 * SizeConfig.heightSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("but_failed_to_sign_up_text"),
                            style: Theme.of(context).textTheme.headline.copyWith(fontSize: 3.125 * SizeConfig.textSizeMultiplier, color: Colors.redAccent, fontWeight: FontWeight.w800),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 6.25 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                          child: Align(
                            alignment: Alignment.center,
                            child: BounceAnimation(
                              key: _bounceStateKey,
                              childWidget: RaisedButton(
                                padding: EdgeInsets.all(0),
                                elevation: 5,
                                onPressed: () {

                                  _bounceStateKey.currentState.animationController.forward();
                                  FocusScope.of(context).unfocus();

                                  _presenter.doRegistration(context, widget._routeParameter.user);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                textColor: Colors.white,
                                child: Container(
                                  width: 60 * SizeConfig.widthSizeMultiplier,
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
                                    AppLocalization.of(context).getTranslatedValue("continue_sign_up_button"),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  @override
  void onError(String message) {

    _myWidget.showToastMessage(message, 3000, ToastGravity.BOTTOM, Colors.white, 1.0, Colors.red.shade400, 1.0);
  }

  @override
  void onCodeResend() {

    _myWidget.showToastMessage(AppLocalization.of(context).getTranslatedValue("code_has_been_sent_again"),
        2000, ToastGravity.BOTTOM, Colors.black, 0.7, Colors.white, 1.0);
  }

  @override
  void showProgressDialog(String message) {

    _myWidget.showProgressDialog(message);
  }

  @override
  void updateProgressDialog(String message) {

    _myWidget.updateProgressDialog(message);
  }

  @override
  void hideProgressDialog() {

    _myWidget.hideProgressDialog();
  }

  @override
  void setRemainingTime(int remainingTime) {

    setState(() {

      _timeOut = remainingTime;
      _resendText = AppLocalization.of(context).getTranslatedValue("resend_code_in")+"$_timeOut";
    });
  }

  @override
  void allowResendingCode() {

    setState(() {

      _allowed = true;
      _resendText = AppLocalization.of(context).getTranslatedValue("resend_code_text");
      _resendTextColor = Colors.lightBlueAccent;
    });
  }

  @override
  void showRemainingTimeView() {

    setState(() {

      _timeOut = 30;
      _resendText = AppLocalization.of(context).getTranslatedValue("resend_code_in")+"$_timeOut";
      _resendTextColor = AppThemeNotifier().isDarkModeOn == false ? Colors.black : Colors.white;
    });
  }

  @override
  void showPinErrorAnimation() {

    try{
      errorController.add(ErrorAnimationType.shake);
    }
    catch(error) {
      print(error);
    }
  }

  @override
  void clearPinCodeFields() {

    setState(() {
      _pinCodeController.clear();
    });
  }

  @override
  Future<void> updateMainBody() async {

    await _presenter.stopCountDownTimer();

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Phone Verification", message: "Failed to register");

    setState(() {
        _failedToRegister = true;
      });
  }

  @override
  void setPhoneVerificationStatus(bool status) {

    _routeParameter.isPhoneVerified = status;
  }

  @override
  void setRegistrationStatus(bool status) {

    _routeParameter.isRegistered = status;
  }

  @override
  void showPhoneVerifiedAlert(BuildContext context) {

    showDialog(
        context: context,
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
              content: Text(AppLocalization.of(context).getTranslatedValue("phone_verified_alert_message"), textAlign: TextAlign.center,),
              contentTextStyle: TextStyle(
                color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,
                fontSize: 2.125 * SizeConfig.textSizeMultiplier,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier,
                  left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
              actions: <Widget>[

                FlatButton(
                  onPressed: () {

                    Navigator.of(context).pop();
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
                    onPressed: () async {

                      await _presenter.stopCountDownTimer();
                      Navigator.of(context).pop();

                      _routeParameter.reEdit = false;
                      _routeParameter.user = widget._routeParameter.user;

                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(RouteManager.REGISTRATION_ROUTE, arguments: _routeParameter);
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
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    errorController.close();
    super.dispose();
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
  void goToSetNewPasswordPage(User data) {

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.SET_NEW_PASSWORD_ROUTE, arguments: data);
  }

  @override
  Future<void> sendBackToRegistrationPage() async {

    await _presenter.stopCountDownTimer();

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    _routeParameter.reEdit = false;
    _routeParameter.user = widget._routeParameter.user;

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.REGISTRATION_ROUTE, arguments: _routeParameter);
  }

  @override
  void goToRegistrationSuccessPage() {

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.REGISTRATION_SUCCESSFUL_ROUTE);
  }
}