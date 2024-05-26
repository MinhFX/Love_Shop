import 'package:android/Class/ProductMenu.dart';
import 'package:android/components/ProductSmallMenuLayout.dart';
import 'package:android/getAPI/getProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MostSellProduct extends StatefulWidget {
  const MostSellProduct({super.key, required this.refresh});

  final Function(int) refresh;

  @override
  State<MostSellProduct> createState() => WidgetMostSellProduct();
}

class WidgetMostSellProduct extends State<MostSellProduct>
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
      List<ProductMenu> getAvailableMostSellPro = productMenu.where((v) => (v.status == 1) == true).toList();
      return BuildMostSellProductWidget(mostSellPro: getAvailableMostSellPro, refresh: widget.refresh);
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

class BuildMostSellProductWidget extends StatelessWidget {
  const BuildMostSellProductWidget({super.key, required this.mostSellPro, required this.refresh});

  final List<ProductMenu> mostSellPro;
  final Function(int) refresh;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
          for (ProductMenu index in mostSellPro)
            ProductSmallMenuLayout(index: index, refresh: (int refresh){
              this.refresh(refresh);
            })
          ]
        ),
      ),
    );
  }
}