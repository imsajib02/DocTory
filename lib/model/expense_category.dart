class ExpenseCategory {

  int id;
  String name;

  ExpenseCategory({this.id, this.name});

  ExpenseCategory.fromJson(Map<String, dynamic> json) {

    id =  json['id'] == null ? 0 : json['id'];
    name =  json['name'] == null ? "" : json['name'];
  }

  toJson() {

    return {
      "name" : name == null ? "" : name,
    };
  }
}

class ExpenseCategories {

  List<ExpenseCategory> list;

  ExpenseCategories({this.list});

  ExpenseCategories.fromJson(Map<String, dynamic> json) {

    list = List();

    if(json['expense_category_list'] != null) {

      json['expense_category_list'].forEach((category) {

        list.add(ExpenseCategory.fromJson(category));
      });
    }
  }
}