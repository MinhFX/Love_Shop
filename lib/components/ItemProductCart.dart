import 'package:android/Class/ProductCart.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:android/staticLink/StaticLink.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemProductCart extends StatefulWidget {
  const ItemProductCart({super.key, required this.cartItem, required this.refresh});

  final Function refresh;
  final ProductCart cartItem;

  @override
  State<ItemProductCart> createState() => WidgetItemProductCart();
}

class WidgetItemProductCart extends State<ItemProductCart>
{

  String checkQuantity(int number) {
    if (number >= 10) {
      return "$number";
    }
    else {
      return "0$number";
    }
  }

  bool coolDown1 = false;
  bool coolDown = false;

  void setQuantity(bool minus) {
    if (!coolDown1) {
      coolDown1 = true;
      if (minus && widget.cartItem.quantity > 1) {
        setState(() {
          widget.cartItem.quantity -= 1;
          Future<bool> future = CartManager().updateCart(widget.cartItem);
          future.then((value){
            if (mounted) {
              setState(() {
                coolDown1 = false;
                widget.refresh();
              });
            }
          });
        });
      }
      else if (!minus && widget.cartItem.quantity < 99) {
        setState(() {
          widget.cartItem.quantity += 1;
          Future<bool> future = CartManager().updateCart(widget.cartItem);
          future.then((value){
            if (mounted) {
              setState(() {
                coolDown1 = false;
                widget.refresh();
              });
            }
          });
        });
      }
      else {
        coolDown1 = false;
      }
    }
  }

  void removeProductCart() {
    if (!coolDown) {
      coolDown = true;
      Future<bool> future = CartManager().removeFromCart(widget.cartItem);
      future.then((value){
        if (value) {
          setState(() {
            coolDown = false;
            widget.refresh();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return BuildItemProductCart(cart: widget.cartItem, removeCart: removeProductCart, quantity: checkQuantity(widget.cartItem.quantity), setQuantity: setQuantity);
  }
}

class BuildItemProductCart extends StatelessWidget {
  const BuildItemProductCart({super.key, required this.cart, required this.removeCart, required this.quantity,
  required this.setQuantity});

  final Function(bool) setQuantity;
  final String quantity;
  final Function removeCart;
  final ProductCart cart;

  String formatMoney(String price)
  {
    int getPrice = int.parse(price);
    var getFormat = NumberFormat.currency(locale: "vi_VN", symbol: "đ");
    String money = getFormat.format(getPrice);
    return money;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 244, 246),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                //Images
                Container(
                  height: 110,
                  width: 110,
                  margin: const EdgeInsets.only(right: 5),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:  Image.network(
                      "$imageLink${cart.image}",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                //Information
                Container(
                  height: 110,
                  width: 250,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Text(
                            cart.product_name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Size: ",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.7)
                              ),
                            ),
                            Text(
                              cart.size_name,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ", Color: ",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.7)
                              ),
                            ),
                            Text(
                              cart.color_name,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formatMoney(cart.price.toString()),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 143, 171),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox (
              height: 110,
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      removeCart();
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),

                  Row(
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
                            size: 17,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      Text(
                        quantity,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400
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
                            size: 17,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}