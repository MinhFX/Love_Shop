import 'package:android/Class/ProductMenu.dart';
import 'package:android/components/ProductMenuLayout.dart';
import 'package:android/getAPI/getProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewProduct extends StatefulWidget {
  const NewProduct({super.key, required this.refresh});

  final Function(int) refresh;

  @override
  State<NewProduct> createState() => WidgetNewProduct();
}

class WidgetNewProduct extends State<NewProduct>
{
  late List<ProductMenu> productMenu;
  late Future<List<ProductMenu>> futureProductMenu;
  bool futureProductMenuState = false;
  bool futureProductMenuStateFail = false;

  @override
  void initState() {
    super.initState();
    futureProductMenu = GetProduct().fetchProduct(http.Client());
    futureProductMenu.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value.isNotEmpty) {
              productMenu = value;
              futureProductMenuState = true;
            }
            else {
              futureProductMenuStateFail = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (futureProductMenuState) {
      List<ProductMenu> getAvailableNewProduct = productMenu.where((v) => (v.status == 1) == true).toList();
      return BuildNewProductWidget(newProduct: getAvailableNewProduct, refresh: widget.refresh);
    }
    else if (futureProductMenuStateFail) {
      return const Text(
        "There is nothing here...",
        style: TextStyle(
          fontSize: 25,
          color: Colors.grey,
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

class BuildNewProductWidget extends StatelessWidget
{
  const BuildNewProductWidget({super.key, required this.newProduct, required this.refresh});

  final List<ProductMenu> newProduct;
  final Function(int) refresh;

  @override
  Widget build(BuildContext context){

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 130) / 2;
    final double itemWidth = size.width / 2;

    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 10, right: 10),
      children: [
        for (ProductMenu index in newProduct.reversed.take(4))
          ProductMenuLayout(index: index, refresh: (int refresh){
            this.refresh(refresh);
          })
      ],
    );
  }
}