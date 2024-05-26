import 'dart:convert';

import 'package:android/Class/CategoriesProduct.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetCategories
{
  List<CategoriesProduct> parseListCategories(String respBody)
  {
    final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<CategoriesProduct>((json) => CategoriesProduct.fromJson(json)).toList();
  }

  Future<List<CategoriesProduct>> fetchCategories(http.Client client) async {
    final resp = await client.get(
        Uri.parse('https://nightlight.asia/api/categories-product')
    );
    if (resp.statusCode == 200)
    {
      return compute(parseListCategories, resp.body);
    }
    return throw Exception("Error Load Categories");
  }
}