class User {

  String name;
  String email;
  String mobile;
  String password;
  String oldPassword;
  String confirmPassword;
  int userID;
  String accessToken;
  String tokenType;
  String avatar;
  String officeMobile;
  String designation;
  String address;
  bool auth;

  User({this.name, this.email, this.userID, this.mobile, this.password, this.auth, this.address, this.oldPassword,
    this.confirmPassword, this.accessToken, this.tokenType, this.avatar, this.designation, this.officeMobile});

  User.fromLogin(Map<String, dynamic> json) {

    name =  json['user']['name'] == null ? "" : json['user']['name'];
    email =  json['user']['email'] == null ? "" : json['user']['email'];
    avatar =  json['user']['avatar'] == null ? "" : json['user']['avatar'];
    mobile =  json['user']['mobile'] == null ? "" : json['user']['mobile'];
    officeMobile =  json['user']['office_mobile'] == null ? "" : json['user']['office_mobile'];
    designation =  json['user']['designation'] == null ? "" : json['user']['designation'];
    address = json['user']['address'] == null ? "" : json['user']['address'];
    userID =  json['user']['id'] == null ? 0 : json['user']['id'];
    accessToken = json['access_token'] == null ? "" : json['access_token'];
    tokenType = json['token_type'] == null ? "" : json['token_type'];
  }

  User.fromEmailVerify(Map<String, dynamic> json) {

    mobile =  json['user']['mobile'] == null ? "" : json['user']['mobile'];
  }

  User.fromLocal(Map<String, dynamic> json) {

    name =  json['name'] == null ? "" : json['name'];
    email =  json['email'] == null ? "" : json['email'];
    password =  json['password'] == null ? "" : json['password'];
    mobile =  json['mobile'] == null ? "" : json['mobile'];
    userID =  json['userID'] == null ? 0 : json['userID'];
    avatar =  json['avatar'] == null ? "" : json['avatar'];
    officeMobile =  json['office_mobile'] == null ? "" : json['office_mobile'];
    designation =  json['designation'] == null ? "" : json['designation'];
    accessToken = json['access_token'] == null ? "" : json['access_token'];
    tokenType = json['token_type'] == null ? "" : json['token_type'];
    address = json['address'] == null ? "" : json['address'];
  }

  User.fromProfile(Map<String, dynamic> json) {

    name =  json['name'] == null ? "" : json['name'];
    email =  json['email'] == null ? "" : json['email'];
    mobile =  json['mobile'] == null ? "" : json['mobile'];
    userID =  json['id'] == null ? 0 : json['id'];
    avatar =  json['avatar'] == null ? "" : json['avatar'];
    officeMobile =  json['office_mobile'] == null ? "" : json['office_mobile'];
    designation =  json['designation'] == null ? "" : json['designation'];
    address = json['address'] == null ? "" : json['address'];
  }

  User.fromRegistration(Map<String, dynamic> json) {

    name =  json['user']['name'] == null ? "" : json['user']['name'];
    email =  json['user']['email'] == null ? "" : json['user']['email'];
    userID =  json['user']['id'] == null ? 0 : json['user']['id'];
  }

  toLogin() {

    return {
      "email" : email == null ? "" : email,
      "password" : password == null ? "" : password
    };
  }

  toEmailVerify() {

    return {
      "email" : email == null ? "" : email
    };
  }

  toDuplicateCheck() {

    return {
      "email" : email == null ? "" : email,
      "mobile" : mobile == null ? "" : mobile
    };
  }

  toRegistration() {

    return {
      "name" : name == null ? "" : name,
      "email" : email == null ? "" : email,
      "password" : password == null ? "" : password,
      "confirm_password" : password == null ? "" : password,
      "mobile" : mobile == null ? "" : mobile
    };
  }

  toPasswordReset() {

    return {
      "mobile" : mobile == null ? "" : mobile,
      "new_password" : password == null ? "" : password,
      "confirm_password" : confirmPassword == null ? "" : confirmPassword
    };
  }

  toPasswordChange() {

    return {
      "old_password" : oldPassword == null ? "" : oldPassword,
      "new_password" : password == null ? "" : password,
      "confirm_password" : confirmPassword == null ? "" : confirmPassword
    };
  }

  toLocal() {

    return {
      "name" : name == null ? "" : name,
      "email" : email == null ? "" : email,
      "password" : password == null ? "" : password,
      "mobile" : mobile == null ? "" : mobile,
      "userID" : userID == null ? 0 : userID,
      "avatar" : avatar == null ? "" : avatar,
      "office_mobile" : officeMobile == null ? "" : officeMobile,
      "designation" : designation == null ? "" : designation,
      "access_token" : accessToken == null ? "" : accessToken,
      "token_type" : tokenType == null ? "" : tokenType,
      "address" : address == null ? "" : address,
    };
  }
}