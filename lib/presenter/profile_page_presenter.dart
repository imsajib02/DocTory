import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:doctory/contract/profile_page_contract.dart';
import 'package:doctory/localization/app_localization.dart';
import 'package:doctory/model/user.dart';
import 'package:doctory/utils/api_routes.dart';
import 'package:doctory/utils/custom_log.dart';
import 'package:doctory/utils/custom_trace.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doctory/utils/connection_check.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePagePresenter implements Presenter {

  View _view;
  User _currentUser;
  bool _isFirstOpen;
  ImagePicker picker;

  ProfilePagePresenter(View view, User currentUser, bool isFirstOpen) {

    this._view = view;
    this._currentUser = currentUser;
    this._isFirstOpen = isFirstOpen;
    picker = ImagePicker();
  }

  @override
  void isFirstOpen(BuildContext context, String token) {

    if(_isFirstOpen) {

      _view.setProfileInfoFromLoginData();
    }
    else {

      getProfileInfo(context, token);
    }
  }

  @override
  Future<void> getProfileInfo(BuildContext context, String token) async {

    checkInternetConnection().then((isConnected) {

      if(isConnected) {

        _view.showProgressIndicator();

        var client = http.Client();

        client.get(

          Uri.encodeFull(APIRoute.PROFILE_INFO_URL),
          headers: {"Authorization": "Bearer $token", "Accept" : "application/json"},

        ).then((response) {

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Profile Info Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            User userInfo = User.fromProfile(jsonData);

            userInfo.avatar.replaceAll("\\", "");

            _view.setProfileInfoFromProfileData(userInfo);
          }
          else {

            _view.failedToGetProfileData(context);
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          client.close();

          _view.failedToGetProfileData(context);
          _view.onConnectionTimeOut();
        });
      }
      else {

        _view.failedToGetProfileData(context);
        _view.onNoConnection();
      }
    });
  }

  @override
  void validateInput(BuildContext context, String token, User inputData) {

    if(inputData.avatar.isEmpty) {

      _view.onEmpty(AppLocalization.of(context).getTranslatedValue("select_profile_image"));
    }
    else {

      if(inputData.name.isEmpty) {

        _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_your_name"));
      }
      else {

        if(inputData.designation.isEmpty) {

          _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_your_designation"));
        }
        else {

          if(inputData.address.isEmpty) {

            _view.onEmpty(AppLocalization.of(context).getTranslatedValue("enter_your_address"));
          }
          else {

            _checkForSameData(context, inputData, token);
          }
        }
      }
    }
  }


  void _checkForSameData(BuildContext context, User inputData, String token) {

    if(inputData.avatar == _currentUser.avatar && inputData.name == _currentUser.name &&
        inputData.officeMobile == _currentUser.officeMobile && inputData.designation == _currentUser.designation &&
        inputData.address == _currentUser.address) {

      _view.onError(AppLocalization.of(context).getTranslatedValue("provide_new_information_message"));
    }
    else {

      _updateProfile(context, inputData, token);
    }
  }


  Future<void> _updateProfile(BuildContext context, User inputData, String token) async {

    checkInternetConnection().then((isConnected) async {

      if(isConnected) {

        _view.showProgressDialog(AppLocalization.of(context).getTranslatedValue("please_wait_message"));

        var request = http.MultipartRequest("POST", Uri.parse(APIRoute.UPDATE_PROFILE_INFO_URL));

        var multipartFile;

        if(inputData.avatar != _currentUser.avatar) {

          //File file = File(inputData.avatar);

          //var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
          //var length = await file.length();

          multipartFile = await http.MultipartFile.fromPath('avatar', inputData.avatar);

          request.files.add(multipartFile);
        }

        Map<String, String> headers = {"Authorization": "Bearer $token", "Accept" : "application/json"};

        request.headers.addAll(headers);

        request.fields['name'] = inputData.name;
        request.fields['office_mobile'] = inputData.officeMobile;
        request.fields['address'] = inputData.address;
        request.fields['designation'] = inputData.designation;

        request.send().then((streamedResponse) async {

          final response = await http.Response.fromStream(streamedResponse);

          CustomLogger.debug(trace: CustomTrace(StackTrace.current), tag: "Update Profile Response", message: response.body);

          var jsonData = json.decode(response.body);

          if(response.statusCode == 200 || response.statusCode == 201) {

            if(jsonData['status'] == AppLocalization.of(context).getTranslatedValue("status_success_response")) {

              User user = User.fromProfile(jsonData['user']);

              user.avatar.replaceAll("\\", "");

              _currentUser = user;

              CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "Profile Updated", message: "User id: " +user.userID.toString());

              _view.hideProgressDialog();

              if(_isFirstOpen) {

                _view.goToDashBoard(_currentUser);
              }
              else {

                _view.onUpdateSuccess(context, user);
              }
            }
            else {

              _failedToUpdateProfile(context);
            }
          }
          else {

            _failedToUpdateProfile(context);
          }

        }).timeout(Duration(seconds: 15), onTimeout: () {

          //_view.hideProgressDialog();
          //_view.onConnectionTimeOut();
        });
      }
      else {

        _view.onNoConnection();
      }
    });
  }

  void _failedToUpdateProfile(BuildContext context) {

    CustomLogger.error(trace: CustomTrace(StackTrace.current), tag: "Update Profile", message: "Failed to update profile");

    _view.onUpdateFailure(context);
  }

  @override
  Future<void> getImage(BuildContext context, String imageUrl) async {

    if(imageUrl.isNotEmpty) {

      _view.setImageLoadingView();

      imageCache.clear();

      var rng = Random();
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      File file = File(tempPath + (rng.nextInt(100)).toString() +'.png');

      http.Response response = await http.get(imageUrl);

      await file.writeAsBytes(response.bodyBytes);

      //var image = Image.network(imageUrl);

      _view.setImage(file);
    }
  }

  @override
  Future<void> pickImage(BuildContext context, bool isLoading) async {

    if(!isLoading) {

      try {

        var pickedFile = await picker.getImage(source: ImageSource.gallery);

        File file = File(pickedFile.path);

        int fileSizeInBytes = await file.length();
        double fileSizeInKB = fileSizeInBytes / 1024;
        double fileSizeInMB = fileSizeInKB / 1024;

        if(fileSizeInMB <= 2.0) {

          _view.setImageFromGallery(file);
        }
        else {

          _view.onError(AppLocalization.of(context).getTranslatedValue("image_can_not_be_greater_than_2_mb"));
        }

      } catch(error) {

        print(error);
      }
    }
  }

  @override
  void onBackPressed() {

    if(!_isFirstOpen) {

      _view.goToDashBoard(_currentUser);
    }
  }
}