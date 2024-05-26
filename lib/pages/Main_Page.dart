import 'package:android/Class/ProductCart.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:android/pages/Cart.dart';
import 'package:android/pages/Home.dart';
import 'package:android/pages/Profile.dart';
import 'package:android/pages/News.dart';
import 'package:android/pages/Product.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => WidgetBuild();
}

class WidgetBuild extends State<MainPage> {

  late Future<List<ProductCart>> futureCart;
  late int sizeCart = 0;
  int counter = 0;
  bool futureCartState = false;

  int pageIndex = 0;
  int intCate = 0;
  bool pressCate = false;
  String getSearch = "";

  void getTapNavBar(int index)
  {
    if (mounted) {
      setState(() {
        if (index <= 5 - 1)
        {
          pageIndex = index;
        }
      });
    }
  }

  void setSizeCart(int sizeCart) {
    if (sizeCart != this.sizeCart) {
      if (mounted) {
        setState(() {
          this.sizeCart = sizeCart;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    futureCart = CartManager().getCart();
    futureCart.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            sizeCart = value.length;
            futureCartState = true;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (pageIndex == 0) {
            return Home(voidCallback: (int number){
              intCate = number;
              pressCate = true;
              getTapNavBar(2);
            }, getSearch: (String search) {
              getSearch = search;
              getTapNavBar(2);
            }, voidCallBack1: (int num) {
              getTapNavBar(num);
            }, refresh: (int sizeCart){
              setSizeCart(sizeCart);
            });
          }
          else if (pageIndex == 1) {
            return Cart(callBackSize: (int sizeCart){
              setSizeCart(sizeCart);
            }, callBackCart: (int num) {
              getTapNavBar(num);
            });
          }
          else if (pageIndex == 2) {
            int temp = 0;
            if (pressCate)
            {
              pressCate = false;
              temp = intCate;
              intCate = 0;
            }
            if (getSearch.isNotEmpty) {
              String temp1 = getSearch;
              getSearch = "";
              return Product(intCate: temp, search: temp1, refresh: (int refresh) {
                setSizeCart(refresh);
              });
            }
            else {
              return Product(intCate: temp, refresh: (int refresh) {
                setSizeCart(refresh);
              });
            }
          }
          else if (pageIndex == 3) {
            return const News();
          }
          else if (pageIndex == 4) {
            return const Profile();
          }
          else {
            throw Exception();
          }
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 143, 171),
        items: <BottomNavigationBarItem> [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text(
                sizeCart.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              child: const Icon(
                Icons.shopping_cart,
                size: 30,
              ),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outlined,
              size: 30,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper_outlined,
              size: 30,
            ),
            label: 'News',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        onTap: getTapNavBar,
      ),
    );
  }
}