import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../localization/app_localization.dart';

class MyWidget {

  BuildContext _context;
  ProgressDialog _progressDialog;


  MyWidget(BuildContext context) {

    this._context = context;
    _progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
  }




  void showToastMessage(String message, int duration, ToastGravity gravity,
      Color textColor, double textOpacity, Color backgroundColor, double backgroundOpacity) {

    return FlutterToast(_context).showToast(
      toastDuration: Duration(milliseconds: duration),
      gravity: gravity,
      child: toastWidget(
        message: message,
        textColor: textColor,
        textOpacity: textOpacity,
        backgroundColor: backgroundColor,
        backgroundOpacity: backgroundOpacity,
      ),
    );
  }




  Widget toastWidget({String message, Color backgroundColor, Color textColor, double textOpacity, double backgroundOpacity}) {

    double defaultTextOpacity = 0.7;
    double defaultBackgroundOpacity = 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: backgroundColor.withOpacity(backgroundOpacity ?? defaultBackgroundOpacity),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // (horizontal, vertical)
            ),
          ]
      ),
      child: Text(message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor.withOpacity(textOpacity ?? defaultTextOpacity),
          fontSize: 13,
        ),
      ),
    );
  }




  void showProgressDialog(String message) {

    _progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Theme.of(_context).primaryColor,
      progressWidget: Padding(
        padding: const EdgeInsets.all(13.0),
        child: CircularProgressIndicator(),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      textAlign: TextAlign.center,
      messageTextStyle: Theme.of(_context).textTheme.subtitle,
    );

    _progressDialog.show();
  }




  void updateProgressDialog(String message) {

    _progressDialog.update(
      message: message,
    );
  }




  void hideProgressDialog() {

    _progressDialog.hide();
  }




  void showSnackBar(BuildContext context, String message, Color backgroundColor, int duration) {

    var snackbar = SnackBar(
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 1.8 * SizeConfig.textSizeMultiplier,
          color: Colors.white,
          fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
    );

    Scaffold.of(context).showSnackBar(snackbar);
  }
}