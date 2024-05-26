
import 'package:android/Class/ProductCart.dart';
import 'package:android/getAPI/getOrder.dart';
import 'package:android/getAPI/getVoucher.dart';
import 'package:android/staticLink/StaticLink.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckCart extends StatefulWidget {
  const CheckCart({super.key, required this.listCart, required this.userToken, required this.userID,
  required this.userEmail});

  final String userEmail;
  final int userID;
  final String userToken;
  final List<ProductCart> listCart;

  @override
  State<CheckCart> createState() => WidgetCheckCart();
}

enum paymentMethod {cash, card}
const int shippingCost = 30000;

class WidgetCheckCart extends State<CheckCart>
{
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();
  final voucherController = TextEditingController();

  bool pressOrder = false;
  bool buySuccess = false;

  late int? voucherID = null;
  late String paymentMethodString = "Cash";
  late String? totalMoneyAfterVoucher = null;
  late String? discountMoneyAfterVoucher = null;

  bool acceptVoucher = false;
  bool checkVoucher = false;
  bool checkVoucherStateFail = false;

  paymentMethod? character = paymentMethod.cash;

  int totalMoney() {
    int total = 0;
    for (ProductCart index in widget.listCart) {
      total += index.price * index.quantity;
    }
    return total;
  }

  void checkVoucherCode() {
    if (voucherController.text.isEmpty) {
      if (acceptVoucher) {
        if (mounted) {
          setState(() {
            acceptVoucher = false;
          });
        }
      }
      else if (checkVoucherStateFail) {
        if (mounted) {
          setState(() {
            checkVoucherStateFail = false;
          });
        }
      }
    }
    else {
      if (!checkVoucher) {
        if (mounted) {
          setState(() {
            acceptVoucher = false;
            checkVoucherStateFail = false;
          });
        }
        checkVoucher = true;
        Future<Map<String, dynamic>?> future = GetVoucher().checkVoucer(voucherController.text, (totalMoney()).toString(), widget.userToken);
        future.then((value){
          if (mounted) {
            setState(() {
              if (value != null) {
                if (value['message'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.redAccent,
                      content: Center(child: Text(value['message'].toString())),
                    ),
                  );
                  totalMoneyAfterVoucher = null;
                  discountMoneyAfterVoucher = null;
                  voucherID = null;
                  checkVoucherStateFail = true;
                  checkVoucher = false;
                }
                else {
                  totalMoneyAfterVoucher = value['total_amount'].toString();
                  discountMoneyAfterVoucher = value['value_discount'].toString();
                  voucherID = value['id'];
                  acceptVoucher = true;
                  checkVoucher = false;
                }
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.redAccent,
                    content: Center(child: Text('Lỗi Voucher!')),
                  ),
                );
                totalMoneyAfterVoucher = null;
                discountMoneyAfterVoucher = null;
                voucherID = null;
                checkVoucherStateFail = true;
                checkVoucher = false;
              }
            });
          }
        });
      }
    }
  }

  void callOrder() {
    if (!pressOrder) {
      setState(() {
        pressOrder = true;
      });
      Future<bool?> future = GetOrder().callOrder(widget.userID.toString(),
          fullNameController.text, widget.userEmail, phoneController.text,
          addressController.text, noteController.text,
          ((totalMoneyAfterVoucher != null ? (int.parse(totalMoneyAfterVoucher!)) : totalMoney()) + shippingCost).toString(), paymentMethodString, voucherID);
      future.then((value){
        if (mounted) {
          setState(() {
            if (value != null) {
              buySuccess = true;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 3),
                  backgroundColor: Color.fromARGB(255, 255, 143, 171),
                  content: Center(child: Text('Đặt hàng thành công!')),
                ),
              );
            }
            else {
              pressOrder = false;
            }
          });
        }
      });
    }
  }

  void setPaymentMethod(paymentMethod? value) {
    if (mounted) {
      setState(() {
        character = value;
        if (value == paymentMethod.cash) {
          paymentMethodString = "Cash";
        }
        else {
          paymentMethodString = "Card";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!buySuccess) {
      return BuildCheckCart(listCart: widget.listCart, character: character, setPaymentMethod: setPaymentMethod,
        fullNameController: fullNameController, phoneController: phoneController,
        addressController: addressController, noteController: noteController,
        voucherController: voucherController, callOrder: callOrder, totalMoneyAfterVoucher: totalMoneyAfterVoucher,
        discountMoneyAfterVoucher: discountMoneyAfterVoucher, checkVoucherCode: checkVoucherCode,
        acceptVoucher: acceptVoucher, checkVoucherStateFail: checkVoucherStateFail, pressOrder: pressOrder);
    }
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/thank_you_for_order.png",
                height: 300,
              ),
            ),
            const Text(
              "Cảm ơn khách hàng đã mua tại",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "LOVE",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 255, 143, 171),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  " SHOP",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                "Quay lại",
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class BuildCheckCart extends StatelessWidget {
  const BuildCheckCart({super.key, required this.listCart, required this.character,
  required this.setPaymentMethod, required this.fullNameController,
  required this.phoneController, required this.addressController,
  required this.noteController, required this.voucherController,
  required this.callOrder, required this.totalMoneyAfterVoucher,
  required this.discountMoneyAfterVoucher, required this.checkVoucherCode,
  required this.acceptVoucher, required this.checkVoucherStateFail,
  required this.pressOrder});

  final bool pressOrder;
  final bool checkVoucherStateFail;
  final bool acceptVoucher;
  final String? totalMoneyAfterVoucher;
  final String? discountMoneyAfterVoucher;
  final fullNameController;
  final phoneController;
  final addressController;
  final noteController;
  final voucherController;

  final Function callOrder;
  final Function checkVoucherCode;

  final paymentMethod? character;
  final List<ProductCart> listCart;
  final Function(paymentMethod?) setPaymentMethod;

  int totalMoney() {
    int total = 0;
    for (ProductCart index in listCart) {
      total += index.price * index.quantity;
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

  String? validatePhone(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Vui lòng nhập số điện thoại.';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Vui lòng nhập số điện thoại hợp lệ.';
    }
    return null;
  }

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "Chi tiết đơn hàng",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: 40,
                child: const Text(
                  "Giỏ hàng của bạn",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(15),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5)
                    ),
                  ),
                  child: Column(
                    children: [
                      for (ProductCart cart in listCart)
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
                          margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                                              "${cart.quantity}",
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

              Builder(
                builder: (context){
                  if (checkVoucherStateFail) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.redAccent,
                          ),
                          Text(
                            "Voucher không hợp lệ",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    );
                  }
                  else if (acceptVoucher) {
                    return const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                            ),
                            Text(
                              "Voucher hợp lệ",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                    );
                  }
                  else {
                    return const SizedBox();
                  }
                },
              ),

              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: voucherController,
                        cursorColor: Colors.black,
                        cursorErrorColor: Colors.redAccent,
                        decoration: const InputDecoration(
                          hintText: 'Có mã voucher? Hãy nhập vào đây.',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black.withOpacity(0.6),
                          backgroundColor: Colors.grey.withOpacity(0.1),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        onPressed: () {
                          checkVoucherCode();
                        },
                        child: const Text(
                          'Nhập',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
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
                            discountMoneyAfterVoucher != null ? "-${formatMoney(discountMoneyAfterVoucher!)}" : "0 đ",
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
                            formatMoney(((totalMoneyAfterVoucher != null ? int.parse(totalMoneyAfterVoucher!) : totalMoney()) + shippingCost).toString()),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
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
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Phương thức thanh toán",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio<paymentMethod>(
                                    activeColor: Colors.black,
                                    value: paymentMethod.cash,
                                    groupValue: character,
                                    onChanged: (paymentMethod? value) {
                                      setPaymentMethod(value);
                                    },
                                  ),
                                  const Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Tiền mặt',
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        Icon(
                                          Icons.attach_money,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio<paymentMethod>(
                                    activeColor: Colors.black,
                                    value: paymentMethod.card,
                                    groupValue: character,
                                    onChanged: (paymentMethod? value) {
                                      setPaymentMethod(value);
                                    },
                                  ),
                                  const Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          'Trả thẻ',
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        Icon(
                                          Icons.credit_card,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.all(5),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Thông tin giao hàng",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập họ tên.';
                                }
                                return null;
                              },
                              controller: fullNameController,
                              cursorColor: Colors.black,
                              cursorErrorColor: Colors.redAccent,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                hintText: "Họ và tên người nhận",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              validator: (value) {
                                return validatePhone(value!);
                              },
                              controller: phoneController,
                              cursorColor: Colors.black,
                              cursorErrorColor: Colors.redAccent,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Số điện thoại (+84)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập địa chỉ giao hàng.';
                                }
                                return null;
                              },
                              controller: addressController,
                              cursorColor: Colors.black,
                              cursorErrorColor: Colors.redAccent,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                hintText: "Địa chỉ",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Ghi chú",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              cursorErrorColor: Colors.redAccent,
                              controller: noteController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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

              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      callOrder();
                    }
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Đặt hàng",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (pressOrder) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                width: 35,
                                height: 35,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.black38,
                                  strokeCap: StrokeCap.round,
                                ),
                              );
                            }
                            else {
                              return const SizedBox();
                            }
                          }
                        ),
                      ],
                    ),
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