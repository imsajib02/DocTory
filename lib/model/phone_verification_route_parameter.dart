import 'package:doctory/model/user.dart';

class PhoneVerificationRouteParameter {

  String smsVerificationID;
  bool isRecoveringPassword;
  User user;

  PhoneVerificationRouteParameter(this.isRecoveringPassword, this.smsVerificationID, this.user);
}