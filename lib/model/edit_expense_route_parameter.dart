import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/expense.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:doctory/model/patient.dart';
import 'package:doctory/model/user.dart';

class EditExpenseRouteParameter {

  User currentUser;
  Expense expense;
  List<Chamber> chamberList;
  List<ExpenseCategory> categoryList;

  EditExpenseRouteParameter({this.currentUser, this.expense, this.chamberList, this.categoryList});
}