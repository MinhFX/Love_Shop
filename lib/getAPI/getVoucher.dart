import 'dart:convert';

import 'package:http/http.dart' as http;

class GetVoucher {
  Future<Map<String, dynamic>?> checkVoucer(String code, String totalAmount, String token) async {

    List<Map<String, dynamic>> listVoucher = [];

    Map<String, dynamic> voucherData = {
      'voucher_code': code,
      'total_amount': totalAmount,
    };

    listVoucher.add(voucherData);

    final jsonData = jsonEncode(listVoucher);

    final resp = await http.post(
        Uri.parse('https://nightlight.asia/api/vouchers-check'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonData
    );

    if (resp.statusCode == 200) {
      var readJson = (jsonDecode(resp.body) as Map<String, dynamic>);
      return readJson;
    }
    else {
      return null;
    }
  }
}