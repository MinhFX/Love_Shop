import 'package:android/Class/Order.dart';
import 'package:android/Class/OrderItemDetail.dart';
import 'package:android/getAPI/getOrder.dart';
import 'package:android/staticLink/OrderStatus.dart';
import 'package:android/staticLink/StaticLink.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserOrderDetail extends StatefulWidget {
  const UserOrderDetail({super.key, required this.userOrder, required this.token});

  final UserOrderList userOrder;
  final String token;

  @override
  State<UserOrderDetail> createState() => WidgetUserOrderDetail();
}

class WidgetUserOrderDetail extends State<UserOrderDetail> {

  late Future<List<OrderItemDetail>?> getUserOrderDetail;
  late List<OrderItemDetail> orderItem;
  bool orderItemStateFail = false;
  bool orderItemState = false;

  @override
  void initState() {
    super.initState();
    getUserOrderDetail = GetOrder().getOrderDetails(widget.token, widget.userOrder.id);
    getUserOrderDetail.then((value){
      setState(() {
        if (value != null) {
          orderItem = value;
          orderItemState = true;
        }
        else {
          orderItemStateFail = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (orderItemState) {
      return BuildUserOrderDetail(orderItem: orderItem, userOrderList: widget.userOrder);
    }
    else if (orderItemStateFail) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            content: Center(child: Text('Lỗi đơn hàng!')),
          ),
        );
      });
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/empty.jpg",
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

class BuildUserOrderDetail extends StatelessWidget {
  const BuildUserOrderDetail({super.key, required this.orderItem, required this.userOrderList});

  final UserOrderList userOrderList;
  final List<OrderItemDetail> orderItem;
  static int shippingCost = 30000;

  int totalMoney() {
    int total = 0;
    for (OrderItemDetail index in orderItem) {
      total += (index.price * index.quantity);
    }
    return total;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          "Đơn hàng #${userOrderList.id}",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5)
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Tình trạng đơn hàng",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "ID:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "#${userOrderList.id.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Trạng thái:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              OrderStatus().checkStatus(userOrderList.status.toString()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: OrderStatus().colorStatus(userOrderList.status.toString()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Ngày đặt hàng:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                DateTime dateTime = DateTime.parse(userOrderList.date_order);
                                return Text(
                                  "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Thời gian đặt hàng:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              userOrderList.time_order,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
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

            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5)
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Thông tin giao hàng",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Tên người nhận:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              userOrderList.full_name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Số điện thoại:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "0${userOrderList.phone}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Địa chỉ:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              userOrderList.address,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Ghi chú:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              userOrderList.note != null ? userOrderList.note.toString() : "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
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

            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5)
                  ),
                ),
                child: Column(
                  children: [

                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Giỏ hàng của bạn",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Divider(),

                    for (OrderItemDetail cart in orderItem)
                      Container(
                        alignment: Alignment.centerLeft,
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
                        margin: const EdgeInsets.only(top: 15),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
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
                                width: MediaQuery.of(context).size.width - 110,
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
                                            fontSize: 19,
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
                                      Row(
                                        children: [
                                          Text(
                                            "Số lượng: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                          Text(
                                            cart.quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
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
                      ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Tổng phụ",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          formatMoney(totalMoney().toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Ship",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          "30.000 đ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Giảm",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          formatMoney(((userOrderList.total_amount - shippingCost) - totalMoney()).toString()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Tổng hóa đơn",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          formatMoney(userOrderList.total_amount.toString()),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}