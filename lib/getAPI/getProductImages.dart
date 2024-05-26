import 'dart:convert';

import 'package:android/Class/ProductItemImages.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GetProductItemImages
{
  List<ProductItemImages> parseProductImages(String respBody)
  {
    final parsed = (jsonDecode(respBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<ProductItemImages>((json) => ProductItemImages.fromJson(json)).toList();
  }

  Future<List<ProductItemImages>> fetchProductImages(http.Client client, int id) async {
    final resp = await client.get(
        Uri.parse('https://nightlight.asia/api/product-galleries/$id')
    );
    if (resp.statusCode == 200)
    {
      return compute(parseProductImages, resp.body);
    }
    return throw Exception("Error Load Product_Detail.dart");
  }
}