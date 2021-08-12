import 'package:doctory/model/medicine.dart';
import 'package:flutter/material.dart';

abstract class View {

  void showProgressIndicator();
  void showMedicineList(Medicines medicines, bool isSearchResult);
  void showFailedToLoadDataView();
  void showSearchResult(List<Medicine> medicineList);
  void showAllMedicine();
}

abstract class Presenter {

  void getMedicines(BuildContext context, String token);
  void searchMedicine(BuildContext context, String pattern, List<Medicine> medicineList);
  void onTextChanged(String value, bool isSearched);
  void loadMedicineList();
}