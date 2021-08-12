import 'package:doctory/model/app_details.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../contract/splash_page_contract.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

import '../model/user.dart';
import '../resources/strings.dart';
import '../utils/custom_log.dart';
import '../utils/custom_trace.dart';
import '../utils/local_memory.dart';
import '../utils/connection_check.dart';

class SplashPagePresenter implements Presenter {

  View _view;
  DatabaseReference _appDetailsReference;
  PackageInfo _packageInfo;
  LocalMemory _localMemory;
  bool _timeOut;

  SplashPagePresenter(View view) {

    this._view = view;
    _timeOut = false;
    _localMemory = LocalMemory();
    _appDetailsReference = FirebaseDatabase.instance.reference().child(Strings.firebaseAppDetailsPath);
  }

  @override
  void getAppDetails(BuildContext context, bool isRetrying) {

    if(isRetrying) {

      _view.showSplashView();
    }

    checkInternetConnection().then((isConnected) {

      _timeOut = false;

      if(isConnected) {

        _appDetailsReference.once().then((DataSnapshot snapshot) async {

          if(!_timeOut) {

            if(snapshot != null) {

              CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Splash Screen Response", message: snapshot.value.toString());

              AppDetails appDetails = AppDetails.fromFirebase(snapshot.value);

              _packageInfo = await PackageInfo.fromPlatform();

              if(int.tryParse(appDetails.generalAppVersion.replaceAll(".", "")) > int.tryParse(_packageInfo.version.replaceAll(".", ""))) {

                CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "App Update", message: "General update available");

                if(Platform.isAndroid) {

                  if(appDetails.forceUpdate) {

                    _view.showForceUpdateView(context, appDetails.androidAppLink);
                  }
                  else {

                    _view.showOptionalUpdateView(context, appDetails.androidAppLink);
                  }
                }
                else if(Platform.isIOS) {

                  if(appDetails.forceUpdate) {

                    _view.showForceUpdateView(context, appDetails.iosAppLink);
                  }
                  else {

                    _view.showOptionalUpdateView(context, appDetails.iosAppLink);
                  }
                }
              }
              else {

                if(Platform.isAndroid) {

                  if(int.tryParse(appDetails.androidAppVersion.replaceAll(".", "")) > int.tryParse(_packageInfo.version.replaceAll(".", ""))) {

                    CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "App Update", message: "Android app update available");

                    if(appDetails.forceUpdate) {

                      _view.showForceUpdateView(context, appDetails.androidAppLink);
                    }
                    else {

                      _view.showOptionalUpdateView(context, appDetails.androidAppLink);
                    }
                  }
                  else {

                    _isUserLoggedIn();
                  }
                }
                else if(Platform.isIOS) {

                  if(int.tryParse(appDetails.iosAppVersion.replaceAll(".", "")) > int.tryParse(_packageInfo.version.replaceAll(".", ""))) {

                    CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "App Update", message: "iOS app update available");

                    if(appDetails.forceUpdate) {

                      _view.showForceUpdateView(context, appDetails.iosAppLink);
                    }
                    else {

                      _view.showOptionalUpdateView(context, appDetails.iosAppLink);
                    }
                  }
                  else {

                    _isUserLoggedIn();
                  }
                }
              }
            }
          }

        }).catchError((error) {

          CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "App Details", message: "Failed to get app details from firebase");

          print(error);

          _view.showErrorView();

        }).timeout(Duration(seconds: 10), onTimeout: () {

          _timeOut = true;

          _view.showTimeOutView();
        });
      }
      else {

        _view.showNoInternetView();
      }
    });
  }

  Future<void> _isUserLoggedIn() async {

    User user = await _localMemory.getUser();

    if(user.auth == true && user.accessToken != null) {

      CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Current User", message: "Email: " +user.email);

      _view.sendUserToDashboard(user);
    }
    else {

      _view.goToLoginPage();
    }
  }
}