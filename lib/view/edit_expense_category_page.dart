import 'package:doctory/contract/edit_expense_category_contract.dart';
import 'package:doctory/model/edit_expense_category_route_parameter.dart';
import 'package:doctory/model/expense_category.dart';
import 'package:doctory/presenter/edit_expense_category_presenter.dart';
import 'package:doctory/theme/apptheme_notifier.dart';
import 'package:doctory/utils/bounce_animation.dart';
import 'package:doctory/utils/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:doctory/utils/size_config.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/route/route_manager.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditExpenseCategoryPage extends StatefulWidget {

  final EditExpenseCategoryRouteParameter _parameter;

  EditExpenseCategoryPage(this._parameter);

  @override
  _EditExpenseCategoryPageState createState() => _EditExpenseCategoryPageState();
}

class _EditExpenseCategoryPageState extends State<EditExpenseCategoryPage> with WidgetsBindingObserver implements View {

  Presenter _presenter;
  MyWidget _myWidget;

  BuildContext _scaffoldContext;

  TextEditingController _nameController = TextEditingController();

  ExpenseCategory _category;
  final _bounceStateKey = GlobalKey<BounceState>();

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);

    _nameController.text = widget._parameter.category.name;

    _presenter = EditExpenseCategoryPresenter(this, widget._parameter.category, widget._parameter.categoryList);
    _myWidget = MyWidget(context);
    _category = ExpenseCategory();

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

        backToExpenseCategoryPage();
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
          title: Text(AppLocalization.of(context).getTranslatedValue("update_category_info"),
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

                        TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: AppLocalization.of(context).getTranslatedValue("category_name_hint"),
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

                        SizedBox(height: 12.5 * SizeConfig.heightSizeMultiplier,),

                        Align(
                          alignment: Alignment.center,
                          child: BounceAnimation(
                            key: _bounceStateKey,
                            childWidget: RaisedButton(
                              padding: EdgeInsets.all(0),
                              elevation: 5,
                              onPressed: () {

                                _bounceStateKey.currentState.animationController.forward();
                                FocusScope.of(context).unfocus();

                                _category.name = _nameController.text;

                                _presenter.validateInput(context, widget._parameter.currentUser.accessToken, _category);
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
                                  AppLocalization.of(context).getTranslatedValue("update_button"),
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
  void onUpdateFailure(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(context, AppLocalization.of(context).getTranslatedValue("failed_to_update_category_info"),
        Colors.red, 3);
  }

  @override
  void onUpdateSuccess(BuildContext context) {

    hideProgressDialog();
    _myWidget.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("category_info_updated"), Colors.green, 3);
  }

  Future<void> _clearInputFields() async {

    _nameController.clear();
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
  Future<void> backToExpenseCategoryPage() async {

    await _clearInputFields();

    try {
      _bounceStateKey.currentState.animationController.dispose();
    }
    catch(error) {}

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.EXPENSE_CATEGORY_ROUTE, arguments: widget._parameter.currentUser);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}