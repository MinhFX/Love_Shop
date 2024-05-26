import 'package:android/Class/ProductCart.dart';
import 'package:android/Class/User.dart';
import 'package:android/components/ItemProductCart.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:android/pages/CheckCart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  const Cart({super.key, required this.callBackSize, required this.callBackCart});

  final Function(int) callBackCart;
  final Function(int) callBackSize;

  @override
  State<Cart> createState() => WidgetCart();
}

class WidgetCart extends State<Cart>
{
  late List<ProductCart> cart;
  late Future<List<ProductCart>> futureCart;

  bool futureCartState = false;
  bool userState = false;
  bool userStateFail = false;
  bool userTokenState = false;
  bool userTokenStateFail = false;
  bool doneUserLoading = false;

  late String? userToken = null;
  late User? user = null;
  late Future<String?>? futureUserToken;
  late Future<User?>? futureUser;
  
  void callBackCart() {
    futureCart = CartManager().getCart();
    futureCart.then((value){
      setState(() {
        cart = value;
        widget.callBackSize(cart.length);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    futureCart = CartManager().getCart();
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
                        doneUserLoading = true;
                      }
                      else {
                        doneUserLoading = true;
                      }
                    });
                  }
                });
              });
            }
            else {
              doneUserLoading = true;
            }
          });
        }
      });
    });
    futureCart.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            cart = value;
            futureCartState = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (futureCartState && doneUserLoading) {
      return BuildCart(cart: cart, refreshCart: callBackCart, userToken: userToken, callBackCart: widget.callBackCart, user: user);
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

class BuildCart extends StatelessWidget {
  const BuildCart({super.key, required this.cart, required this.refreshCart,
    required this.userToken, required this.callBackCart, required this.user});

  final Function(int) callBackCart;
  final List<ProductCart> cart;
  final Function refreshCart;
  final String? userToken;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 246),
      body: SafeArea(
        child: Builder(builder: (context) {
          if (cart.isNotEmpty) {
            return WidgetCartBuild(cart: cart,
                refreshCart: refreshCart,
                userToken: userToken,
                callBackCart: callBackCart,
                user: user);
          }
          else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image.asset(
                        "assets/images/empty-cart.png"
                    ),
                  ),
                  Text(
                    "Giỏ hàng trống",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent
                    ),
                    onPressed: () {
                      callBackCart(2);
                    },
                    child: const Text(
                      "Đến trang mua hàng",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueAccent
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}

class WidgetCartBuild extends StatelessWidget {
  const WidgetCartBuild({super.key, required this.cart, required this.refreshCart,
  required this.userToken, required this.callBackCart, required this.user});

  final Function(int) callBackCart;
  final User? user;
  final String? userToken;
  final Function refreshCart;
  final List<ProductCart> cart;

  String formatMoney(String price)
  {
    int getPrice = int.parse(price);
    var getFormat = NumberFormat.currency(locale: "vi_VN", symbol: "đ");
    String money = getFormat.format(getPrice);
    return money;
  }

  int totalMoney() {
    int total = 0;
    for (ProductCart index in cart) {
      total += (index.price * index.quantity);
    }
    return total + 30000;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
        children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: double.infinity,
                height: 275,
                child: Image.asset(
                  "assets/images/cart.png",
                ),
              ),
            ),
            Container(
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: SizedBox(
                        child: Text(
                          "Giỏ hàng của bạn",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 255, 143, 171),
                          ),
                        ),
                      ),
                    ),

                    for (ProductCart index in cart)
                    ItemProductCart(cartItem: index, refresh: () {
                      refreshCart();
                    }),

                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                            thickness: 1.25,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Phí ship:",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        alignment: Alignment.centerRight,
                                        child: const Text(
                                          "30.000 đ",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 255, 143, 171),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Tổng tiền:",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          formatMoney(totalMoney().toString()),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 255, 143, 171),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                            thickness: 1.25,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                if (userToken != null && user != null) {
                                  Navigator.pushNamed(context, "/CheckCart", arguments: CheckCart(listCart: cart, userToken: userToken!, userEmail: user!.email, userID: user!.id)).then((value){
                                    refreshCart();
                                    if (value != null) {
                                      callBackCart(0);
                                    }
                                  });
                                }
                                else if (userToken == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.redAccent,
                                      content: Center(child: Text('Vui lòng đăng nhập để thanh toán!')),
                                    ),
                                  );
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.redAccent,
                                      content: Center(child: Text('Phiên đăng nhập hết hạn!')),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.grey.withOpacity(0.2),
                                backgroundColor: const Color.fromARGB(255, 255, 143, 171),
                              ),
                              child: Container(
                                width: 300,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Thanh toán",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}