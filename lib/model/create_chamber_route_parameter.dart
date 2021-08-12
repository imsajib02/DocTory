import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/user.dart';

class CreateChamberRouteParameter {

  User currentUser;
  List<Chamber> chamberList;

  CreateChamberRouteParameter({this.currentUser, this.chamberList});
}