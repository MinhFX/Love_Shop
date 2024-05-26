import 'package:android/Class/CategoriesProduct.dart';
import 'package:android/components/ProductWithCategories.dart';
import 'package:android/getAPI/getCategories.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {
  const Product({super.key, required this.intCate, this.search, required this.refresh});
  final int intCate;
  final String? search;
  final Function(int) refresh;

  @override
  State<Product> createState() => WidgetProduct();
}

class WidgetProduct extends State<Product> with TickerProviderStateMixin
{
  late List<CategoriesProduct> categories;
  late Future<List<CategoriesProduct>> futureCategories;
  late TabController tabController;
  late int currentIndex = widget.intCate;
  late String? getHomeSearch = widget.search;
  late List<CategoriesProduct> getAvailableCategories;
  bool searching = false;
  bool futureCategoriesState = false;
  bool futureCategoriesStateFail = false;
  String search = "";

  void getCheckIndex(int getIndex) {
    if (getIndex != currentIndex) {
      refresh(getIndex);
    }
  }

  void checkTabChange() {
    int? getIndex = (tabController.indexIsChanging) ? tabController.index : tabController.animation?.value.round();
    getCheckIndex(getIndex!);
  }

  void refreshFuture() {
    futureCategoriesState = false;
    futureCategoriesStateFail = false;
    futureCategories = GetCategories().fetchCategories(http.Client());
    futureCategories.then((value){
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
  }

  void refresh(int index)
  {
    if (mounted) {
      setState(() {
        getHomeSearch = null;
        searching = false;
        search = "";
        currentIndex = index;
      });
    }
  }

  void findSearch(String getSearch)
  {
    if (mounted) {
      setState(() {
        getHomeSearch = null;
        searching = true;
        search = getSearch;
      });
    }
  }

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
              getAvailableCategories = categories.where((v) => (v.status == 1) == true).toList();
              tabController = TabController(length: getAvailableCategories.length + 1, vsync: this, initialIndex: (searching) ? tabController.index : currentIndex);
              tabController.animation?.addListener(checkTabChange);
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
    var s = getHomeSearch;
    if (futureCategoriesState) {
      if (s != null) {
        return BuildProduct(categories: getAvailableCategories, intCate: currentIndex,
            tabController: tabController, findSearch: findSearch, searchString: s, getCheckIndex: getCheckIndex,
            refresh: widget.refresh);
      }
      else {
        return BuildProduct(categories: getAvailableCategories, intCate: (searching) ? tabController.index : currentIndex,
            tabController: tabController, findSearch: findSearch, searchString: search, getCheckIndex: getCheckIndex,
            refresh: widget.refresh);
      }
    }
    else if (futureCategoriesStateFail) {
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
      return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.black38,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
    }
  }
}

class BuildProduct extends StatelessWidget {
  const BuildProduct({super.key, required this.categories, required this.intCate,
    required this.tabController, required this.findSearch,
    required this.searchString, required this.getCheckIndex,
    required this.refresh});

  final Function(int) refresh;
  final int intCate;
  final List<CategoriesProduct> categories;
  final TabController tabController;
  final Function(String) findSearch;
  final String searchString;
  final Function(int) getCheckIndex;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool inner) {
            return <Widget> [

              SliverToBoxAdapter(
                  child: SafeArea(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            'https://risingtheme.com/html/demo-suruchi-v1/suruchi/assets/img/banner/banner2.png',
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: size.width/2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 35,
                                margin: EdgeInsets.only(left: size.width/12, right: size.width/12),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "LOVE",
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                                          color: Color.fromARGB(255, 255, 143, 171)
                                      ),
                                    ),
                                    Text(
                                      "SHOP",
                                      style: TextStyle(
                                          fontSize: 50,
                                          fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                                          color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                width: 300,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Cửa hàng thời trang",
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                                        ),
                                      ),
                                      Text(
                                        "cho các cặp đôi",
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ),

              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  automaticallyImplyLeading: false,
                  leadingWidth: size.width,
                  toolbarHeight: 160,
                  flexibleSpace: Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        //Title
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: 5),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Danh Mục",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'RobotoCondensed-VariableFont_wght.ttf'
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Search Bar
                        Container(
                          width: size.width,
                          margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
                          padding: EdgeInsets.only(left: size.width * 0.025),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 244, 246),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: size.width * 0.005,
                              color: const Color.fromARGB(255, 255, 143, 171),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.764,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Tìm kiếm..."
                                  ),
                                  onFieldSubmitted: (value) {
                                    findSearch(value);
                                  },
                                  textInputAction: TextInputAction.search,
                                ),
                              ),

                              SizedBox(
                                width: size.width * 0.1,
                                child: const Icon(
                                  Icons.search,
                                  size: 27,
                                  color: Color.fromARGB(255, 79, 99, 107),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child:
                    //Tab
                    TabBar(
                      isScrollable: true,
                      labelColor: const Color.fromARGB(255, 255, 143, 171),
                      indicatorColor: const Color.fromARGB(255, 255, 143, 171),
                      overlayColor: MaterialStateProperty.all<Color>(const Color.fromARGB(30, 255, 143, 171)),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: tabController,
                      onTap: (index) {
                        getCheckIndex(index);
                      },
                      labelStyle: const TextStyle(
                        fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                      ),
                      tabAlignment: TabAlignment.start,
                      tabs: [

                        const SizedBox(
                          width: 150,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              text: 'Tất cả',
                            ),
                          ),
                        ),

                        for (CategoriesProduct index in categories)
                          SizedBox(
                            width: 150,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Tab(
                                text: index.category_name,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ),

            ];
          },
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 160),
                //Product
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Builder(
                        builder: (context) {
                          if (searchString.isEmpty) {
                            return ProductWithCategories(idProCate: 'all', refresh: (int refresh){
                              this.refresh(refresh);
                            });
                          }
                          else {
                            if (intCate == 0) {
                              return ProductWithCategories(idProCate: 'all', search: searchString, refresh: (int refresh){
                                this.refresh(refresh);
                              });
                            }
                            return ProductWithCategories(idProCate: 'all', refresh: (int refresh){
                              this.refresh(refresh);
                            });
                          }
                        },
                      ),

                      for (CategoriesProduct index in categories)
                        Builder(
                          builder: (context) {
                            if (searchString.isEmpty) {
                              return ProductWithCategories(idProCate: '${index.id}', refresh: (int refresh){
                                this.refresh(refresh);
                              });
                            } else {
                              if (intCate == index.id) {
                                return ProductWithCategories(idProCate: '${index.id}', search: searchString, refresh: (int refresh){
                                  this.refresh(refresh);
                                });
                              }
                              return ProductWithCategories(idProCate: '${index.id}', refresh: (int refresh){
                                this.refresh(refresh);
                              });
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}