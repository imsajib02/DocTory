import 'package:doctory/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationRouteParameter {

  bool isPhoneVerified;
  bool reEdit;
  bool isRegistered;
  User user;

  RegistrationRouteParameter({this.isPhoneVerified, this.reEdit, this.user, this.isRegistered});
}