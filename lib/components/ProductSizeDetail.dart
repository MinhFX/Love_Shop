import 'package:android/Class/ProductSize.dart';
import 'package:android/getAPI/getProductSize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductSizeDetail extends StatefulWidget {
  const ProductSizeDetail({super.key, required this.pro_item_id, required this.callBackSize});
  
  final Function(int, String, int, int) callBackSize;
  final int? pro_item_id;

  @override
  State<ProductSizeDetail> createState() => WidgetProductSizeDetail();
}

class WidgetProductSizeDetail extends State<ProductSizeDetail>
{
  late List<ProductSize> size;
  late Future<List<ProductSize>> futureSize;
  int selectedSizeIndex = 0;
  late String size_name;
  late int id_size;
  late int? pro_item_id = widget.pro_item_id;

  bool futureSizeState = false;
  bool futureSizeStateFail = false;

  void setSize(int index) {
    if (selectedSizeIndex != index) {
      if (mounted) {
        setState(() {
          selectedSizeIndex = index;
          widget.callBackSize(size[index].id_size, size[index].size_name, size[index].in_stock, size[index].id);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    futureSize = futureSize = GetProductSize().fetchProductSize(http.Client(), widget.pro_item_id!);
    futureSize.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value.isNotEmpty) {
              size = value;
              WidgetsBinding.instance.addPostFrameCallback((_){
                widget.callBackSize(size[0].id_size, size[0].size_name, size[0].in_stock, size[0].id);
              });
              futureSizeState = true;
            }
            else {
              futureSizeStateFail = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (futureSizeState) {
      if (pro_item_id != widget.pro_item_id) {
        futureSizeState = false;
        futureSizeStateFail = false;
        pro_item_id = widget.pro_item_id;
        selectedSizeIndex = 0;
        futureSize = GetProductSize().fetchProductSize(http.Client(), widget.pro_item_id!);
        futureSize.then((value){
          if (mounted) {
            setState(() {
              if (value.isNotEmpty) {
                size = value;
                widget.callBackSize(size[0].id_size, size[0].size_name, size[0].in_stock, size[0].id);
                futureSizeState = true;
              }
              else {
                futureSizeStateFail = true;
              }
            });
          }
        });
        if (futureSizeState) {
          return BuildProductSizeDetail(setSize: setSize, sizeIndex: selectedSizeIndex, size: size);
        }
        else if (futureSizeStateFail) {
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
            height: 50,
            width: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black38,
                strokeCap: StrokeCap.round,
              ),
            ),
          );
        }
      }
      else {
        return BuildProductSizeDetail(setSize: setSize, sizeIndex: selectedSizeIndex, size: size);
      }
    }
    else if (futureSizeStateFail) {
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
        height: 50,
        width: 200,
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

class BuildProductSizeDetail extends StatelessWidget {
  const BuildProductSizeDetail({super.key, required this.setSize, required this.sizeIndex, required this.size});
  final Function(int) setSize;
  final int sizeIndex;
  final List<ProductSize> size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(size.length, (index) => GestureDetector(
            onTap: () {
              setSize(index);
            },
            child: Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  color: sizeIndex == index ? Colors.grey.withOpacity(0.7) : Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    size[index].size_name,
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