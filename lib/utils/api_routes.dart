class APIRoute {

  static const String BASE_URL = "BASE_URL";
  static const String API_URL = "BASE_URL/api/";

  static const String LOGIN_URL = API_URL + "login";
  static const String REGISTRATION_URL = API_URL + "register";
  static const String EMAIL_PHONE_DUPLICATE_CHECK_URL = API_URL + "otp/verify";
  static const String EMAIL_VERIFY_URL = API_URL + "email/verify";
  static const String PASSWORD_RESET_URL = API_URL + "password/change";
  static const String PASSWORD_CHANGE_URL = API_URL + "password/update";
  static const String DASHBOARD_URL = API_URL + "dashboard";
  static const String DASHBOARD_FILTER_URL = API_URL + "dashboard/filter/";
  static const String CHAMBER_LIST_URL = API_URL + "dashboard/chambers/list";
  static const String AUTHENTICATED_MEDICINE_LIST_URL = API_URL + "dashboard/medicines/list";
  static const String OPEN_MEDICINE_LIST_URL = API_URL + "medicines/list";
  static const String APPOINTMENT_LIST_URL = API_URL + "dashboard/appointments/list";
  static const String PATIENT_LIST_URL = API_URL + "dashboard/patients/list";
  static const String CREATE_CHAMBER_URL = API_URL + "dashboard/chambers/store";
  static const String UPDATE_CHAMBER_URL = API_URL + "dashboard/chambers/update/";
  static const String DELETE_CHAMBER_URL = API_URL + "dashboard/chambers/delete/";
  static const String CREATE_PATIENT_URL = API_URL + "dashboard/patients/store";
  static const String UPDATE_PATIENT_URL = API_URL + "dashboard/patients/update/";
  static const String DELETE_PATIENT_URL = API_URL + "dashboard/patients/delete/";
  static const String CREATE_APPOINTMENT_URL = API_URL + "dashboard/appointments/store";
  static const String UPDATE_APPOINTMENT_URL = API_URL + "dashboard/appointments/update/";
  static const String DELETE_APPOINTMENT_URL = API_URL + "dashboard/appointments/delete/";
  static const String INCOME_LIST_URL = API_URL + "dashboard/incomes/list";
  static const String EXPENSE_LIST_URL = API_URL + "dashboard/expenses/list";
  static const String CREATE_EXPENSE_URL = API_URL + "dashboard/expenses/store";
  static const String UPDATE_EXPENSE_URL = API_URL + "dashboard/expenses/update/";
  static const String DELETE_EXPENSE_URL = API_URL + "dashboard/expenses/delete/";
  static const String EXPENSE_CATEGORY_LIST_URL = API_URL + "dashboard/expense-categories/list";
  static const String CREATE_EXPENSE_CATEGORY_URL = API_URL + "dashboard/expense-categories/store";
  static const String UPDATE_EXPENSE_CATEGORY_URL = API_URL + "dashboard/expense-categories/update/";
  static const String DELETE_EXPENSE_CATEGORY_URL = API_URL + "dashboard/expense-categories/delete/";
  static const String PRESCRIPTION_LIST_URL = API_URL + "dashboard/prescriptions/list";
  static const String CREATE_PRESCRIPTION_URL = API_URL + "dashboard/prescriptions/store";
  static const String UPDATE_PRESCRIPTION_URL = API_URL + "dashboard/prescriptions/update/";
  static const String DELETE_PRESCRIPTION_URL = API_URL + "dashboard/prescriptions/delete/";
  static const String PROFILE_INFO_URL = API_URL + "profile/info";
  static const String UPDATE_PROFILE_INFO_URL = API_URL + "profile/update";
  static const String REPORTS_URL = API_URL + "dashboard/reports/list";
  static const String PRESCRIPTION_GENERATE_URL = API_URL + "prescription_print/";
  static const String REPORT_GENERATE_URL = API_URL + "report_print/";
}