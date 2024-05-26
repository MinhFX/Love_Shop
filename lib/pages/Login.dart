import 'dart:async';
import 'package:android/components/LoginTextField.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => WidgetLogin();
}

class WidgetLogin extends State<Login> {
  Future<String?>? userEmail;
  Future<String?>? userPass;
  bool isChecked = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String pass = "";
  String email = "";
  String? login;
  bool _isPushed = false;
  bool passEmail = false;
  bool passPassword = false;

  @override
  void initState() {
    super.initState();
    userEmail = GetUserToken().getUserEmail();
    userEmail?.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value != null) {
              email = value;
              emailController.text = email;
              passEmail = true;
            }
            else {
              passEmail = true;
            }
          });
        }
      });
    });
    userPass = GetUserToken().getUserPass();
    userPass?.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value != null) {
              pass = value;
              passwordController.text = pass;
              passPassword = true;
            }
            else {
              passPassword = true;
            }
          });
        }
      });
    });
  }

  void setUserToken() {
    if (!_isPushed) {
      setState(() {
        _isPushed = true;
      });
      Future<String?>? user = GetUserToken().createLogin(emailController.text, passwordController.text, isChecked);
      user.then((value) {
        if (mounted) {
          setState(() {
            if (value != null) {
              login = value;
            }
            else {
              _isPushed = false;
            }
          });
        }
      });
    }
  }

  void setChecked(bool? value) {
    if (mounted) {
      setState(() {
        isChecked = value!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (login != null && _isPushed) {
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
    else {
      if (passPassword && passEmail) {
        return BuildWidgetLogin(emailController: emailController, passwordController: passwordController,
            userToken: setUserToken, setChecked: setChecked, isChecked: isChecked,
            isPushed: _isPushed);
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
}

class BuildWidgetLogin extends StatelessWidget {
  const BuildWidgetLogin({super.key, required this.emailController, required this.passwordController, required this.userToken,
  required this.setChecked, required this.isChecked,
  required this.isPushed});

  final emailController;
  final passwordController;
  final Function userToken;
  final bool isChecked;
  final bool isPushed;
  final Function(bool?) setChecked;

  @override Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Đăng nhập'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 189, 143, 171),
              Color.fromARGB(255, 255, 143, 170),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Stack(
              children: [
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                      fontSize: 60,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.black,
                      fontFamily: 'RobotoCondensed-VariableFont_wght.ttf'
                  ),
                ),

                GradientText(
                  'Đăng nhập',
                  style: const TextStyle(
                      fontSize: 60,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(6.0, 6.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(125, 0, 0, 0),
                        ),
                      ],
                      fontFamily: 'RobotoCondensed-VariableFont_wght.ttf'
                  ),
                  colors: const [
                    Colors.white,
                    Colors.white
                  ],
                )
              ],
            ),

            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 7
                  )
                ],
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 250, 197, 202),
                      Colors.white,
                    ]
                ),
              ),
              child: Padding(

                padding: const EdgeInsets.symmetric(
                    vertical: 30
                ),

                child: Column(
                  children: [

                    LoginTextField(
                      controller: emailController,
                      icons: const Icon(Icons.email),
                      textInputType: TextInputType.emailAddress,
                      hintText: "+Email",
                      labelText: "Email",
                      obscureText: false,
                    ),

                    const SizedBox(
                        height: 20
                    ),

                    LoginTextField(
                      controller: passwordController,
                      icons: const Icon(Icons.password),
                      textInputType: TextInputType.text,
                      hintText: "Mật khẩu",
                      labelText: "Mật khẩu",
                      obscureText: true,
                    ),

                    const SizedBox(
                        height: 20
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              userToken();
                            },
                            color: const Color.fromARGB(255, 255, 143, 171),
                            textColor: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    if (isPushed) {
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

                          const SizedBox(
                              height: 10
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.35,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: MediaQuery.of(context).size.width*0.07,
                                        child: Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? newValue) {
                                            setChecked(newValue);
                                          },
                                          activeColor: const Color.fromARGB(255, 255, 143, 171),
                                          checkColor: Colors.white,
                                        ),
                                      ),

                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.28,
                                        child: const FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Lưu mật khẩu',
                                            style: TextStyle(
                                                fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.35,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        textAlign: TextAlign.end,
                                        'Quên mật khẩu?',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 255, 143, 171),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height: 10
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn chưa có tài khoản?',
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/SignUp');
                          },
                          child: const Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 143, 171),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}