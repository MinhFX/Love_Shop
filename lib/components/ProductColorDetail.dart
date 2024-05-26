import 'package:android/Class/ProductColor.dart';
import 'package:flutter/material.dart';

class ProductColorDetail extends StatefulWidget {
  const ProductColorDetail({super.key, required this.color, required this.callBackColor});
  final Function(int,String,String,int) callBackColor;
  final List<ProductColor>? color;

  @override
  State<ProductColorDetail> createState() => WidgetProductSizeDetail();
}

class WidgetProductSizeDetail extends State<ProductColorDetail> {
  late int id_color = widget.color![0].id_color;
  late String color_name = widget.color![0].color_name;
  late String image = widget.color![0].image;
  late int product_item_id = widget.color![0].id_product_item;
  int selectedColorIndex = 0;

  void setColor(int index, int proId) {
    if (product_item_id != proId) {
      if (mounted) {
        setState(() {
          product_item_id = proId;
          selectedColorIndex = index;
          widget.callBackColor(product_item_id, widget.color![index].image, widget.color![index].color_name, widget.color![index].id_color);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.callBackColor(product_item_id, widget.color![0].image, widget.color![0].color_name, widget.color![0].id_color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BuildProductColorDetail(setColor: setColor,
        colorIndex: selectedColorIndex,
        color: widget.color);
  }
}

class BuildProductColorDetail extends StatelessWidget {
  const BuildProductColorDetail({super.key, required this.setColor, required this.colorIndex, required this.color});

  final List<ProductColor>? color;
  final Function(int, int) setColor;
  final int colorIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          color!.length,
              (index) => GestureDetector(
            onTap: () {
              setColor(index, color![index].id_product_item);
            },
            child: Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  color: colorIndex == index ? Colors.grey.withOpacity(0.7) : Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    color![index].color_name,
                    style: const TextStyle(
                        fontSize: 17
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}