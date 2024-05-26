import 'dart:convert';
import 'package:android/Class/User.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetUserToken {
  Future<bool> saveUserEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userEmail', value);
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<bool> saveUserPass(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userPass', value);
  }

  Future<bool> removeUserPass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('userPass');
  }

  Future<String?> getUserPass() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userPass');
  }

  Future<bool> setUserToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userToken', value);
  }

  Future<bool> removeUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('userToken');
  }

  Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<bool?> updateProfile(String token, String name, String phone, String birthday, String address, int gender) async {
    final resp = await http.post(
      Uri.parse('https://nightlight.asia/api/updateProfile'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name' : name,
        'phone' : phone,
        'birthday' : birthday,
        'address' : address,
        'gender' : gender
      }),
    );


    if (resp.statusCode == 200) {
      return true;
    }
    else {
      return null;
    }
  }

  Future<User?> getProfile(String token) async {
    final resp = await http.post(
      Uri.parse('https://nightlight.asia/api/profile'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (resp.statusCode == 200) {
      var readJson = jsonDecode(resp.body) as Map<String, dynamic>;
      if (readJson.isNotEmpty) {
        return User.fromJson(readJson);
      }
      else {
        return null;
      }
    }
    else {
      throw Exception("Lỗi");
    }
  }

  Future<String?> createLogin(String email, String password, bool checked) async {
    final resp = await http.post(
      Uri.parse('https://nightlight.asia/api/login'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'email' : email,
        'password': password
      }),
    );

    if (resp.statusCode == 200) {
      var readJson = (jsonDecode(resp.body) as Map<String, dynamic>);
      if (readJson['access_token'] != null) {
        var token = readJson['access_token'] as String;
        await setUserToken(token);
        await saveUserEmail(email);
        if (checked == true) {
          await saveUserPass(password);
        }
        else {
          await removeUserPass();
        }
        return token;
      }
      else {
        if (readJson['error'] != null) {
          Fluttertoast.showToast(
            msg: readJson['error'].toString(),
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        return null;
      }
    }
    else {
      var readJson = (jsonDecode(resp.body));
      if (readJson['password'] != null) {
        Fluttertoast.showToast(
          msg: readJson['password'][0].toString(),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
      else if (readJson['email'] != null) {
        Fluttertoast.showToast(
          msg: readJson['email'][0].toString(),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
      return null;
    }
  }

  Future<String?> createSignUp(String email, String name, String password, String rePassword) async {
    final resp = await http.post(
      Uri.parse('https://nightlight.asia/api/register'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'email' : email,
        'name' : name,
        'password': password,
        'password_confirmation' : rePassword
      }),
    );

    if (resp.statusCode == 200) {
      var readJson = (jsonDecode(resp.body) as Map<String, dynamic>);
      if (readJson['message'] != null) {
        var message = readJson['message'] as String;
        Fluttertoast.showToast(
          msg: "Đăng ký thành công!",
          toastLength: Toast.LENGTH_SHORT,
        );
        return message;
      }
      else {
        return null;
      }
    }
    else {
      try {
        var readJson = (jsonDecode(resp.body));
        if (readJson['password'] != null) {
          Fluttertoast.showToast(
            msg: readJson['password'][0].toString(),
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        else if (readJson['email'] != null) {
          Fluttertoast.showToast(
            msg: readJson['email'][0].toString(),
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        else if (name.isEmpty) {
          Fluttertoast.showToast(
            msg: "The name field is required.",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      }
      on FormatException {
        Fluttertoast.showToast(
          msg: 'Đăng ký lỗi.',
          toastLength: Toast.LENGTH_SHORT,
        );
      }
      return null;
    }
  }
}