import 'package:android/Class/Order.dart';
import 'package:android/Class/ProductCart.dart';
import 'package:android/Class/ProductMenu.dart';
import 'package:android/Class/SendUserOrder.dart';
import 'package:android/Class/User.dart';
import 'package:android/pages/CheckCart.dart';
import 'package:android/pages/Main_Page.dart';
import 'package:android/pages/Product_Detail.dart';
import 'package:android/pages/SignUp.dart';
import 'package:android/pages/Update_Profile.dart';
import 'package:android/pages/Update_Profile_Write.dart';
import 'package:android/pages/UserOrder.dart';
import 'package:android/pages/UserOrderDetail.dart';
import 'package:flutter/material.dart';
import 'pages/Login.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đăng nhập',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 238, 207, 229)
      ),
      routes: {
        "/Login": (context) => const Login(),
        "/SignUp": (context) => const SignUp(),
        "/": (context) => const MainPage(),
        "/UpdateProfile": (context) => const UpdateProfile(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/ProductDetail") {
          final args = settings.arguments as ProductMenu;
          return MaterialPageRoute(
            builder: (context) {
              return ProductDetail(product: args);
            },
          );
        }
        else if (settings.name == "/UpdateProfileWrite") {
          final args = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) {
              return UpdateProfileWrite(user: args);
            },
          );
        }
        else if (settings.name == "/CheckCart") {
          final CheckCart argument = settings.arguments as CheckCart;
          return MaterialPageRoute(
            builder: (context) {
              return CheckCart(listCart: argument.listCart, userToken: argument.userToken, userID: argument.userID, userEmail: argument.userEmail);
            },
          );
        }
        else if (settings.name == "/UserOrder") {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return UserOrder(userToken: args);
            },
          );
        }
        else if (settings.name == "/UserOrderDetail") {
          final args = settings.arguments as SendUserOder;
          return MaterialPageRoute(
            builder: (context) {
              return UserOrderDetail(userOrder: args.orderList, token: args.token);
            },
          );
        }
        return null;
      },
    );
  }
}
