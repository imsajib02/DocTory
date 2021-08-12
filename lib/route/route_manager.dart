import 'package:doctory/model/change_password_route_parameter.dart';
import 'package:doctory/model/create_appointment_route_parameter.dart';
import 'package:doctory/model/create_chamber_route_parameter.dart';
import 'package:doctory/model/create_expense_category_route_parameter.dart';
import 'package:doctory/model/create_expense_route_model.dart';
import 'package:doctory/model/create_patient_route_parameter.dart';
import 'package:doctory/model/create_prescription_route_parameter.dart';
import 'package:doctory/model/dashboard_route_parameter.dart';
import 'package:doctory/model/edit_appointment_route_parameter.dart';
import 'package:doctory/model/edit_chamber_route_parameter.dart';
import 'package:doctory/model/edit_expense_category_route_parameter.dart';
import 'package:doctory/model/edit_expense_route_parameter.dart';
import 'package:doctory/model/edit_patient_route_parameter.dart';
import 'package:doctory/model/edit_prescription_route_parameter.dart';
import 'package:doctory/model/expense_details_route_parameter.dart';
import 'package:doctory/model/income_details_route_parameter.dart';
import 'package:doctory/model/language_page_route_parameter.dart';
import 'package:doctory/model/patient_details_route_parameter.dart';
import 'package:doctory/model/phone_verification_route_parameter.dart';
import 'package:doctory/model/prescription_details_route_parameter.dart';
import 'package:doctory/model/profile_route_parameter.dart';
import 'package:doctory/model/registration_route_parameter.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/view/change_password_page.dart';
import 'package:doctory/view/create_appointment_page.dart';
import 'package:doctory/view/create_chamber_page.dart';
import 'package:doctory/view/create_expense_category_page.dart';
import 'package:doctory/view/create_expense_page.dart';
import 'package:doctory/view/create_patient_page.dart';
import 'package:doctory/view/create_prescription_page.dart';
import 'package:doctory/view/dashboard_page.dart';
import 'package:doctory/view/edit_appointment_page.dart';
import 'package:doctory/view/edit_chamber_page.dart';
import 'package:doctory/view/edit_expense.dart';
import 'package:doctory/view/edit_expense_category_page.dart';
import 'package:doctory/view/edit_patient_page.dart';
import 'package:doctory/view/edit_prescription_page.dart';
import 'package:doctory/view/expense_category_page.dart';
import 'package:doctory/view/expense_details_page.dart';
import 'package:doctory/view/expense_page.dart';
import 'package:doctory/view/income_details_page.dart';
import 'package:doctory/view/income_page.dart';
import 'package:doctory/view/language_page.dart';
import 'package:doctory/view/login_page.dart';
import 'package:doctory/view/medicine_page.dart';
import 'package:doctory/view/password_recovery_page.dart';
import 'package:doctory/view/password_reset_successful_page.dart';
import 'package:doctory/view/patient_details_page.dart';
import 'package:doctory/view/patient_page.dart';
import 'package:doctory/view/phone_verification_page.dart';
import 'package:doctory/view/prescription_details_page.dart';
import 'package:doctory/view/profile_page.dart';
import 'package:doctory/view/registration_page.dart';
import 'package:doctory/view/registration_successful_page.dart';
import 'package:doctory/view/report_details.dart';
import 'package:doctory/view/reports_page.dart';
import 'package:doctory/view/set_new_password_page.dart';
import 'package:doctory/view/splash_page.dart';
import 'package:flutter/material.dart';

class RouteManager {

  static const String DASHBOARD_ROUTE = "home";
  static const String LOGIN_ROUTE = "login";
  static const String REGISTRATION_ROUTE = "registration";
  static const String PHONE_VERIFICATION_ROUTE = "phoneVerification";
  static const String REGISTRATION_SUCCESSFUL_ROUTE = "registrationSuccess";
  static const String PASSWORD_RECOVER_ROUTE = "recoverPassword";
  static const String SET_NEW_PASSWORD_ROUTE = "setNewPassword";
  static const String PASSWORD_RESET_SUCCESSFUL_ROUTE = "passwordResetSuccessful";
  static const String TOTAL_PATIENT_ROUTE = "totalPatient";
  static const String PATIENT_DETAILS_ROUTE = "patientDetails";
  static const String CREATE_CHAMBER_ROUTE = "createChamber";
  static const String EDIT_CHAMBER_ROUTE = "editChamber";
  static const String CREATE_PATIENT_ROUTE = "createPatient";
  static const String EDIT_PATIENT_ROUTE = "editPatient";
  static const String CREATE_APPOINTMENT_ROUTE = "createAppointment";
  static const String EDIT_APPOINTMENT_ROUTE = "editAppointment";
  static const String TOTAL_INCOME_ROUTE = "totalIncome";
  static const String INCOME_DETAILS_ROUTE = "incomeDetails";
  static const String TOTAL_EXPENSE_ROUTE = "totalExpense";
  static const String CREATE_EXPENSE_ROUTE = "createExpense";
  static const String EDIT_EXPENSE_ROUTE = "editExpense";
  static const String EXPENSE_CATEGORY_ROUTE = "expenseCategory";
  static const String CREATE_EXPENSE_CATEGORY_ROUTE = "createExpenseCategory";
  static const String EDIT_EXPENSE_CATEGORY_ROUTE = "editExpenseCategory";
  static const String EXPENSE_DETAILS_ROUTE = "expenseDetails";
  static const String CREATE_PRESCRIPTION_ROUTE = "createPrescriptionCategory";
  static const String EDIT_PRESCRIPTION_ROUTE = "editPrescriptionCategory";
  static const String PRESCRIPTION_DETAILS_ROUTE = "prescriptionDetails";
  static const String PROFILE_PAGE_ROUTE = "profilePage";
  static const String CHANGE_PASSWORD_PAGE_ROUTE = "changePasswordPage";
  static const String LANGUAGE_PAGE_ROUTE = "languagePage";
  static const String SPLASH_PAGE_ROUTE = "splashPage";
  static const String REPORTS_PAGE_ROUTE = "reportsPage";
  static const String REPORT_DETAILS_PAGE_ROUTE = "reportDetailsPage";
  static const String MEDICINE_PAGE_ROUTE = "medicinePage";

  static Route<dynamic> generate(RouteSettings settings) {

    final args = settings.arguments;

    switch(settings.name) {

      case DASHBOARD_ROUTE:
        return MaterialPageRoute(builder: (_) => DashBoard(args as DashboardRouteParameter));

      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case REGISTRATION_ROUTE:
        return MaterialPageRoute(builder: (_) => RegistrationPage(args as RegistrationRouteParameter));

      case PHONE_VERIFICATION_ROUTE:
        return MaterialPageRoute(builder: (_) => PhoneVerificationPage(args as PhoneVerificationRouteParameter));

      case REGISTRATION_SUCCESSFUL_ROUTE:
        return MaterialPageRoute(builder: (_) => RegistrationSuccessfulPage());

      case PASSWORD_RECOVER_ROUTE:
        return MaterialPageRoute(builder: (_) => PasswordRecoverPage());

      case SET_NEW_PASSWORD_ROUTE:
        return MaterialPageRoute(builder: (_) => SetNewPasswordPage(args as User));

      case PASSWORD_RESET_SUCCESSFUL_ROUTE:
        return MaterialPageRoute(builder: (_) => PasswordResetSuccessfulPage());

      case TOTAL_PATIENT_ROUTE:
        return MaterialPageRoute(builder: (_) => PatientPage(args as User));

      case PATIENT_DETAILS_ROUTE:
        return MaterialPageRoute(builder: (_) => PatientDetails(args as PatientDetailsRouteParameter));

      case CREATE_CHAMBER_ROUTE:
        return MaterialPageRoute(builder: (_) => CreateChamberPage(args as CreateChamberRouteParameter));

      case EDIT_CHAMBER_ROUTE:
        return MaterialPageRoute(builder: (_) => EditChamberPage(args as EditChamberRouteParameter));

      case CREATE_PATIENT_ROUTE:
        return MaterialPageRoute(builder: (_) => CreatePatientPage(args as CreatePatientRouteParameter));

      case EDIT_PATIENT_ROUTE:
        return MaterialPageRoute(builder: (_) => EditPatientPage(args as EditPatientRouteParameter));

      case CREATE_APPOINTMENT_ROUTE:
        return MaterialPageRoute(builder: (_) => CreateAppointmentPage(args as CreateAppointmentRouteParameter));

      case EDIT_APPOINTMENT_ROUTE:
        return MaterialPageRoute(builder: (_) => EditAppointmentPage(args as EditAppointmentRouteParameter));

      case TOTAL_INCOME_ROUTE:
        return MaterialPageRoute(builder: (_) => IncomePage(args as User));

      case INCOME_DETAILS_ROUTE:
        return MaterialPageRoute(builder: (_) => IncomeDetails(args as IncomeDetailsRouteParameter));

      case TOTAL_EXPENSE_ROUTE:
        return MaterialPageRoute(builder: (_) => ExpensePage(args as User));

      case CREATE_EXPENSE_ROUTE:
        return MaterialPageRoute(builder: (_) => CreateExpensePage(args as CreateExpenseRouteParameter));

      case EDIT_EXPENSE_ROUTE:
        return MaterialPageRoute(builder: (_) => EditExpensePage(args as EditExpenseRouteParameter));

      case EXPENSE_CATEGORY_ROUTE:
        return MaterialPageRoute(builder: (_) => ExpenseCategoryPage(args as User));

      case CREATE_EXPENSE_CATEGORY_ROUTE:
        return MaterialPageRoute(builder: (_) => CreateExpenseCategoryPage(args as CreateExpenseCategoryRouteParameter));

      case EDIT_EXPENSE_CATEGORY_ROUTE:
        return MaterialPageRoute(builder: (_) => EditExpenseCategoryPage(args as EditExpenseCategoryRouteParameter));

      case EXPENSE_DETAILS_ROUTE:
        return MaterialPageRoute(builder: (_) => ExpenseDetails(args as ExpenseDetailsRouteParameter));

      case CREATE_PRESCRIPTION_ROUTE:
        return MaterialPageRoute(builder: (_) => CreatePrescriptionPage(args as CreatePrescriptionRouteParameter));

      case EDIT_PRESCRIPTION_ROUTE:
        return MaterialPageRoute(builder: (_) => EditPrescriptionPage(args as EditPrescriptionRouteParameter));

      case PROFILE_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => ProfilePage(args as ProfileRouteParameter));

      case CHANGE_PASSWORD_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => ChangePasswordPage(args as ChangePasswordRouteParameter));

      case LANGUAGE_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => LanguagePage(args as LanguagePageRouteParameter));

      case PRESCRIPTION_DETAILS_ROUTE:
        return MaterialPageRoute(builder: (_) => PrescriptionDetails(args as PrescriptionDetailsRouteParameter));

      case SPLASH_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case REPORTS_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => ReportPage(args as User));

      case REPORT_DETAILS_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => ReportDetailsPage(args as PatientDetailsRouteParameter));

      case MEDICINE_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => MedicinePage(args as User));

      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Center(child: Text("Route Error")))));
    }
  }
}