import 'dart:convert';

import 'package:android/Class/ProductMenu.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetProduct
{
  List<ProductMenu> parseProduct(String respBody)
  {
    final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<ProductMenu>((json) => ProductMenu.fromJson(json)).toList();
  }


  Future<List<ProductMenu>> fetchProduct(http.Client client) async {
    final resp = await client.get(
        Uri.parse('https://nightlight.asia/api/product')
    );
    if (resp.statusCode == 200)
    {
      return compute(parseProduct, resp.body);
    }
    return throw Exception("Error Load Product_Detail.dart");
  }
}