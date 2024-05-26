import 'dart:convert';

import 'package:android/Class/Order.dart';
import 'package:android/Class/OrderItemDetail.dart';
import 'package:android/Class/ProductCart.dart';
import 'package:android/Class/User.dart';
import 'package:android/getAPI/getCart.dart';
import 'package:android/getAPI/getUserToken.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class GetOrder
{
  Future<bool?> callOrder(String id, String full_name, String email, String phone, String address, String note, String totalAmount, String payment_method, int? id_voucher) async {
    Future<List<ProductCart>> cart = CartManager().getCart();
    Future<String?> token = GetUserToken().getUserToken();
    String? stringToken = await token;
    List<ProductCart> cartList = await cart;
    if (stringToken != null) {
      Future<User?> user = GetUserToken().getProfile(stringToken);
      User? getUser = await user;

      if (getUser != null) {
        List<Map<String, dynamic>> listCartItem = [];

        Map<String, dynamic> order = {
          "id_customer": id,
          "full_name": full_name,
          "phone": phone,
          "email": email,
          "address": address,
          "note": note,
          "total_amount": totalAmount,
          "date_order": null,
          "time_order": null,
          "canceled_at": null,
          "delivery_at": null,
          "payment_method": payment_method,
          "id_voucher": id_voucher,
          "status": 1,
          "id_user": null
        };

        listCartItem.add(order);

        for (ProductCart v in cartList) {
          Map<String, dynamic> cartItemJson = {
            'id_for_order': v.id_for_order,
            'price': v.price,
            'quantity': v.quantity.toString(),
          };
          listCartItem.add(cartItemJson);
        }

        final jsonData = jsonEncode(listCartItem);

        final resp = await http.post(
            Uri.parse('https://nightlight.asia/api/order'),
            headers: <String, String> {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization' : 'Bearer $stringToken'
            },
            body: jsonData
        );

        print(jsonData);

        if (resp.statusCode == 200) {
          await CartManager().clearCart();
          return true;
        }
        else {
          Fluttertoast.showToast(
            msg: "Lỗi đặt hàng!",
            toastLength: Toast.LENGTH_SHORT,
          );
          return null;
        }
      }
      else {
        Fluttertoast.showToast(
          msg: "Phiên đăng nhập hết hạn!\nVui lòng đăng nhập lại.",
          toastLength: Toast.LENGTH_SHORT,
        );
        return null;
      }
    }
    else {
      Fluttertoast.showToast(
        msg: "Vui lòng đăng nhập để đặt hàng.",
        toastLength: Toast.LENGTH_SHORT,
      );
      return null;
    }
  }

  List<OrderItemDetail>? parseOrderDetails(String respBody)
  {
    try {
      final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
      return parsed.map<OrderItemDetail>((json) => OrderItemDetail.fromJson(json)).toList();
    }
    catch (e) {
      return null;
    }
  }

  Future<List<OrderItemDetail>?> getOrderDetails(String stringToken, int id_order) async {
    List<Map<String, dynamic>> jsonData = [<String, dynamic> {'id_order' : id_order}];
    final resp = await http.post(
      Uri.parse('https://nightlight.asia/api/order-details'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'Bearer $stringToken'
      },
      body: jsonEncode(jsonData),
    );
    if (resp.statusCode == 200)
    {
      return compute(parseOrderDetails, resp.body);
    }
    else {
      return null;
    }
  }

  List<UserOrderList>? parseUserOrder(String respBody)
  {
    try {
      final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
      return parsed.map<UserOrderList>((json) => UserOrderList.fromJson(json)).toList();
    }
    catch (e) {
      return null;
    }
  }

  Future<List<UserOrderList>?> fetchUserOrder(http.Client client, String stringToken) async {
    final resp = await client.post(
      Uri.parse('https://nightlight.asia/api/order-list'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'Bearer $stringToken'
      },
    );
    if (resp.statusCode == 200)
    {
      return compute(parseUserOrder, resp.body);
    }
    else {
      return null;
    }
  }
}