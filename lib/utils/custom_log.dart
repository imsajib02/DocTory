import 'package:flutter/foundation.dart';
import 'package:doctory/utils/custom_trace.dart';

class CustomLogger {

  static CustomTrace programInfo;

  CustomLogger._();


  static debug({@required CustomTrace trace, @required String tag, @required dynamic message}) {

    try {

      programInfo = trace;

      print("\n<----------  DEBUG  ---------->\n\n");
      print("|  FileName: ${programInfo.fileName}  |  FunctionName: ${programInfo.functionName}  |  Line: ${programInfo.lineNumber}  |");
      print("\n<<<<<  ${tag}  >>>>>  ${message}");
      print("\n<----------------------------->\n\n");
    }
    catch(error) {

    }
  }



  static error({@required CustomTrace trace, @required String tag, @required dynamic message}) {

    try {

      programInfo = trace;

      print("\n<----------  ERROR  ---------->\n\n");
      print("|  FileName: ${programInfo.fileName}  |  FunctionName: ${programInfo.functionName}  |  Line: ${programInfo.lineNumber}  |");
      print("\n<<<<<  ${tag}  >>>>>  ${message}");
      print("\n<----------------------------->\n\n");
    }
    catch(error) {

    }
  }



  static info({@required CustomTrace trace, @required String tag, @required dynamic message}) {

    try {

      programInfo = trace;

      print("\n<----------  INFO  ---------->\n\n");
      print("|  FileName: ${programInfo.fileName}  |  FunctionName: ${programInfo.functionName}  |  Line: ${programInfo.lineNumber}  |");
      print("\n<<<<<  ${tag}  >>>>>  ${message}");
      print("\n<---------------------------->\n\n");
    }
    catch(error) {

    }
  }



  static warning({@required CustomTrace trace, @required String tag, @required dynamic message}) {

    try {

      programInfo = trace;

      print("\n<----------  WARNING  ---------->\n\n");
      print("|  FileName: ${programInfo.fileName}  |  FunctionName: ${programInfo.functionName}  |  Line: ${programInfo.lineNumber}  |");
      print("\n<<<<<  ${tag}  >>>>>  ${message}");
      print("\n<------------------------------->\n\n");
    }
    catch(error) {

    }
  }
}