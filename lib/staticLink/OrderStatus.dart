import 'package:flutter/material.dart';

class OrderStatus {
  String checkStatus(String status) {
    if (status == "0") {
      return "Đã hủy";
    }
    else if (status == "1") {
      return "Chờ duyệt";
    }
    else if (status == "2") {
      return "Đang xử lỷ";
    }
    else {
      return "Đã giao";
    }
  }

  Color colorStatus(String status) {
    if (status == "0") {
      return const Color.fromARGB(255, 255, 0, 0);
    }
    else if (status == "1") {
      return const Color.fromARGB(255, 255, 196, 0);
    }
    else if (status == "2") {
      return const Color.fromARGB(255, 56, 85, 255);
    }
    else {
      return const Color.fromARGB(255, 51, 204, 51);
    }
  }
}