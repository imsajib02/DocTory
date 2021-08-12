import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/resources/images.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';

class RegistrationSuccessfulPage extends StatefulWidget {

  @override
  _RegistrationSuccessfulPageState createState() => _RegistrationSuccessfulPageState();
}

class _RegistrationSuccessfulPageState extends State<RegistrationSuccessfulPage> {

  final _bounceStateKey = GlobalKey<BounceState>();

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

            return SafeArea(
              child: ScrollConfiguration(
                behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.75 * SizeConfig.heightSizeMultiplier, bottom: 6.25 * SizeConfig.heightSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("registration_complete_text"),
                            style: Theme.of(context).textTheme.display2.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                          child: SizedBox(
                            width: 25 * SizeConfig.widthSizeMultiplier,
                            height: 12.2 * SizeConfig.heightSizeMultiplier,
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(Images.doneImage,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5 * SizeConfig.heightSizeMultiplier, bottom: 6.25 * SizeConfig.heightSizeMultiplier,
                          left: 15 * SizeConfig.widthSizeMultiplier, right: 15 * SizeConfig.widthSizeMultiplier),
                          child: Text(AppLocalization.of(context).getTranslatedValue("you_can_login_to_your_account"),
                            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 2.2 * SizeConfig.textSizeMultiplier,
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                        child: Align(
                          alignment: Alignment.center,
                          child: BounceAnimation(
                            key: _bounceStateKey,
                            childWidget: RaisedButton(
                              padding: EdgeInsets.all(0),
                              elevation: 5,
                              onPressed: () {

                                _bounceStateKey.currentState.animationController.forward();

                                _goToLoginPage();
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              textColor: Colors.white,
                              child: Container(
                                width: 70 * SizeConfig.widthSizeMultiplier,
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
                                  AppLocalization.of(context).getTranslatedValue("go_back_to_login_button"),
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
    );
  }

  void _goToLoginPage() {

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.LOGIN_ROUTE);
  }
}