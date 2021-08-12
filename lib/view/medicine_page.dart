import 'package:doctory/contract/medicine_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/dashboard_route_parameter.dart';
import 'package:doctory/model/medicine.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/presenter/medicine_page_presenter.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:flutter/material.dart';

class MedicinePage extends StatefulWidget {

  final User _currentUser;

  MedicinePage(this._currentUser);

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  Widget _body;

  List<Medicine> _medicineList;
  List<Medicine> _tempMedicineList;

  bool _isSearched;
  FocusNode _focusNode;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _presenter = MedicinePresenter(this);
    _body = Container();

    _medicineList = List();
    _tempMedicineList = List();

    _focusNode = FocusNode();
    _isSearched = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {

    try {

      _presenter.loadMedicineList();
    }
    catch(error) {

      print(error);
    }

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.paused) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            return SafeArea(
              child: _body,
            );
          },
        ),
      ),
    );
  }


  @override
  void showProgressIndicator() {

    setState(() {
      _body = Container(child: Center(child: CircularProgressIndicator()));
    });
  }

  @override
  void showMedicineList(Medicines medicines, bool isSearchResult) {

    isSearchResult ? _medicineList = _tempMedicineList : _medicineList = medicines.list;

    setState(() {

      _body = Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              width: double.infinity,
              height: 5.5 * SizeConfig.heightSizeMultiplier,
              margin: EdgeInsets.only(left: 5 * SizeConfig.widthSizeMultiplier, right: 5 * SizeConfig.widthSizeMultiplier),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.deepOrangeAccent,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        keyboardType: TextInputType.text,
                        focusNode: _focusNode,
                        onChanged: (value) {

                          _presenter.onTextChanged(value, _isSearched);
                        },
                        decoration: InputDecoration(
                          hintText: AppLocalization.of(context).getTranslatedValue("search_by_name"),
                          hintStyle: Theme.of(context).textTheme.caption,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {

                        _focusNode.unfocus();

                        String pattern = _searchController.text;
                        _presenter.searchMedicine(context, pattern, _medicineList);
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          border: Border.all(
                            width: 2,
                            color: Colors.deepOrangeAccent,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
                        ),
                        child: Text(AppLocalization.of(context).getTranslatedValue("search_btn"),
                          style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

            Flexible(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier,
                        left: 2.56 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                    itemCount: medicines.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(1 * SizeConfig.heightSizeMultiplier),
                        child: Container(
                          child: Material(
                            elevation: 10,
                            color: Theme.of(context).primaryColor,
                            shadowColor: AppThemeNotifier().isDarkModeOn ? Colors.black12 : Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: <Widget>[

                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 1.5 * SizeConfig.widthSizeMultiplier),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(medicines.list[index].brandName,
                                                style: Theme.of(context).textTheme.title.copyWith(color: Colors.indigo),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(medicines.list[index].manufacturer,
                                                style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.grey[700]),
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: .625 * SizeConfig.heightSizeMultiplier),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("generic_text") + medicines.list[index].generic,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: .625 * SizeConfig.heightSizeMultiplier),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("dar_text") + medicines.list[index].dar,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: .625 * SizeConfig.heightSizeMultiplier),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("dosage_text") + medicines.list[index].dosage,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier,),
                                              child: Text(AppLocalization.of(context).getTranslatedValue("user_text") + medicines.list[index].user,
                                                style: Theme.of(context).textTheme.subhead,
                                              ),
                                            ),

                                            SizedBox(height: 1 * SizeConfig.heightSizeMultiplier,),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                      width: .5 * SizeConfig.widthSizeMultiplier,
                                      color: Colors.black45,
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 1.5 * SizeConfig.widthSizeMultiplier),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(medicines.list[index].strength,
                                                style: Theme.of(context).textTheme.subtitle,
                                              ),
                                            ),

                                            SizedBox(height: 3 * SizeConfig.widthSizeMultiplier,),

                                            Padding(
                                              padding: EdgeInsets.only(left: 2.05 * SizeConfig.widthSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                                              child: Text(medicines.list[index].price,
                                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void showFailedToLoadDataView() {

    setState(() {

      _body = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
              child: Text(AppLocalization.of(context).getTranslatedValue("could_not_load_data"),
                style: TextStyle(
                  color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) : Colors.black54,
                  fontSize: 2.8 * SizeConfig.textSizeMultiplier,
                ),
              ),
            ),
          ),

          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 3.75 * SizeConfig.heightSizeMultiplier),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppThemeNotifier().isDarkModeOn ? Colors.white.withOpacity(.5) : Colors.black26),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.all(5),
                  icon: Icon(
                    Icons.refresh,
                    size: 9 * SizeConfig.imageSizeMultiplier,
                    color: Colors.lightBlueAccent,
                  ),
                  onPressed: () {

                    _presenter.getMedicines(context, widget._currentUser.accessToken);
                  },
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void showSearchResult(List<Medicine> medicineList) {

    _isSearched = true;
    _tempMedicineList = _medicineList;

    Medicines medicines = Medicines(list: medicineList);
    showMedicineList(medicines, true);
  }

  @override
  void showAllMedicine() {

    _isSearched = false;

    Medicines medicines = Medicines(list: _tempMedicineList);
    showMedicineList(medicines, false);
  }

  Future<bool> _backPressed() {

    DashboardRouteParameter _parameter = DashboardRouteParameter(pageNumber: 2, currentUser: widget._currentUser);

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.DASHBOARD_ROUTE, arguments: _parameter);

    return Future(() => false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}