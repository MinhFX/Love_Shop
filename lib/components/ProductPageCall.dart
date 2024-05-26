import 'package:android/Class/ProductMenu.dart';
import 'package:android/components/ProductMenuLayout.dart';
import 'package:flutter/material.dart';

class ProductPageCall extends StatefulWidget {
  const ProductPageCall({super.key, required this.product, required this.currentPage, required this.limitProduct, required this.refresh});

  final Function(int) refresh;
  final List<ProductMenu> product;
  final int currentPage;
  final int limitProduct;

  @override
  State<ProductPageCall> createState() => WidgetProductCallPage();
}

class WidgetProductCallPage extends State<ProductPageCall>
{
  @override
  Widget build(BuildContext context){
    List<ProductMenu> getListProduct = widget.product.reversed.toList();
    return BuildProductCallPage(product: getListProduct.toList(), currentPage: widget.currentPage, limitProduct: widget.limitProduct,
    refresh: widget.refresh);
  }
}

class BuildProductCallPage extends StatelessWidget
{
  const BuildProductCallPage({super.key, required this.product, required this.currentPage, required this.limitProduct,
  required this.refresh});

  final Function(int) refresh;
  final List<ProductMenu> product;
  final int currentPage;
  final int limitProduct;

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
        for (ProductMenu index in product.sublist(currentPage * limitProduct).take(limitProduct))
          ProductMenuLayout(index: index, refresh: (int refresh) {
            this.refresh(refresh);
          })
      ],
    );
  }
}