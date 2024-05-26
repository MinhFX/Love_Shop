import 'package:android/Class/ProductCart.dart';
import 'package:android/Class/ProductMenu.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:android/staticLink/StaticLink.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductMenuLayout extends StatefulWidget {
  const ProductMenuLayout({super.key, required this.index, required this.refresh});

  final Function(int) refresh;
  final ProductMenu index;

  @override
  State<ProductMenuLayout> createState() => WidgetProductMenuLayout();
}

class WidgetProductMenuLayout extends State<ProductMenuLayout>
{

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
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/ProductDetail",
          arguments: widget.index,
        ).then((_){
          Future<List<ProductCart>> futureCart = CartManager().getCart();
          futureCart.then((value){
            if (mounted) {
              setState(() {
                widget.refresh(value.length);
              });
            }
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        int disPrice = widget.index.discount_price;
                        int price = widget.index.price;
                        if (disPrice < price) {
                          return Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            margin: const EdgeInsets.only(left: 5, bottom: 5),
                            height: 25,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 255, 143, 190),
                            ),
                            child: Text(
                              '-${calculatePercentDis(widget.index.price.toString(), widget.index.discount_price.toString())}%',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          );
                        }
                        else {
                          return Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            margin: const EdgeInsets.only(left: 5, bottom: 5),
                            height: 25,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              Container(
                width: 180,
                margin: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    globals.imageLink + widget.index.image,
                    height: 180,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              Container(
                width: 180,
                padding: const EdgeInsets.only(left: 5, right: 5),
                margin: const EdgeInsets.only(left: 5, top: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.index.product_name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 255, 143, 171),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                width: 180,
                padding: const EdgeInsets.only(left: 5, right: 5),
                margin: const EdgeInsets.only(left: 5, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.index.description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),

              Container(
                width: 180,
                margin: const EdgeInsets.only(left: 5),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Builder(
                        builder: (context) {
                          int disPrice = widget.index.discount_price;
                          int price = widget.index.price;
                          if (disPrice < price)
                          {
                            return SizedBox(
                              height: 50,
                              width: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: RichText(
                                          text: TextSpan(
                                            text: formatMoney(widget.index.price.toString()),
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.lineThrough,
                                                decorationThickness: 2
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 140,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          formatMoney(widget.index.discount_price.toString()),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Color.fromARGB(255, 255, 143, 171),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          else
                          {
                            return SizedBox(
                              height: 50,
                              width: 140,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    formatMoney(widget.index.price.toString()),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 255, 143, 171),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      const Icon(
                        Icons.add_shopping_cart,
                        size: 28,
                      ),
                    ],
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