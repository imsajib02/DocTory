import 'package:doctory/contract/dash_board_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/view/appointments_page.dart';
import 'package:doctory/view/chamber_page.dart';
import 'package:doctory/view/home_page.dart';
import 'package:doctory/view/medicine_page.dart';
import 'package:doctory/view/prescription_page.dart';
import 'package:doctory/view/reports_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashBoardPresenter implements Presenter {

  View _view;
  DateTime currentBackPressTime;

  DashBoardPresenter(View view) {

    this._view = view;
  }

  @override
  void onTabSelected(BuildContext context, int index, User currentUser) {

    Widget appBarTitle;

    switch(index) {

        case 0:

          appBarTitle = Text(AppLocalization.of(context).getTranslatedValue("chamber_text"),
            style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
          );

          _view.showSelectedTab(index, ChamberPage(currentUser), appbarTitle: appBarTitle);
          break;

        case 1:

          appBarTitle = Text(AppLocalization.of(context).getTranslatedValue("appointment_text"),
            style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
          );

          _view.showSelectedTab(index, AppointmentPage(currentUser), appbarTitle: appBarTitle);
          break;

        case 2:

          appBarTitle = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(AppLocalization.of(context).getTranslatedValue("app_name1"),
                style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
              ),

              Text(AppLocalization.of(context).getTranslatedValue("app_name2"),
                style: Theme.of(context).textTheme.headline.copyWith(color: Colors.green),
              ),
            ],
          );

          _view.showSelectedTab(index, HomePage(currentUser), appbarTitle: appBarTitle);
          break;

        case 3:

          appBarTitle = Text(AppLocalization.of(context).getTranslatedValue("prescription_text"),
            style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
          );

          _view.showSelectedTab(index, PrescriptionPage(currentUser), appbarTitle: appBarTitle);
          break;

        case 4:

          appBarTitle = Text(AppLocalization.of(context).getTranslatedValue("reports_text"),
            style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
          );

          _view.showSelectedTab(index, ReportPage(currentUser), appbarTitle: appBarTitle);
          break;

        default:

          appBarTitle = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(AppLocalization.of(context).getTranslatedValue("app_name1"),
                style: Theme.of(context).textTheme.headline.copyWith(color: AppThemeNotifier().isDarkModeOn ? Colors.white : Colors.black,),
              ),

              Text(AppLocalization.of(context).getTranslatedValue("app_name2"),
                style: Theme.of(context).textTheme.headline.copyWith(color: Colors.green),
              ),
            ],
          );

          _view.showSelectedTab(index, HomePage(currentUser), appbarTitle: appBarTitle);
    }
  }

  @override
  Future<bool> onBackPress(int currentTab, User currentUser) {

    if(currentTab == 2) {

      DateTime now = DateTime.now();

      if(currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {

        currentBackPressTime = now;
        _view.showAlertOnExit();

        return Future.value(false);
      }

      SystemNavigator.pop();
      return Future.value(true);
    }

    _view.showSelectedTab(2, HomePage(currentUser));
    return Future.value(false);
  }
}