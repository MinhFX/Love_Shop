import 'package:android/Class/ProductItemImages.dart';
import 'package:android/getAPI/getProductImages.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:android/staticLink/StaticLink.dart' as globals;
import 'package:http/http.dart' as http;

class ProductDetailImage extends StatefulWidget {
  const ProductDetailImage({super.key, required this.product_item_id});

  final int product_item_id;

  @override
  State<ProductDetailImage> createState() => WidgetProductImageDetail();
}

class WidgetProductImageDetail extends State<ProductDetailImage>
{
  late Future<List<ProductItemImages>> futureImages;
  late List<ProductItemImages> images;
  bool futureImagesState = false;
  bool futureImagesStateFail = false;

  @override
  void initState() {
    super.initState();
    futureImages = GetProductItemImages().fetchProductImages(http.Client(), widget.product_item_id);
    futureImages.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value.isNotEmpty) {
              images = value;
              futureImagesState = true;
            }
            else {
              futureImagesStateFail = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (futureImagesState) {
      return BuildProductImageDetail(itemImages: images);
    }
    else if (futureImagesStateFail) {
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

class BuildProductImageDetail extends StatelessWidget {
  const BuildProductImageDetail({super.key, required this.itemImages});

  final List<ProductItemImages> itemImages;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: CarouselSlider(
              items: itemImages.map((e) => ClipRect(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: Image.network(
                      globals.imageLink + e.image,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                ),
              ),
              ).toList(),
              options: CarouselOptions(
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                height: 300,
            ),
          ),
        ),
      ],
    );
  }
}