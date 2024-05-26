import 'package:android/components/LoginTextField.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => WidgetSignUp();
}

class WidgetSignUp extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();
  final userNameController = TextEditingController();
  bool isPushed = false;
  String? signUp;

  void setUserMessage() {
    if (!isPushed) {
      setState(() {
        isPushed = true;
      });
      Future<String?>? user = GetUserToken().createSignUp(emailController.text, userNameController.text, passwordController.text, passwordAgainController.text);
      user.then((value){
        if (mounted) {
          setState(() {
            if (value != null) {
              signUp = value;
            }
            else {
              isPushed = false;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (signUp != null && isPushed) {
        Future.delayed(Duration.zero, () {
          Navigator.pop(context);
        });
        return const Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black38,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
        );
      }
      else {
        return BuildWidgetSignUp(emailController: emailController, passwordController: passwordController, passwordAgainController: passwordAgainController,
        userNameController: userNameController, userMessage: setUserMessage, isPushed: isPushed);
      }
    });
  }
}

class BuildWidgetSignUp extends StatelessWidget {
  const BuildWidgetSignUp({super.key, required this.emailController, required this.passwordController,
  required this.passwordAgainController, required this.userNameController, required this.userMessage,
  required this.isPushed});
  final emailController;
  final passwordController;
  final passwordAgainController;
  final userNameController;
  final bool isPushed;
  final Function userMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Đăng ký'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                end: Alignment.bottomRight,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Text(
                    'Đăng ký',
                    style: TextStyle(
                        fontSize: 60,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(6.0, 6.0),
                            blurRadius: 10.0,
                            color: Color.fromARGB(20, 0, 0, 0),
                          ),
                        ],
                        fontFamily: 'RobotoCondensed-VariableFont_wght.ttf'
                    ),
                  ),

                  GradientText(
                      'Đăng ký',
                      style: const TextStyle(
                          fontSize: 60,
                          fontFamily: 'RobotoCondensed-VariableFont_wght.ttf',
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(6.0, 6.0),
                              blurRadius: 10.0,
                              color: Color.fromARGB(125, 0, 0, 0),
                            ),
                          ]
                      ),
                      colors: const [
                        Colors.white,
                        Colors.white
                      ]
                  ),
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
                          vertical: 20
                      ),

                      child: Column(
                        children: [

                          LoginTextField(
                            controller: userNameController,
                            icons: const Icon(Icons.supervised_user_circle),
                            textInputType: TextInputType.text,
                            hintText: "Tên người dùng",
                            labelText: "Tên người dùng",
                            obscureText: false,
                          ),

                          const SizedBox(
                              height: 20
                          ),

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

                          LoginTextField(
                            controller: passwordAgainController,
                            icons: const Icon(Icons.password),
                            textInputType: TextInputType.text,
                            hintText: "Nhập lại mật khẩu",
                            labelText: "Nhập lại mật khẩu",
                            obscureText: true,
                          ),

                          const SizedBox(
                              height: 20
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () {
                                userMessage();
                              },
                              color: const Color.fromARGB(255, 255, 143, 171),
                              textColor: Colors.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Đăng ký',
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
                          ),

                          const SizedBox(
                              height: 10
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Bạn đã có tài khoản?',
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context
                                  );
                                },
                                child: const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 143, 171),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}