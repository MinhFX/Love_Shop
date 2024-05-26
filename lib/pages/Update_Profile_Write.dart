import 'dart:async';

import 'package:android/Class/User.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateProfileWrite extends StatefulWidget {
  const UpdateProfileWrite({super.key, required this.user});
  final User user;

  @override
  State<UpdateProfileWrite> createState() => WidgetUpdateProfileWrite();
}

enum gender {nam, nu}

class WidgetUpdateProfileWrite extends State<UpdateProfileWrite>
{
  late TextEditingController nameController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController addressController = TextEditingController();

  late String userToken;
  late User user = widget.user;
  late Future<String?>? futureUserToken;

  bool userState = false;
  bool userStateFail = false;
  bool userTokenState = false;
  bool userTokenStateFail = false;
  bool click = false;
  bool updateSuccess = false;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime dateTime = DateTime(1990, 1, 1);

  gender? character = gender.nam;
  int genderInt = 1;

  void setGender(gender? value) {
    if (mounted) {
      setState(() {
        character = value;
        if (value == gender.nam) {
          genderInt = 1;
        }
        else {
          genderInt = 0;
        }
      });
    }
  }

  void pickDate(BuildContext context) async {
    final DateTime? pick = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1990, 1, 1),
        lastDate: DateTime(2200, 12, 31),
    );
    if (pick != null) {
      setState(() {
        dateTime = pick;
      });
    }
  }

  void updateProfile() {
    if (!click) {
      setState(() {
        click = true;
      });
      Future<bool?> future = GetUserToken().updateProfile(userToken, nameController.text, int.parse(phoneController.text).toString(),
          dateFormat.format(dateTime), addressController.text, genderInt);
      future.then((value){
        if (value != null) {
          setState(() {
            updateSuccess = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                backgroundColor: Colors.green,
                content: Center(child: Text('Cập nhật thành công!')),
              ),
            );
          });
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
              content: Center(child: Text('Không thể cập nhật!')),
            ),
          );
          setState(() {
            click = false;
          });
        }
      });
    }
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
              nameController.text = user.name;
              phoneController.text = user.phone != null ? "0${user.phone.toString()}" : "";
              addressController.text = user.address != null ? user.address.toString() : "";
              character = (user.gender != null ? (user.gender == 1 ? gender.nam : gender.nu) : gender.nam);
              genderInt = (user.gender != null ? (user.gender == 1 ? 1 : 0) : 1);
              dateTime = (user.birthday != null ? dateFormat.parse(user.birthday.toString()) : DateTime(1990, 1, 1));
              userTokenState = true;
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
    if (!updateSuccess) {
      if (userTokenState) {
        return BuildWidgetUpdateProfileWrite(user: user, dateTime: dateTime, pickDate: pickDate,
        character: character, setGender: setGender, nameController: nameController, phoneController: phoneController,
        addressController: addressController, updateProfile: updateProfile, click: click);
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
    else {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context, true);
      });
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

class BuildWidgetUpdateProfileWrite extends StatelessWidget {
  const BuildWidgetUpdateProfileWrite({super.key, required this.user, required this.dateTime,
  required this.pickDate, required this.character, required this.setGender, required this.nameController,
  required this.phoneController, required this.addressController, required this.updateProfile,
  required this.click});

  final bool click;
  final Function updateProfile;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final Function(gender?) setGender;
  final Function(BuildContext) pickDate;
  final DateTime dateTime;
  final User user;
  final gender? character;
  static final formKey = GlobalKey<FormState>();

  String? validatePhone(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Vui lòng nhập số điện thoại.';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Vui lòng nhập số điện thoại hợp lệ.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Cập nhật tài khoản",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
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
                width: MediaQuery.of(context).size.width,
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
              const Text(
                "Thông tin cập nhật",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập họ tên.';
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    labelText: "Tên tài khoản",
                    hintText: "Tên tài khoản",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: phoneController,
                  validator: (value) {
                    return validatePhone(value!);
                  },
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    labelText: "Số điện thoại",
                    hintText: "Số điện thoại",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập địa chỉ.';
                    }
                    return null;
                  },
                  controller: addressController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    labelText: "Địa chỉ",
                    hintText: "Địa chỉ",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            const Text(
                              "Ngày sinh",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            MaterialButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:BorderRadius.circular(10.0),
                                side: const BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                              color: Colors.white,
                              onPressed: () {
                                pickDate(context);
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width/2)-25.5,
                                alignment: Alignment.center,
                                height: 50,
                                child: Text(
                                  "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            const Text(
                              "Giới tính",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Container(
                              width: (MediaQuery.of(context).size.width/2),
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio<gender>(
                                          activeColor: Colors.black,
                                          value: gender.nam,
                                          groupValue: character,
                                          onChanged: (gender? value) {
                                            setGender(value);
                                          },
                                        ),
                                        const Text(
                                          'Nam',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.man,
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Radio<gender>(
                                          activeColor: Colors.black,
                                          value: gender.nu,
                                          groupValue: character,
                                          onChanged: (gender? value) {
                                            setGender(value);
                                          },
                                        ),
                                        const Text(
                                          'Nữ',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.woman,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: const Divider(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      updateProfile();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Cập nhật",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (click) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                width: 35,
                                height: 35,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.black38,
                                  strokeCap: StrokeCap.round,
                                ),
                              );
                            }
                            else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}