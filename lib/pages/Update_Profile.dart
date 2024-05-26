import 'package:android/Class/User.dart';
import 'package:android/components/ProfileUser_Padding.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => WidgetUpdateProfile();
}

class WidgetUpdateProfile extends State<UpdateProfile>
{

  late String userToken;
  late User user;
  late Future<String?>? futureUserToken;
  late Future<User?>? futureUser;

  bool userState = false;
  bool userStateFail = false;
  bool userTokenState = false;
  bool userTokenStateFail = false;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  void refresh() {
    futureUserToken = GetUserToken().getUserToken();
    futureUserToken?.then((value){
      if (mounted) {
        setState(() {
          userState = false;
          userStateFail = false;
          userTokenState = false;
          userTokenStateFail = false;
          if (value != null) {
            userToken = value;
            userTokenState = true;
            futureUser = GetUserToken().getProfile(value);
            futureUser?.then((value){
              if (mounted) {
                setState(() {
                  if (value != null) {
                    user = value;
                    userState = true;
                  }
                  else {
                    userStateFail = true;
                  }
                });
              }
            });
          }
          else {
            userTokenStateFail = true;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    futureUserToken = GetUserToken().getUserToken();
    futureUserToken?.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value != null) {
              userToken = value;
              userTokenState = true;
              futureUser = GetUserToken().getProfile(value);
              futureUser?.then((value){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      if (value != null) {
                        user = value;
                        userState = true;
                      }
                      else {
                        userStateFail = true;
                      }
                    });
                  }
                });
              });
            }
            else {
              userTokenStateFail = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userTokenState && userState) {
      return BuildWidgetUpdateProfile(user: user, refresh: refresh, dateFormat: dateFormat);
    }
    else if (userTokenStateFail || userStateFail) {
      if (userTokenState && userStateFail) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
              content: Center(child: Text('Phiên đăng nhập hết hạn!')),
            ),
          );
        });
      }
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/empty.jpg",
              ),
              const Text(
                "There is nothing here...",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.black38,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
    }
  }
}

class BuildWidgetUpdateProfile extends StatelessWidget {
  const BuildWidgetUpdateProfile({super.key, required this.user, required this.refresh,
  required this.dateFormat});

  final Function refresh;
  final User user;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {

    DateTime birthday = user.birthday != null ? (dateFormat.parse(user.birthday.toString())) : DateTime(0000-00-00);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Tài khoản",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                child: Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/default_avatar.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.only(bottom: 5),
              child:Column(
                children: [
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(
                color: Colors.grey,
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              width: size.width,
              child: const Text(
                "Thông tin tài khoản",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            profileUserPadding(text: user.id.toString(), mainText: "ID tài khoản", longText: false),
            profileUserPadding(text: user.name, mainText: "Tên tài khoản", longText: false),

            Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(
                color: Colors.grey,
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              width: size.width,
              child: const Text(
                "Thông tin cá nhân",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            profileUserPadding(text: "(+84) ${user.phone.toString()}", mainText: "Số điện thoại", longText: false),
            profileUserPadding(text: user.birthday != null ? "${birthday.day}/${birthday.month}/${birthday.year}" : user.birthday.toString(), mainText: "Ngày sinh",  longText: false),
            profileUserPadding(text: user.address.toString(), mainText: "Địa chỉ", longText: true),
            profileUserPadding(text: user.gender != null ? (user.gender.toString() == "1" ? "Nam" : "Nữ") : user.gender.toString(), mainText: "Giới tính", longText: false),

            Container(
              margin: const EdgeInsets.all(10),
              child: const Divider(
                color: Colors.grey,
              ),
            ),

            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/UpdateProfileWrite', arguments: user).then((value){
                    if (value != null) {
                      refresh();
                    }
                  });
                },
                child: const Text(
                  "Cập nhật",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent
                ),
                onPressed: () {},
                child: const Text(
                  "Đóng tài khoản",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}