import 'dart:convert';

import 'package:android/Class/ProductSize.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetProductSize
{
  List<ProductSize> parseProductSize(String respBody)
  {
    final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<ProductSize>((json) => ProductSize.fromJson(json)).toList();
  }

  Future<List<ProductSize>> fetchProductSize(http.Client client, int id) async {
    final resp = await client.get(
        Uri.parse('https://nightlight.asia/api/productItem-size/$id')
    );
    if (resp.statusCode == 200)
    {
      return compute(parseProductSize, resp.body);
    }
    return throw Exception("Error Load Product_Size.dart");
  }
}