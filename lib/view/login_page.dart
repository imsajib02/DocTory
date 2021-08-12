import 'package:doctory/contract/login_page_contract.dart';
import 'package:doctory/model/dashboard_route_parameter.dart';
import 'package:doctory/model/profile_route_parameter.dart';
import 'package:doctory/model/registration_route_parameter.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/presenter/login_page_presenter.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  User _user;
  MyWidget _myWidget;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool passwordVisibility = true;
  IconData passwordToggle = Icons.visibility;

  final _bounceStateKey = GlobalKey<BounceState>();

  BuildContext _scaffoldContext;

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _presenter = LoginPresenter(this);
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
      onWillPop: _backPressed,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            _scaffoldContext = context;

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(top: 7.5 * SizeConfig.heightSizeMultiplier, left: 12.82 * SizeConfig.widthSizeMultiplier,
                      right: 12.82 * SizeConfig.widthSizeMultiplier, bottom: 4.5 * SizeConfig.heightSizeMultiplier),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Row(
                          children: <Widget>[

                            Text(AppLocalization.of(context).getTranslatedValue("app_name1"),
                              style: Theme.of(context).textTheme.display1,
                            ),

                            Text(AppLocalization.of(context).getTranslatedValue("app_name2"),
                              style: Theme.of(context).textTheme.display1.copyWith(color: Colors.green),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 3.75 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("log_in_to_your_account"),
                            style: Theme.of(context).textTheme.display3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: ScrollConfiguration(
                      behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Container(
                          margin: EdgeInsets.only(top: 4 * SizeConfig.heightSizeMultiplier, left: 12.82 * SizeConfig.widthSizeMultiplier,
                            right: 12.82 * SizeConfig.widthSizeMultiplier,),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: AppLocalization.of(context).getTranslatedValue("email_text"),
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
                                controller: _passwordController,
                                obscureText: passwordVisibility,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(icon: Icon(passwordToggle),
                                      color: Colors.lightBlueAccent,
                                      onPressed: () {

                                        setState(() {
                                          passwordVisibility = !passwordVisibility;
                                          passwordVisibility ? passwordToggle = Icons.visibility : passwordToggle = Icons.visibility_off;
                                        });
                                      }),
                                  hintText: AppLocalization.of(context).getTranslatedValue("password_text"),
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

                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(top: .625 * SizeConfig.heightSizeMultiplier,
                                      bottom: .625 * SizeConfig.heightSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier),
                                  child: GestureDetector(
                                    onTap: () async {

                                      await _clearInputFields();
                                      Navigator.of(context).pushNamed(RouteManager.PASSWORD_RECOVER_ROUTE);
                                    },
                                    child: Text(AppLocalization.of(context).getTranslatedValue("forgot_password"),
                                      style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 1.6875 * SizeConfig.textSizeMultiplier,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.5 * SizeConfig.heightSizeMultiplier,),

                              Align(
                                alignment: Alignment.center,
                                child: BounceAnimation(
                                  key: _bounceStateKey,
                                  childWidget: RaisedButton(
                                    padding: EdgeInsets.all(0),
                                    elevation: 5,
                                    onPressed: () {

                                      _bounceStateKey.currentState.animationController.forward();
                                      FocusScope.of(context).unfocus();

                                      _user.email = _emailController.text;
                                      _user.password = _passwordController.text;

                                      _presenter.validateLoginInput(context, _user);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    textColor: Colors.white,
                                    child: Container(
                                      width: 50 * SizeConfig.widthSizeMultiplier,
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
                                        AppLocalization.of(context).getTranslatedValue("login_button"),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),



                              Padding(
                                padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                    Text(AppLocalization.of(context).getTranslatedValue("need_account_text"),
                                      style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 1.8 * SizeConfig.textSizeMultiplier),
                                    ),

                                    SizedBox(width: 1.28 * SizeConfig.widthSizeMultiplier,),

                                    GestureDetector(
                                      onTap: () async {

                                        RegistrationRouteParameter routeParameter = RegistrationRouteParameter(isPhoneVerified: false, reEdit: false);

                                        await _clearInputFields();
                                        Navigator.of(context).pushNamed(RouteManager.REGISTRATION_ROUTE, arguments: routeParameter);
                                      },
                                      child: Text(AppLocalization.of(context).getTranslatedValue("create_account_text"),
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.lightBlueAccent,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 1.8 * SizeConfig.textSizeMultiplier,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 15 * SizeConfig.heightSizeMultiplier,),

                              Padding(
                                padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[

                                      Text(AppLocalization.of(context).getTranslatedValue("all_rights_reserved"),
                                        style: Theme.of(context).textTheme.caption,
                                      ),

                                      Text(AppLocalization.of(context).getTranslatedValue("b2gsoft_company_name"),
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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


  Future<bool> _backPressed() {

    SystemNavigator.pop();
    return Future(() => true);
  }

  @override
  void onEmpty(String message) {

    _myWidget.showToastMessage(message, 2000, ToastGravity.BOTTOM, Colors.black, 0.7, Colors.white, 1.0);
  }

  @override
  void onInvalidInput(String message) {

    _myWidget.showToastMessage(message, 3000, ToastGravity.BOTTOM, Colors.white, 1.0, Colors.red.shade400, 1.0);
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
  void updateProgressDialog(String message) {

    _myWidget.updateProgressDialog(message);
  }

  @override
  void hideProgressDialog() {

    _myWidget.hideProgressDialog();
  }

  @override
  Future<void> sendUserToHomePage(User loggedUser) async {

    await _clearInputFields();

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    DashboardRouteParameter _parameter = DashboardRouteParameter(pageNumber: 2, currentUser: loggedUser);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.DASHBOARD_ROUTE, arguments: _parameter);
  }

  @override
  Future<void> sendUserToProfilePage(User loggedUser) async {

    await _clearInputFields();

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    ProfileRouteParameter _parameter = ProfileRouteParameter(currentUser: loggedUser, isFirstOpen: true, pageNumber: 2);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.PROFILE_PAGE_ROUTE, arguments: _parameter);
  }

  Future<void> _clearInputFields() async {

    _emailController.clear();
    _passwordController.clear();
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
}