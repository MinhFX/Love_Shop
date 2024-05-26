import 'dart:convert';

import 'package:android/Class/ProductColor.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetProductColor
{
  List<ProductColor> parseProductColor(String respBody)
  {
    final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<ProductColor>((json) => ProductColor.fromJson(json)).toList();
  }

  Future<List<ProductColor>> fetchProductColor(http.Client client, int id) async {
    final resp = await client.get(
        Uri.parse('https://nightlight.asia/api/productItem-color/$id')
    );
    if (resp.statusCode == 200)
    {
      return compute(parseProductColor, resp.body);
    }
    return throw Exception("Error Load Product_Color.dart");
  }
}