import 'package:doctory/contract/create_expense_contract.dart';
import 'package:doctory/model/chamber.dart';
import 'package:doctory/model/create_expense_route_model.dart';
import 'package:doctory/model/expense.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:doctory/presenter/create_expense_presenter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateExpensePage extends StatefulWidget {

  final CreateExpenseRouteParameter _parameter;

  CreateExpensePage(this._parameter);

  @override
  _CreateExpensePageState createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  MyWidget _myWidget;

  TextEditingController _chamberNameController = TextEditingController();
  TextEditingController _categoryNameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();

  Expense _expense;

  BuildContext _scaffoldContext;

  final _bounceStateKey1 = GlobalKey<BounceState>();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _presenter = CreateExpensePresenter(this, widget._parameter.expenseList);
    _myWidget = MyWidget(context);
    _expense = Expense();

    super.initState();
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
      onWillPop: () {

        backToExpensePage();
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: BackButton(
              color: Colors.white
          ),
          backgroundColor: Colors.deepOrangeAccent,
          brightness: Brightness.dark,
          elevation: 2,
          centerTitle: true,
          title: Text(AppLocalization.of(context).getTranslatedValue("create_a_new_expense"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Builder(
          builder: (BuildContext context) {

            _scaffoldContext = context;

            return SafeArea(
              child: ScrollConfiguration(
                behavior: new ScrollBehavior()..buildViewportChrome(context, null, AxisDirection.down),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(top: 4 * SizeConfig.heightSizeMultiplier, left: 8 * SizeConfig.widthSizeMultiplier,
                      right: 8 * SizeConfig.widthSizeMultiplier,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: _chamberNameController,
                              style: Theme.of(context).textTheme.subhead,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("choose_chamber_hint"),
                                hintStyle: Theme.of(context).textTheme.subhead,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                                fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                              )
                          ),
                          suggestionsCallback: (pattern) async {
                            return await _getChamberSuggestions(pattern);
                          },
                          itemBuilder: (BuildContext context, Chamber chamber) {
                            return ListTile(
                              title: Text(chamber.name, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal),
                              ),
                            );
                          },
                          onSuggestionSelected: (Chamber chamber) {

                            _chamberNameController.text = chamber.name;
                            _expense.chamberID = chamber.id;
                          },
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              autofocus: false,
                              controller: _categoryNameController,
                              style: Theme.of(context).textTheme.subhead,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: AppLocalization.of(context).getTranslatedValue("choose_expense_category"),
                                hintStyle: Theme.of(context).textTheme.subhead,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                                fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                              )
                          ),
                          suggestionsCallback: (pattern) async {
                            return await _getCategorySuggestions(pattern);
                          },
                          itemBuilder: (BuildContext context, ExpenseCategory category) {
                            return ListTile(
                              title: Text(category.name, overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.normal),
                              ),
                            );
                          },
                          onSuggestionSelected: (ExpenseCategory category) {

                            _categoryNameController.text = category.name;
                            _expense.categoryID = category.id;
                          },
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("enter_recipient_name"),
                            hintStyle: Theme.of(context).textTheme.subhead,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 0, style: BorderStyle.none,),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                            fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                          ),
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("enter_amount"),
                            hintStyle: Theme.of(context).textTheme.subhead,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 0, style: BorderStyle.none,),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                            fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                          ),
                        ),

                        SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,),

                        TextField(
                          controller: _detailsController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200),
                          ],
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("enter_details"),
                            hintStyle: Theme.of(context).textTheme.subhead,
                            helperText: AppLocalization.of(context).getTranslatedValue("details_max_limit"),
                            helperMaxLines: 2,
                            helperStyle: AppThemeNotifier().isDarkModeOn == false ? TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                            ) : TextStyle(
                              color: Colors.white.withOpacity(.4),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.5,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(width: 0, style: BorderStyle.none,),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(1.6875 * SizeConfig.heightSizeMultiplier),
                            fillColor: AppThemeNotifier().isDarkModeOn == false ? Colors.black12.withOpacity(.035) : Colors.white.withOpacity(.3),
                          ),
                        ),

                        SizedBox(height: 8 * SizeConfig.heightSizeMultiplier,),

                        Align(
                          alignment: Alignment.center,
                          child: BounceAnimation(
                            key: _bounceStateKey1,
                            childWidget: RaisedButton(
                              padding: EdgeInsets.all(0),
                              elevation: 5,
                              onPressed: () {

                                _bounceStateKey1.currentState.animationController.forward();
                                FocusScope.of(context).unfocus();

                                _expense.recipientName = _nameController.text;
                                _expense.amount = _amountController.text;
                                _expense.details = _detailsController.text;

                                _presenter.validateInput(context, widget._parameter.currentUser.accessToken, _expense);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                              textColor: Colors.white,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Colors.deepPurple,
                                        Color(0xFF9E1E1E),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                ),
                                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                child: Text(
                                  AppLocalization.of(context).getTranslatedValue("create_text"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 2.25 * SizeConfig.textSizeMultiplier,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 5 * SizeConfig.heightSizeMultiplier,),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Future<List<Chamber>> _getChamberSuggestions(pattern) async {

    List<Chamber> list = List();

    for(int i=0; i<widget._parameter.chamberList.length; i++) {

      if(widget._parameter.chamberList[i].name.toLowerCase().startsWith(pattern.toString().toLowerCase())) {

        list.add(widget._parameter.chamberList[i]);
      }
    }

    return list;
  }

  Future<List<ExpenseCategory>> _getCategorySuggestions(pattern) async {

    List<ExpenseCategory> list = List();

    for(int i=0; i<widget._parameter.categoryList.length; i++) {

      if(widget._parameter.categoryList[i].name.toLowerCase().startsWith(pattern.toString().toLowerCase())) {

        list.add(widget._parameter.categoryList[i]);
      }
    }

    return list;
  }

  @override
  void onEmpty(String message) {

    _myWidget.showToastMessage(message, 2000, ToastGravity.BOTTOM, Colors.black, 0.7, Colors.white, 1.0);
  }

  @override
  void onError(String message) {

    _myWidget.showToastMessage(message, 3000, ToastGravity.BOTTOM, Colors.white, 1.0, Colors.red.shade400, 1.0);
  }

  @override
  void showProgressDialog(String message) {

    _myWidget.showProgressDialog(message);
  }

  @override
  void hideProgressDialog() {

    _myWidget.hideProgressDialog();
  }

  @override
  void onEntryFailure(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_create_expense_text"),
        Colors.red, 3);
  }

  @override
  Future<void> onEntrySuccess(BuildContext context) async {

    await _clearInputFields();

    hideProgressDialog();

    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("expense_successfully_created_text"),
        Colors.green, 3);
  }

  Future<void> _clearInputFields() async {

    _chamberNameController.clear();
    _categoryNameController.clear();
    _nameController.clear();
    _amountController.clear();
    _detailsController.clear();
  }

  @override
  void onNoConnection() {

    hideProgressDialog();

    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("no_internet_available"), Colors.red, 3);
  }

  @override
  void onConnectionTimeOut() {

    hideProgressDialog();

    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("connection_time_out"), Colors.red, 3);
  }

  @override
  Future<void> backToExpensePage() async {

    await _clearInputFields();

    try {
      _bounceStateKey1.currentState.animationController.dispose();
    }
    catch(error) {}

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.TOTAL_EXPENSE_ROUTE, arguments: widget._parameter.currentUser);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}