import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:intl/intl.dart';

class Expense {

  int id;
  String recipientName;
  String amount;
  String details;
  int categoryID;
  int chamberID;
  Chamber chamber;
  ExpenseCategory category;
  String createdAt;
  String originalDate;
  String updateTime;

  Expense({this.id, this.recipientName, this.amount, this.details, this.categoryID,
    this.chamberID, this.chamber, this.category, this.createdAt, this.updateTime});

  Expense.fromJson(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    recipientName =  json['name'] == null ? "" : json['name'];
    amount =  json['amount'] == null ? "" : json['amount'];
    details =  json['details'] == null ? "" : json['details'];
    chamber =  json['chamber'] == null ? Chamber() : Chamber.fromJson(json['chamber']);
    chamberID =  chamber.id == null ? 0 : chamber.id;
    category =  json['category'] == null ? ExpenseCategory() : ExpenseCategory.fromJson(json['category']);
    categoryID =  category.id == null ? 0 : category.id;
    createdAt =  json['created_at'] == null ? "" : json['created_at'];
    originalDate =  json['created_at'] == null ? "" : json['created_at'];

    DateTime expDate = DateFormat('d/M/yyyy').parse(createdAt.split("-").reversed.join("/"));
    createdAt = DateFormat('MMMM d, yyyy').format(expDate);

    updateTime =  json['updated_at'] == null ? "" : json['updated_at'];
  }

  Expense.fromCreate(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    recipientName =  json['name'] == null ? "" : json['name'];
    amount =  json['amount'] == null ? "" : json['amount'];
    details =  json['details'] == null ? "" : json['details'];
    category =  json['category'] == null ? ExpenseCategory() : ExpenseCategory.fromJson(json['category']);
    categoryID =  category.id == null ? 0 : category.id;
    chamber =  json['chamber'] == null ? Chamber() : Chamber.fromJson(json['chamber']);
    chamberID =  chamber.id == null ? 0 : chamber.id;
    updateTime =  json['updated_at'] == null ? "" : json['updated_at'];
  }

  toJson() {

    return {
      "name" : recipientName == null ? "" : recipientName,
      "amount" : amount == null ? "0" : amount,
      "details" : details == null ? "" : details,
      "chamber_id" : chamberID == null ? "0" : chamberID.toString(),
      "expense_category_id" : categoryID == null ? "0" : categoryID.toString(),
    };
  }
}

class Expenses {

  List<Expense> list;
  List<Chamber> chamberList;
  List<ExpenseCategory> categoryList;

  Expenses({this.list, this.chamberList});

  Expenses.fromJson(Map<String, dynamic> json) {

    list = List();
    chamberList = List();
    categoryList = List();

    if(json['expense_list'] != null) {

      json['expense_list'].forEach((expense) {

        list.add(Expense.fromJson(expense));
      });
    }

    if(json['expense_category_list'] != null) {

      json['expense_category_list'].forEach((category) {

        categoryList.add(ExpenseCategory.fromJson(category));
      });
    }

    if(json['chamber_list'] != null) {

      json['chamber_list'].forEach((chamber) {

        chamberList.add(Chamber.fromJson(chamber));
      });
    }
  }
}