import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fastaagent/apis/models/agent_profile.dart';
import 'package:fastaagent/contants/constants.dart';
import 'package:fastaagent/controller/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../apis/apis.dart';
import '../apis/models/agent_history_model.dart';
import '../features/auth/forgetten_password/forgetten_password.dart';
import '../features/auth/sign_in/sign_in.dart';
import '../features/auth/sign_up/d_register_screen.dart';
import '../features/auth/sign_up/verification_screen.dart';
import '../features/bottom_nav/home.dart';

class AgentController extends GetxController {
  final Apis _apiController = Apis();
  bool state = false;

  Future loginUser({required String email, required String password}) async {
    try {
      var data = await _apiController.signInDriver(
        email: email,
        password: password,
      );
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future forgettenPassword(
    String email,
  ) async {
    try {
      var data = await _apiController.forgotpasswordDrivers(
        email: email,
      );
      if (data.statusCode == 201) {
        final res = json.decode(data.body);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Success",
            res["message"]);
        if (res["message"] == "OTP sent successfully") {
          Get.to(() => ForgottenPassword(
                email: res["data"]["user"]["email"],
                phoneNumber: res["data"]["user"]["phone"],
              ));
        }
        return;
      } else if (data.statusCode == 400) {
        final res = json.decode(data.body);
        log(data.body);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            "${res["message"]}");
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future resetPassword(
    String email,
    String password,
  ) async {
    try {
      var data =
          await _apiController.restpassword(email: email, password: password);

      if (data.statusCode == 201) {
        final res = json.decode(data.body);

        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Success",
            res["message"]);
        if (res["message"] == "Password reset successful") {
          Get.off(() => const SignIn());
        }
        return;
      } else if (data.statusCode == 403 || data.statusCode == 400) {
        final res = json.decode(data.body);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            "${res["message"]}");
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    }
  }

  Future<AgentProfile?> getprofile() async {
    var res = await _apiController.getUserDetail();

    if (res.statusCode == 200) {
      log('res ${res.body.toString()}');
      await AStorage.saveAgentProfile(res.body.toString());
      AgentProfile agentProfile = AgentProfile.fromJson(json.decode(res.body));
      return agentProfile;
    }
    return null;
  }

  Future<AgentHistory?> getHistory() async {
    var res = await _apiController.getUserHistory();
    log(res.body);
    if (res.statusCode == 200) {
      await AStorage.saveHistory(res.body.toString());
      AgentHistory agentProfile = AgentHistory.fromJson(json.decode(res.body));
      return agentProfile;
    }
    return null;
  }

  Future verifyOtp({required String code, required String phoneNumber}) async {
    try {
      final user =
          await _apiController.verifyOtp(phoneNumber: phoneNumber, code: code);
      if (user.statusCode == 201) {
        var data = json.decode(user.body);
        AStorage.saveDriverToken(data["token"]);
      }
      return user;
    } catch (e) {
      Get.snackbar(
          backgroundColor: AppColor.mainSecondryColor,
          e.toString(),
          e.toString());
    }
  }

  Future getOtp({required String code, required String phoneNumber}) async {
    try {
      var data =
          await _apiController.verifyOtp(phoneNumber: phoneNumber, code: code);
      if (data.statusCode == 201) {
        final res = json.decode(data.body);
        final token = res["token"];
        //  GlobalStorage.saveToken(token);

        AStorage.saveDriverToken(token);
        if (res["user"]["accountNumber"] == null ||
            res["user"]["bankName"] == null ||
            res["user"]["accountName"] == null) {
          Get.to(() => AddBankDetails(
                phoneNum: phoneNumber,
              ));
        } else {
          Get.offAll(() => const HomePage());
        }
      } else if (data.statusCode == 400) {
        final res = json.decode(data.body);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            res["message"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future editProfile({
    required String name,
    required String email,
    required String accountName,
    required String accountNumber,
    required String bankName,
    required String paymentOption,
  }) async {
    state = true;
    try {
      final data = await _apiController.editProfile(
        accountName: accountName,
        accountNumber: accountNumber,
        bankName: bankName,
        paymentOption: paymentOption,
        name: name,
        email: email,
      );
      state = false;
      log(data.statusCode.toString());
      if (data.statusCode == 201) {
        final res = json.decode(data.body);
        log(res["message"]);

        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            "Success",
            res["message"]);
        return res;
      } else if (data.statusCode == 400) {
        final res = json.decode(data.body);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            res["message"]);
      }
    } catch (e) {
      if (kDebugMode) {
        state = false;
        print(e.toString());
      }
      Get.snackbar(
        backgroundColor: AppColor.mainSecondryColor,
        'Error',
        "Error Occurr",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
    return null;
  }

  Future updateName({
    required String driverAccName,
    required String driverAccNum,
    required String driverBank,
    required String paymentOption,
  }) async {
    state = true;
    try {
      final data = await _apiController.updateDriverName(
        accountName: driverAccName,
        accountNumber: driverAccNum,
        bankName: driverBank,
        paymentOption: paymentOption,
      );
      state = false;

      if (data.statusCode == 201) {
        final res = json.decode(data.body);
        return res;
      } else if (data.statusCode == 400) {
        final res = json.decode(data.body);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            res["message"]);
      }
    } catch (e) {
      if (kDebugMode) {
        state = false;
        print(e.toString());
      }
      Get.snackbar(
        backgroundColor: AppColor.mainSecondryColor,
        'Error',
        "Error Occurr",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future driverCreate({
    required String phoneNumber,
    required String password,
    required String email,
    required String fullname,
    required String nin,
    required File ninImage,
  }) async {
    try {
      final data = await _apiController.createUser(
        password: password,
        phoneNumber: phoneNumber,
        fullname: fullname,
        email: email,
        nin: nin,
        ninImage: ninImage,
      );
      final resultData = await data.stream.toBytes();
      String resp = String.fromCharCodes(resultData);
      if (data.statusCode == 201) {
        Get.to(() => VerificationScreen(
              phoneNumber: phoneNumber,
              email: email,
              password: password,
            ));
      } else if (data.statusCode == 400) {
        final res = json.decode(resp);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            res["message"]);
      }
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future uploadProfile({
    required File profileImage,
  }) async {
    state = true;
    try {
      final data = await _apiController.uploadProfile(
        ninImage: profileImage,
      );
      final resultData = await data.stream.toBytes();
      String resp = String.fromCharCodes(resultData);
      log(resp);
      if (data.statusCode == 201) {
        final res = json.decode(resp);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Success",
            res["message"]);
        return res;
      } else if (data.statusCode == 400) {
        final res = json.decode(resp);
        Get.snackbar(
            backgroundColor: AppColor.mainSecondryColor,
            snackPosition: SnackPosition.BOTTOM,
            "Error",
            res["message"]);
      }
      return data;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
