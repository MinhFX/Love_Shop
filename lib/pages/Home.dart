import 'package:android/Class/ProductCart.dart';
import 'package:android/components/Categories.dart';
import 'package:android/components/MostSellProduct.dart';
import 'package:android/components/NewProduct.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.voidCallback, required this.getSearch, required this.voidCallBack1,
  required this.refresh});
  final Function(int) voidCallback;
  final Function(String) getSearch;
  final Function(int) refresh;
  final Function(int) voidCallBack1;

  @override
  State<Home> createState() => WidgetHome();
}

class WidgetHome extends State<Home> {

  late int cartSize = 0;
  late Future<List<ProductCart>> futureCart;
  bool futureCartState = false;

  List<String> imageList = [
    "https://risingtheme.com/html/demo-suruchi-v1/suruchi/assets/img/slider/home1-slider1.png",
    "https://risingtheme.com/html/demo-suruchi-v1/suruchi/assets/img/slider/home1-slider2.png",
    "https://risingtheme.com/html/demo-suruchi-v1/suruchi/assets/img/slider/home1-slider3.png"
  ];

  int imageIndex = 0;

  void setCartSize(int number) {
    if (cartSize != number) {
      if (mounted) {
        setState(() {
          cartSize = number;
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
            cartSize = value.length;
            futureCartState = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.refresh(value.length);
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.sort,
                          size: 30,
                          color: Color.fromARGB(255, 79, 99, 107),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Love Shop",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        widget.voidCallBack1(1);
                      },
                      child: badges.Badge(
                        badgeContent: Text(
                          cartSize.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Color.fromARGB(255, 79, 99, 107),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 244, 246),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                  ),
                ),
                child: Column(
                  children: [

                    //Search bar
                    Container(
                      width: size.width,
                      margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
                      padding: EdgeInsets.only(left: size.width * 0.025),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 244, 246),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: size.width * 0.005,
                          color: const Color.fromARGB(255, 255, 143, 171),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.765,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              onFieldSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  widget.getSearch(value);
                                }
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Tìm kiếm..."
                              ),
                              textInputAction: TextInputAction.search,
                            ),
                          ),

                          SizedBox(
                            width: size.width * 0.1,
                            child: const Icon(
                              Icons.search,
                              size: 27,
                              color: Color.fromARGB(255, 79, 99, 107),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Slide images
                    Column(
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.only(top: 20),
                          child: CarouselSlider(
                            items: imageList.map((e) => ClipRect(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      e,
                                      height: 200,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 200,
                                    child: Builder(
                                      builder: (context) {
                                        if (e == imageList[1])
                                        {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/12),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text(
                                                        "Chương trình khuyến mãi",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),

                                                      const Text(
                                                        "Giảm đến 10%",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color: Color.fromARGB(255, 255, 143, 171),
                                                        ),
                                                      ),

                                                      TextButton(
                                                        onPressed: () {
                                                          widget.voidCallBack1(2);
                                                        },
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: const Color.fromARGB(255, 255, 143, 171),
                                                        ),
                                                        child: const Text(
                                                          "Mua ngay",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color.fromARGB(255, 255, 143, 171),
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        else if (e == imageList[2])
                                        {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text(
                                                        "Ưu đãi đặc biệt dành cho",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),

                                                      const Text(
                                                        "Các cặp đôi",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color: Color.fromARGB(255, 255, 143, 171),
                                                        ),
                                                      ),

                                                      TextButton(
                                                        onPressed: () {
                                                          widget.voidCallBack1(2);
                                                        },
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: const Color.fromARGB(255, 255, 143, 171),
                                                        ),
                                                        child: const Text(
                                                          "Mua ngay",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color.fromARGB(255, 255, 143, 171),
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        else
                                        {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/12),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Text(
                                                        "Đồ siêu rẻ",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),

                                                      const Text(
                                                        "Nhanh tay hốt lẹ",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),

                                                      TextButton(
                                                        onPressed: () {
                                                          widget.voidCallBack1(2);
                                                        },
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: const Color.fromARGB(255, 255, 143, 171),
                                                        ),
                                                        child: const Text(
                                                          "Mua ngay",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color.fromARGB(255, 255, 143, 171),
                                                          ),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                ],
                              ),
                            )).toList(),
                            options: CarouselOptions(
                              autoPlay: true,
                              enableInfiniteScroll: true,
                              enlargeCenterPage: true,
                              height: 180,
                              onPageChanged: (index, reason){
                                if (mounted) {
                                  setState(() {
                                    imageIndex = index;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        AnimatedSmoothIndicator(
                          activeIndex: imageIndex,
                          count: imageList.length,
                          effect: const SlideEffect(
                            activeDotColor: Color.fromARGB(255, 255, 143, 171),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                        top: 20,
                        left: 15,
                      ),

                      child: const Text(
                        "Danh mục",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 143, 171),
                        ),
                      ),
                    ),

                    //Categories
                    Categories(voidCallback: (int number){
                      widget.voidCallback(number);
                    },),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          top: 20,
                          left: 15
                      ),

                      child: const Text(
                        "Sản phẩm mới",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 143, 171),
                        ),
                      ),
                    ),

                    //New Product
                    NewProduct(refresh: (int refresh){
                      setCartSize(refresh);
                      widget.refresh(refresh);
                    }),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          top: 20,
                          left: 15
                      ),

                      child: const Text(
                        "Sản phẩm bán chạy",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 143, 171),
                        ),
                      ),
                    ),

                    //Most Sell Product
                    MostSellProduct(refresh: (int refresh){
                      setCartSize(refresh);
                      widget.refresh(refresh);
                    }),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}