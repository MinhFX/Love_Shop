import 'package:android/Class/Order.dart';
import 'package:android/Class/SendUserOrder.dart';
import 'package:android/getAPI/getOrder.dart';
import 'package:android/staticLink/OrderStatus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserOrderListItem extends StatefulWidget {
  const UserOrderListItem({super.key, required this.tabIndex, required this.userToken});

  final String userToken;
  final int tabIndex;

  @override
  State<UserOrderListItem> createState() => WidgetUserOrderListItem();
}

class WidgetUserOrderListItem extends State<UserOrderListItem> {

  late int currentTabIndex = widget.tabIndex;
  late Future<List<UserOrderList>?>? futureUserOrder;
  late List<UserOrderList>? orderList;
  bool doneLoading = false;
  bool errorLoading = false;
  bool isEmpty = false;
  bool message = false;

  @override
  void initState() {
    super.initState();
    futureUserOrder = GetOrder().fetchUserOrder(http.Client(), widget.userToken);
    futureUserOrder?.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value != null) {
              orderList = value;
              doneLoading = true;
            }
            else {
              errorLoading = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (doneLoading) {
      orderList = orderList!.where((v) => (v.status == currentTabIndex)).toList();
      return BuildUserOrderListItem(orderList: orderList!.reversed.toList(), token: widget.userToken);
    }
    else if (errorLoading) {
      if (!message) {
        message = true;
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
      return Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
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
          ],
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

class BuildUserOrderListItem extends StatelessWidget {
  const BuildUserOrderListItem({super.key, required this.orderList, required this.token});

  final List<UserOrderList> orderList;
  final String token;

  String formatMoney(String price)
  {
    int getPrice = int.parse(price);
    var getFormat = NumberFormat.currency(locale: "vi_VN", symbol: "đ");
    String money = getFormat.format(getPrice);
    return money;
  }

  @override
  Widget build(BuildContext context) {
    if (orderList.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (UserOrderList order in orderList)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.local_shipping,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Trạng thái",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    OrderStatus().checkStatus(order.status.toString()),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: OrderStatus().colorStatus(order.status.toString()),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                SendUserOder sendUser = SendUserOder(orderList: order, token: token);
                                Navigator.pushNamed(
                                  context,
                                  "/UserOrderDetail",
                                  arguments: sendUser,
                                );
                              },
                              child: const Icon(
                                Icons.chevron_right,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.date_range,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Ngày đặt hàng",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      DateTime dateTime = DateTime.parse(order.date_order);
                                      return Text(
                                        "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.access_time,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Thời gian đặt hàng",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    order.time_order,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.tag,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "ID Đơn hàng",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "[#${order.id}]",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.monetization_on_outlined,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tổng tiền",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  formatMoney(order.total_amount.toString()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
    else {
      return Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
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
          ],
        ),
      );
    }
  }
}