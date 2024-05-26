import 'dart:async';

import 'package:android/Class/ProductCart.dart';
import 'package:android/Class/ProductColor.dart';
import 'package:android/Class/ProductMenu.dart';
import 'package:android/components/ProductColorDetail.dart';
import 'package:android/components/ProductDetailImage.dart';
import 'package:android/components/ProductSizeDetail.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:android/getAPI/getProductColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.product});
  final ProductMenu product;

  @override
  State<ProductDetail> createState() => WidgetProductDetail();
}

class WidgetProductDetail extends State<ProductDetail>
{
  late int id_color;
  late String image;
  late int id_for_order;
  late String color_name;
  late String size_name;
  late int price;
  late int id_size;
  late int in_stock = 0;
  bool checking = false;
  bool pressCart = false;
  bool futureBuild = false;
  bool futureBuildFail = false;
  int? product_item_id;

  late final Future<List<ProductColor>> futureColor;
  List<ProductColor>? getColor;
  String quantity = "01";
  int quantityNumber = 1;

  void addCart() {
    if (in_stock > 0 && !checking) {
      int stock = in_stock;
      if (stock > 0) {
        if (!pressCart) {
          pressCart = true;

          //print("id_pro: ${int.parse(widget.product.id_pro)}, id_pro_id: ${product_item_id!}, id_size: $id_size, "
          //"id_color: $id_color, quantity: $quantityNumber, color_name: $color_name, size_name: $size_name, price: ${widget.product.discount_price}");

          ProductCart product = ProductCart(
              id_pro: widget.product.id_pro,
              id_pro_item: product_item_id!,
              id_size: id_size,
              id_color: id_color,
              product_name: widget.product.product_name,
              quantity: quantityNumber,
              color_name: color_name,
              size_name: size_name,
              id_for_order: id_for_order,
              image: image,
              price: widget.product.discount_price < widget.product.price ? widget.product.discount_price : widget.product.price
          );
          Future<bool> fut = CartManager().addToCart(product);
          fut.then((value){
            if (value) {
              pressCart = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color.fromARGB(255, 255, 143, 171),
                  duration: Duration(seconds: 2),
                  content: Center(
                    child: Text(
                      'Đã thêm vào giỏ hàng!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }
          });
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.yellowAccent,
            duration: Duration(seconds: 2),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                ),
                Text(
                  'Sản phẩm đã hết hàng.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  String checkQuantity(int num) {
    if (num >= 10) {
      return "$num";
    }
    else {
      return "0$num";
    }
  }

  void setQuantity(bool minus) {
    if (mounted) {
      setState(() {
        if (minus && quantityNumber > 1) {
          quantityNumber -= 1;
          quantity = checkQuantity(quantityNumber);
        }
        else if (!minus && quantityNumber < 99) {
          quantityNumber += 1;
          quantity = checkQuantity(quantityNumber);
        }
      });
    }
  }

  void setSize(int id_size, String size_name, int in_stock, int id_for_order) {
    checking = true;
    this.id_size = id_size;
    this.size_name = size_name;
    this.id_for_order = id_for_order;
    if (mounted) {
      setState(() {
        checking = false;
        this.in_stock = in_stock;
      });
    }
  }

  void setProItemId(int value, String image, String color_name, int id_color) {
    this.image = image;
    this.color_name = color_name;
    this.id_color = id_color;
    if (mounted) {
      setState(() {
        product_item_id = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    futureColor = GetProductColor().fetchProductColor(http.Client(), widget.product.id_pro);
    futureColor.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value.isNotEmpty) {
              product_item_id = value[0].id_product_item;
              getColor = value;
              futureBuild = true;
            }
            else {
              futureBuildFail = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (futureBuild) {
      return BuildProductDetail(product: widget.product, pro_item_id: product_item_id, setProItemId: setProItemId,
          color: getColor, setQuantity: setQuantity, productQuantity: quantity, setSize: setSize, addCart: addCart,
          in_stock: in_stock);
    }
    else if (futureBuildFail) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  "assets/images/empty.jpg"
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

class BuildProductDetail extends StatelessWidget {
  const BuildProductDetail({super.key, required this.product, required this.pro_item_id, required this.setProItemId, required this.color,
  required this.setQuantity, required this.productQuantity, required this.setSize, required this.addCart, required this.in_stock});
  final ProductMenu product;
  final String productQuantity;
  final int in_stock;
  final int? pro_item_id;
  final List<ProductColor>? color;
  final Function addCart;
  final Function(bool) setQuantity;
  final Function(int, String, int, int) setSize;
  final Function(int, String, String, int) setProItemId;

  String calculatePercentDis(String price, String discountPrice)
  {
    int getPrice = int.parse(price);
    int getDisPrice = int.parse(discountPrice);
    double percent = 100 - ((getDisPrice/getPrice)*100);
    return percent.round().toString();
  }

  String formatMoney(String price)
  {
    int getPrice = int.parse(price);
    var getFormat = NumberFormat.currency(locale: "vi_VN", symbol: "đ");
    String money = getFormat.format(getPrice);
    return money;
  }

  @override
  Widget build(BuildContext context) {
    int disPrice = product.discount_price;
    int price = product.price;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 244, 246),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(product.product_name),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          ProductDetailImage(product_item_id: product.id_pro),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 6,
                  blurRadius: 5,
                )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.product_name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Builder(
                      builder: (context) {
                        if (disPrice < price)
                        {
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      formatMoney(product.discount_price.toString()),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Color.fromARGB(255, 255, 143, 171),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  RichText(
                                    text: TextSpan(
                                      text: formatMoney(product.price.toString()),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            )
                          );
                        }
                        else
                        {
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      formatMoney(product.price.toString()),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Color.fromARGB(255, 255, 143, 171),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  Builder(
                    builder: (context) {
                      if (price - disPrice > 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                children: [
                                  const Text(
                                    "Tiết kiệm: ",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54
                                    ),
                                  ),
                                  Text(
                                    formatMoney((price - disPrice).toString()),
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 255, 143, 171),
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: SizedBox(),
                        );
                      }
                    },
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 244, 246),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.1),
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        product.description,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      in_stock == 0 ? "..." : "Số lượng: $in_stock cái",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Color:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ProductColorDetail(color: color, callBackColor: (int productItemsId, String image, String color_name, int id_color){
                    setProItemId(productItemsId, image, color_name, id_color);
                  }),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "Size:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),


                  ProductSizeDetail(pro_item_id: pro_item_id, callBackSize: (int id_size, String size_name, int in_stock, int id_for_order){
                    setSize(id_size, size_name, in_stock, id_for_order);
                  })

                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 6,
              blurRadius: 5,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomAppBar(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: 170,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setQuantity(true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Icon(
                              CupertinoIcons.minus,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          child: Text(
                            productQuantity,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setQuantity(false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Icon(
                              CupertinoIcons.plus,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    addCart();
                  },
                  icon: const Icon(
                    CupertinoIcons.cart_badge_plus,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Add to cart",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 143, 171),
                    foregroundColor: const Color.fromARGB(200, 255, 214, 223),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}