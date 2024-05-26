import 'package:android/Class/ProductMenu.dart';
import 'package:android/components/ProductPageCall.dart';
import 'package:android/getAPI/getProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_paginator/number_paginator.dart';
import 'package:remove_diacritic/remove_diacritic.dart';

class ProductWithCategories extends StatefulWidget {
  ProductWithCategories({super.key, required this.idProCate, this.search, required this.refresh});

  final Function(int) refresh;
  final String idProCate;
  final String? search;
  late int currentPage = 0;
  late bool reset = false;

  @override
  State<ProductWithCategories> createState() => WidgetProductWithCategories();
}

class WidgetProductWithCategories extends State<ProductWithCategories>
{
  late String? search = widget.search;
  late Future<List<ProductMenu>> futureProduct;
  late List<ProductMenu> product;
  bool futureProductState = false;
  bool futureProductStateFail = false;
  final NumberPaginatorController pageController = NumberPaginatorController();
  int limitProduct = 10;

  void setPage(int index)
  {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState((){
          widget.currentPage = index;
        });
      }
    });
  }

  void refreshProduct() {
    futureProductState = false;
    futureProductStateFail = false;
    futureProduct = GetProduct().fetchProduct(http.Client());
    futureProduct.then((value){
      if (mounted) {
        setState(() {
          if (value.isNotEmpty) {
            product = value;
            futureProductState = true;
          }
          else {
            futureProductStateFail = true;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refreshProduct();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    var s = widget.search;
    if (futureProductState) {
      if (search != widget.search) {
        search = widget.search;
        refreshProduct();
        return const SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.black38,
              strokeCap: StrokeCap.round,
            ),
          ),
        );
      }
      else {
        if (s != null) {
          if (widget.idProCate != 'all') {
            product = product.where((v) => (v.status == 1 &&
                v.id_pro_category.toString() == widget.idProCate &&
                removeDiacritics(v.product_name.toLowerCase()).contains(
                    removeDiacritics(s.toLowerCase()))) == true).toList();
          }
          else {
            product = product.where((v) => (v.status == 1 &&
                removeDiacritics(v.product_name.toLowerCase()).contains(
                    removeDiacritics(s.toLowerCase()))) == true).toList();
          }
          int totalPage = (product.length / limitProduct).ceil();
          if (!widget.reset) {
            widget.reset = true;
            pageController.currentPage = widget.currentPage;
          }
          return BuildProductWithCategories(product: product,
              callback: setPage,
              currentPage: widget.currentPage,
              limitProduct: limitProduct,
              totalPage: totalPage,
              getSearch: s,
              pageController: pageController,
              refresh: widget.refresh);
        }
        else {
          if (widget.idProCate != 'all') {
            product = product.where((v) => (v.status == 1 &&
                v.id_pro_category.toString() == widget.idProCate) == true).toList();
          }
          else {
            product =
                product.where((v) => (v.status == 1) == true).toList();
          }
          int totalPage = (product.length / limitProduct).ceil();
          return BuildProductWithCategories(product: product,
              callback: setPage,
              currentPage: widget.currentPage,
              limitProduct: limitProduct,
              totalPage: totalPage,
              pageController: pageController,
              refresh: widget.refresh);
        }
      }
    }
    else if (futureProductStateFail) {
      return Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              children: [
                Image.asset(
                    "assets/images/empty.jpg"
                ),
                const Text(
                  "There is nothing here...",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    else {
      return const SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black38,
            strokeCap: StrokeCap.round,
          ),
        ),
      );
    }
  }
}

class BuildProductWithCategories extends StatelessWidget
{
  const BuildProductWithCategories({super.key, required this.product, required this.callback, required this.currentPage
  , required this.limitProduct, required this.totalPage, this.getSearch, required this.pageController, required this.refresh});

  final Function(int) refresh;
  final List<ProductMenu> product;
  final Function(int) callback;
  final int currentPage;
  final int limitProduct;
  final int totalPage;
  final String? getSearch;
  final NumberPaginatorController pageController;

  @override
  Widget build(BuildContext context){
    var s = getSearch;
    return Container(
      color: const Color.fromARGB(255, 243, 244, 246),
      child: Builder (
        builder: (context) {
          if (product.isNotEmpty) {
            return ListView(
              children: [
                //Show Search Result
                Builder(
                  builder: (context) {
                    if (s != null) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: Text(
                          "Kết quả tìm kiếm: '$s'",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }
                ),

                //Show Product
                ProductPageCall(product: product, currentPage: currentPage, limitProduct: limitProduct, refresh: (int refresh){
                  this.refresh(refresh);
                }),

                //Page
                Builder(
                  builder: (context) {
                    if (product.length > limitProduct) {
                      return Container(
                        color: Colors.white,
                        child: NumberPaginator(
                          controller: pageController,
                          initialPage: currentPage,
                          numberPages: (totalPage >= 1) ? totalPage : 1,
                          onPageChange: (index) {
                            callback(index);
                          },
                          config: const NumberPaginatorUIConfig(
                            buttonUnselectedForegroundColor: Colors.black,
                            buttonSelectedForegroundColor: Colors.white,
                            buttonSelectedBackgroundColor: Color.fromARGB(255, 255, 143, 171),
                          ),
                        ),
                      );
                    }
                    else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            );
          }
          else {
            //Empty view
            return Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Column(
                    children: [

                      //Show Search Result
                      Builder(
                          builder: (context) {
                            if (s != null) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                padding: const EdgeInsets.only(left: 20, top: 15),
                                child: Text(
                                  "Kết quả tìm kiếm: '$s'",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          }
                      ),

                      Image.asset(
                        "assets/images/empty.jpg"
                      ),
                      const Text(
                        "There is nothing here...",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              )
            );
          }
        },
      ),
    );
  }
}