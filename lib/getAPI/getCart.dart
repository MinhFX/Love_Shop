import 'dart:convert';

import 'package:android/Class/ProductCart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static const String _keyCart = 'cart';

  Future<void> saveCart(List<ProductCart> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = cart.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList(_keyCart, productsJson);
  }

  Future<List<ProductCart>> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_keyCart) ?? [];
    return productsJson.map((json) => ProductCart.fromJson(jsonDecode(json))).toList();
  }

  Future<bool> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyCart);
  }

  Future<bool> addToCart(ProductCart product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_keyCart) ?? [];


    bool productExists = false;
    for (int i = 0; i < productsJson.length; i++) {
      ProductCart existingProduct = ProductCart.fromJson(jsonDecode(productsJson[i]));
      if (existingProduct.id_pro_item == product.id_pro_item && existingProduct.id_size == product.id_size) {
        existingProduct.quantity += product.quantity;
        productsJson[i] = jsonEncode(existingProduct.toJson());
        productExists = true;
        break;
      }
    }

    if (!productExists) {
      productsJson.add(jsonEncode(product.toJson()));
    }

    return await prefs.setStringList(_keyCart, productsJson);
  }

  Future<bool> updateCart(ProductCart product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_keyCart) ?? [];
    List<ProductCart> listProducts = productsJson.map((json) => ProductCart.fromJson(jsonDecode(json))).toList();
    int index = listProducts.indexWhere((item) => item.id_pro_item == product.id_pro_item && item.id_size == product.id_size);
    if (index != -1) {
      listProducts[index] = product;
    }
    else {
      return false;
    }
    List<String> updatedProductsJson = listProducts.map((product) => jsonEncode(product.toJson())).toList();
    return await prefs.setStringList(_keyCart, updatedProductsJson);
  }

  Future<bool> removeFromCart(ProductCart product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> productsJson = prefs.getStringList(_keyCart) ?? [];

    productsJson.removeWhere((json) {
      ProductCart existingProduct = ProductCart.fromJson(jsonDecode(json));
      return existingProduct.id_pro_item == product.id_pro_item && existingProduct.id_size == product.id_size;
    });

    return await prefs.setStringList(_keyCart, productsJson);
  }
}