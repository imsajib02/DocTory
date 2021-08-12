import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/presenter/set_new_password_presenter.dart';
import 'package:doctory/resources/images.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctory/contract/set_new_password_contract.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../route/route_manager.dart';

class SetNewPasswordPage extends StatefulWidget {

  final User _user;

  SetNewPasswordPage(this._user);

  @override
  _SetNewPasswordPageState createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  MyWidget _myWidget;

  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;
  IconData passwordToggle = Icons.visibility;
  IconData confirmPasswordToggle = Icons.visibility;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  BuildContext _scaffoldContext;

  final _bounceStateKey = GlobalKey<BounceState>();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _presenter = SetNewPasswordPresenter(this);
    _myWidget = MyWidget(context);

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

        try {
          _bounceStateKey.currentState.animationController.dispose();
        }
        catch(error) {}

        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(RouteManager.PASSWORD_RECOVER_ROUTE);

        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            _scaffoldContext = context;

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 7 * SizeConfig.heightSizeMultiplier, bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                    child: Text(AppLocalization.of(context).getTranslatedValue("set_new_password"),
                      style: Theme.of(context).textTheme.display3,
                    ),
                  ),

                  Flexible(
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
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: passwordVisibility,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(icon: Icon(passwordToggle),
                                      color: Colors.lightBlueAccent,
                                      onPressed: () {

                                        setState(() {
                                          passwordVisibility = !passwordVisibility;
                                          passwordVisibility ? passwordToggle = Icons.visibility : passwordToggle = Icons.visibility_off;
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
                                obscureText: confirmPasswordVisibility,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(icon: Icon(confirmPasswordToggle),
                                      color: Colors.lightBlueAccent,
                                      onPressed: () {

                                        setState(() {
                                          confirmPasswordVisibility = !confirmPasswordVisibility;
                                          confirmPasswordVisibility ? confirmPasswordToggle = Icons.visibility : confirmPasswordToggle = Icons.visibility_off;
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

                                    widget._user.password = _passwordController.text;
                                    widget._user.confirmPassword = _confirmPasswordController.text;

                                    _presenter.validateInput(context, widget._user);
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
                                      AppLocalization.of(context).getTranslatedValue("reset_password_button"),
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
                  ),
                ],
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
  void goToPasswordResetSuccessPage() {

    hideProgressDialog();

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.PASSWORD_RESET_SUCCESSFUL_ROUTE);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}