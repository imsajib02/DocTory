import 'package:doctory/contract/change_password_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/change_password_route_parameter.dart';
import 'package:doctory/model/dashboard_route_parameter.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/presenter/change_password_presenter.dart';
import 'package:doctory/resources/images.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../route/route_manager.dart';

class ChangePasswordPage extends StatefulWidget {

  final ChangePasswordRouteParameter _parameter;

  ChangePasswordPage(this._parameter);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  MyWidget _myWidget;

  bool _passwordVisibility = true;
  bool _oldPasswordVisibility = true;
  bool _confirmPasswordVisibility = true;

  IconData _passwordToggle = Icons.visibility;
  IconData _oldPasswordToggle = Icons.visibility;
  IconData _confirmPasswordToggle = Icons.visibility;

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  User _user;

  BuildContext _scaffoldContext;

  final _bounceStateKey = GlobalKey<BounceState>();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _presenter = ChangePasswordPresenter(this);
    _myWidget = MyWidget(context);
    _user = User();

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

        _onBackPressed();
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
          title: Text(AppLocalization.of(context).getTranslatedValue("change_password"),
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
                    margin: EdgeInsets.only(top: 3 * SizeConfig.heightSizeMultiplier, left: 12.82 * SizeConfig.widthSizeMultiplier,
                      right: 12.82 * SizeConfig.widthSizeMultiplier,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(height: 3.75 * SizeConfig.heightSizeMultiplier,),

                        Padding(
                          padding: EdgeInsets.only(bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                          child: SizedBox(
                            width: 22 * SizeConfig.widthSizeMultiplier,
                            height: 10 * SizeConfig.heightSizeMultiplier,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(Images.passwordLockImage2,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.75 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _oldPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: _oldPasswordVisibility,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(icon: Icon(_oldPasswordToggle),
                                color: Colors.lightBlueAccent,
                                onPressed: () {

                                  setState(() {
                                    _oldPasswordVisibility = !_oldPasswordVisibility;
                                    _oldPasswordVisibility ? _oldPasswordToggle = Icons.visibility : _oldPasswordToggle = Icons.visibility_off;
                                  });
                                }),
                            hintText: AppLocalization.of(context).getTranslatedValue("old_password_hint"),
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

                        TextField(
                          controller: _newPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: _passwordVisibility,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(icon: Icon(_passwordToggle),
                                color: Colors.lightBlueAccent,
                                onPressed: () {

                                  setState(() {
                                    _passwordVisibility = !_passwordVisibility;
                                    _passwordVisibility ? _passwordToggle = Icons.visibility : _passwordToggle = Icons.visibility_off;
                                  });
                                }),
                            hintText: AppLocalization.of(context).getTranslatedValue("new_password_hint"),
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

                        TextField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: _confirmPasswordVisibility,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(icon: Icon(_confirmPasswordToggle),
                                color: Colors.lightBlueAccent,
                                onPressed: () {

                                  setState(() {
                                    _confirmPasswordVisibility = !_confirmPasswordVisibility;
                                    _confirmPasswordVisibility ? _confirmPasswordToggle = Icons.visibility : _confirmPasswordToggle = Icons.visibility_off;
                                  });
                                }),
                            hintText: AppLocalization.of(context).getTranslatedValue("confirm_password_hint"),
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

                        SizedBox(height: 10 * SizeConfig.heightSizeMultiplier,),

                        BounceAnimation(
                          key: _bounceStateKey,
                          childWidget: RaisedButton(
                            padding: EdgeInsets.all(0),
                            elevation: 5,
                            onPressed: () {

                              _bounceStateKey.currentState.animationController.forward();
                              FocusScope.of(context).unfocus();

                              _user.oldPassword = _oldPasswordController.text;
                              _user.password = _newPasswordController.text;
                              _user.confirmPassword = _confirmPasswordController.text;

                              _presenter.validateInput(context, _user, widget._parameter.currentUser.accessToken);
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
                                AppLocalization.of(context).getTranslatedValue("change_button"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 6.25 * SizeConfig.heightSizeMultiplier,),
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
  void onChangeFailure(BuildContext context, String message) {

    hideProgressDialog();

    _myWidget.showSnackBar(context, message, Colors.red, 3);
  }

  @override
  void onChangeSuccess(BuildContext context) {

    _clearInputFields();

    hideProgressDialog();

    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("successfully_changed_password"),
        Colors.green, 3);
  }

  void _clearInputFields() {

    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
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

  void _onBackPressed() {

    _clearInputFields();

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    DashboardRouteParameter parameter = DashboardRouteParameter(pageNumber: widget._parameter.pageNumber, currentUser: widget._parameter.currentUser);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.DASHBOARD_ROUTE, arguments: parameter);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}