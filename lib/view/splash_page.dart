import 'package:doctory/presenter/splash_page_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../contract/splash_page_contract.dart';
import '../localization/app_localization.dart';
import '../model/dashboard_route_parameter.dart';
import '../model/user.dart';
import '../resources/images.dart';
import '../route/route_manager.dart';
import '../theme/apptheme_notifier.dart';
import '../utils/custom_log.dart';
import '../utils/custom_trace.dart';
import '../utils/size_config.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> implements View {

  Presenter _presenter;

  int _currentIndex;

  @override
  void initState() {

    _presenter = SplashPagePresenter(this);

    _currentIndex = 0;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    try {

      _presenter.getAppDetails(context, false);
    }
    catch(error) {}

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {

        SystemNavigator.pop();
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            return Container(
              height: double.infinity,
              width: double.infinity,
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 12.5 * SizeConfig.heightSizeMultiplier,
                            width: 25.64 * SizeConfig.widthSizeMultiplier,
                            alignment: Alignment.center,
                            child: Image.asset(Images.appIcon),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 8.75 * SizeConfig.heightSizeMultiplier,
                            width: 20.5 * SizeConfig.widthSizeMultiplier,
                            alignment: Alignment.topCenter,
                            child: Image.asset(Images.splashLoadingGif),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 12.5 * SizeConfig.heightSizeMultiplier,
                            width: 25.64 * SizeConfig.widthSizeMultiplier,
                            alignment: Alignment.center,
                            child: Image.asset(Images.appIcon),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                alignment: Alignment.center,
                                child: Text(AppLocalization.of(context).getTranslatedValue("please_turn_on_internet"),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display2.copyWith(color: Colors.red),
                                ),
                              ),

                              SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                              GestureDetector(
                                onTap: () {

                                  _presenter.getAppDetails(context, true);
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 30.76 * SizeConfig.widthSizeMultiplier,
                                    maxWidth: 76.92 * SizeConfig.widthSizeMultiplier,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                    padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.grey.withOpacity(.5),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(3.125 * SizeConfig.heightSizeMultiplier),
                                    ),
                                    child: Text(AppLocalization.of(context).getTranslatedValue("retry"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.blueAccent),
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

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 12.5 * SizeConfig.heightSizeMultiplier,
                            width: 25.64 * SizeConfig.widthSizeMultiplier,
                            alignment: Alignment.center,
                            child: Image.asset(Images.appIcon),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                alignment: Alignment.center,
                                child: Text(AppLocalization.of(context).getTranslatedValue("no_internet_available"),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display2.copyWith(color: Colors.red),
                                ),
                              ),

                              SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                              GestureDetector(
                                onTap: () {

                                  _presenter.getAppDetails(context, true);
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 30.76 * SizeConfig.widthSizeMultiplier,
                                    maxWidth: 76.92 * SizeConfig.widthSizeMultiplier,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                    padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.grey.withOpacity(.5),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(3.125 * SizeConfig.heightSizeMultiplier),
                                    ),
                                    child: Text(AppLocalization.of(context).getTranslatedValue("retry"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.blueAccent),
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

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 12.5 * SizeConfig.heightSizeMultiplier,
                            width: 25.64 * SizeConfig.widthSizeMultiplier,
                            alignment: Alignment.center,
                            child: Image.asset(Images.appIcon),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                alignment: Alignment.center,
                                child: Text(AppLocalization.of(context).getTranslatedValue("some_error_occurred"),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display2.copyWith(color: Colors.red),
                                ),
                              ),

                              SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                              GestureDetector(
                                onTap: () {

                                  _presenter.getAppDetails(context, true);
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 30.76 * SizeConfig.widthSizeMultiplier,
                                    maxWidth: 76.92 * SizeConfig.widthSizeMultiplier,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                    padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.grey.withOpacity(.5),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(3.125 * SizeConfig.heightSizeMultiplier),
                                    ),
                                    child: Text(AppLocalization.of(context).getTranslatedValue("retry"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.blueAccent),
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

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 12.5 * SizeConfig.heightSizeMultiplier,
                            width: 25.64 * SizeConfig.widthSizeMultiplier,
                            alignment: Alignment.center,
                            child: Image.asset(Images.appIcon),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                alignment: Alignment.center,
                                child: Text(AppLocalization.of(context).getTranslatedValue("connection_time_out"),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display2.copyWith(color: Colors.red),
                                ),
                              ),

                              SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                              GestureDetector(
                                onTap: () {

                                  _presenter.getAppDetails(context, true);
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 30.76 * SizeConfig.widthSizeMultiplier,
                                    maxWidth: 76.92 * SizeConfig.widthSizeMultiplier,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12.82 * SizeConfig.widthSizeMultiplier, right: 12.82 * SizeConfig.widthSizeMultiplier),
                                    padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.grey.withOpacity(.5),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(3.125 * SizeConfig.heightSizeMultiplier),
                                    ),
                                    child: Text(AppLocalization.of(context).getTranslatedValue("retry"),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.blueAccent),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void showSplashView() {

    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  void showTimeOutView() {

    setState(() {
      _currentIndex = 4;
    });
  }

  @override
  void showNoInternetView() {

    setState(() {
      _currentIndex = 2;
    });
  }

  @override
  void showTurnOnConnectionView() {

    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  void showErrorView() {

    setState(() {
      _currentIndex = 3;
    });
  }

  @override
  void showForceUpdateView(BuildContext context, String appLink) {

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
              title: Text(AppLocalization.of(context).getTranslatedValue("Update_title"), textAlign: TextAlign.center,),
              titlePadding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier,
                  left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
              titleTextStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 2.5 * SizeConfig.textSizeMultiplier,
                fontWeight: FontWeight.bold,
              ),
              content: Text(AppLocalization.of(context).getTranslatedValue("force_update_message"),
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

                Padding(
                  padding: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
                  child: FlatButton(
                    onPressed: () {

                      Navigator.of(context).pop();
                      _launchURL(appLink);
                    },
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    child: Text(AppLocalization.of(context).getTranslatedValue("ok_message"), style: TextStyle(

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
  void showOptionalUpdateView(BuildContext context, String appLink) {

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
              title: Text(AppLocalization.of(context).getTranslatedValue("Update_title"), textAlign: TextAlign.center,),
              titlePadding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier,
                  left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
              titleTextStyle: TextStyle(
                color: Colors.redAccent,
                fontSize: 2.5 * SizeConfig.textSizeMultiplier,
                fontWeight: FontWeight.bold,
              ),
              content: Text(AppLocalization.of(context).getTranslatedValue("optional_update_message"),
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
                    _launchURL(appLink);
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
                      goToLoginPage();
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

  Future<void> _launchURL(String url) async {

    if(await canLaunch(url)) {

      CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Launching URL", message: url);
      await launch(url);

      //SystemNavigator.pop();
    }
    else {

      CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Failed To Launch URL", message: url);
      throw 'Could not launch $url';
    }
  }

  @override
  void goToLoginPage() {

    //Navigator.pop(context);
    Navigator.of(context).pushReplacementNamed(RouteManager.LOGIN_ROUTE);
  }

  @override
  void sendUserToDashboard(User loggedUser) {

    DashboardRouteParameter parameter = DashboardRouteParameter(currentUser: loggedUser, pageNumber: 2);

    //Navigator.pop(context);
    Navigator.of(context).pushReplacementNamed(RouteManager.DASHBOARD_ROUTE, arguments: parameter);
  }
}