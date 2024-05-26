import 'package:android/Class/User.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => WidgetMenu();
}

class WidgetMenu extends State<Profile>
{
  late String userToken;
  late User user;
  late Future<String?>? futureUserToken;
  late Future<User?>? futureUser;

  bool userState = false;
  bool userStateFail = false;
  bool userTokenState = false;
  bool userTokenStateFail = false;
  bool logOut = false;

  void getLogout() {
    GetUserToken().removeUserToken().then((value){
      if (mounted) {
        setState(() {
          userState = false;
          userTokenState = false;
          userStateFail = false;
          userTokenStateFail = false;
          logOut = value;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Color.fromARGB(255, 255, 143, 171),
              content: Center(child: Text('Đăng xuất thành công!')),
            ),
          );
        });
      }
    });
  }

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
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (userTokenState && userState) {
      return BuildWidgetProfile(user: user,
          logOut: getLogout,
          refresh: refresh,
          userToken: userToken);
    }
    else if (userTokenStateFail || userStateFail || logOut) {
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
      else if (logOut) {
        logOut = false;
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/unknow.png",
                width: 200,
                height: 200,
              ),

              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "Bạn chưa đăng nhập?",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 143, 171),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/Login").then((value){
                    if (value != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Color.fromARGB(255, 255, 143, 171),
                          content: Center(child: Text('Đăng nhập thành công!')),
                        ),
                      );
                      refresh();
                    }
                  });
                },
                child: const Text(
                  "Đăng nhập ngay!",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
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

class BuildWidgetProfile extends StatelessWidget {
  const BuildWidgetProfile({super.key, required this.user, required this.logOut, required this.refresh,
  required this.userToken});

  final String userToken;
  final Function refresh;
  final Function logOut;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 180, 143, 171),
            Color.fromARGB(255, 255, 143, 170),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: null,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Tài khoản",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: SizedBox(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/default_avatar.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.25),
                        blurRadius: 6,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/UpdateProfile",
                            ).then((_){
                              refresh();
                            });
                          },
                          child: const ListTile(
                            leading: Icon(
                              Icons.settings,
                              size: 50,
                            ),
                            title: Text(
                              "Tài khoản",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Text(
                              "Họ tên, điện thoại, ngày sinh, địa chỉ,...",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/UserOrder",
                              arguments: userToken
                            ).then((_){
                              refresh();
                            });
                          },
                          child: const ListTile(
                            leading: Icon(
                              Icons.card_travel,
                              size: 50,
                            ),
                            title: Text(
                              "Lịch sử đặt hàng của bạn",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              "Xem lại những đơn hàng đã đặt của bạn",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),

                      const Divider(),

                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 5),
                        child: TextButton(
                          onPressed: () {
                            logOut();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent.withOpacity(0.5),
                          ),
                          child: const Text(
                            "Đăng xuất",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}