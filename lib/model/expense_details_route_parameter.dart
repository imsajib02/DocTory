import 'package:doctory/model/expense.dart';
import 'package:doctory/model/user.dart';

class ExpenseDetailsRouteParameter {

  User currentUser;
  Expense expense;

  ExpenseDetailsRouteParameter({this.currentUser, this.expense});
}