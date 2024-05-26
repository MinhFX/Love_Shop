import 'package:android/Class/CategoriesProduct.dart';
import 'package:android/getAPI/getCategories.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Categories extends StatefulWidget{
  const Categories({super.key, required this.voidCallback});
  final Function(int) voidCallback;

  @override
  State<Categories> createState() => WidgetCategories();
}

// Check Data
class WidgetCategories extends State<Categories>
{
  late List<CategoriesProduct> categories;
  late Future<List<CategoriesProduct>> futureCategories;
  bool futureCategoriesStateFail = false;
  bool futureCategoriesState = false;

  @override
  void initState() {
    super.initState();
    futureCategories = GetCategories().fetchCategories(http.Client());
    futureCategories.then((value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (value.isNotEmpty) {
              categories = value;
              futureCategoriesState = true;
            }
            else {
              futureCategoriesStateFail = true;
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (futureCategoriesState) {
      List<CategoriesProduct> getAvailableCategories = categories.where((v) => (v.status == 1) == true).toList();
      return BuildWidget(categories: getAvailableCategories, onSelect: widget.voidCallback);
    }
    else if (futureCategoriesStateFail) {
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

//Build Widget
class BuildWidget extends StatelessWidget
{
  const BuildWidget({super.key, required this.categories, required this.onSelect});

  final List<CategoriesProduct> categories;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context){

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (CategoriesProduct index in categories)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    onSelect(index.id);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Color.fromARGB(255, 255, 184, 201),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            spreadRadius: 0.2
                        )
                      ],
                    ),
                    child: Image.asset(
                      "assets/icons/clothes.png",
                    ),
                  ),
                ),

                SizedBox(
                  width: 135,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        index.category_name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}