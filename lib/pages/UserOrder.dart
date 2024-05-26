import 'package:android/components/UserOrderListItem.dart';
import 'package:flutter/material.dart';

class UserOrder extends StatefulWidget {
  const UserOrder({super.key, required this.userToken});

  final String userToken;

  @override
  State<UserOrder> createState() => WidgetUserOrder();
}

class WidgetUserOrder extends State<UserOrder> with TickerProviderStateMixin {

  late final TabController tabController;

  int tabIndex = 0;

  void checkTabChange() {
    int? getIndex = (tabController.indexIsChanging) ? tabController.index : tabController.animation?.value.round();
    changeTabIndex(getIndex!);
  }

  void changeTabIndex(int index) {
    if (index != tabIndex) {
      setState(() {
        tabIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this, initialIndex: tabIndex);
    tabController.animation?.addListener(checkTabChange);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BuildUserOrder(tabController: tabController, changeIndexTab: changeTabIndex, userToken: widget.userToken,
    tabIndex: tabIndex);
  }
}

class BuildUserOrder extends StatelessWidget {
  const BuildUserOrder({super.key, required this.tabController, required this.changeIndexTab,
  required this.userToken, required this.tabIndex});

  final TabController tabController;
  final Function(int) changeIndexTab;
  final int tabIndex;
  final String userToken;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          "Lịch sử đặt hàng",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool inner) {
            return <Widget> [

              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  automaticallyImplyLeading: false,
                  leadingWidth: size.width,
                  toolbarHeight: 50,
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
                        changeIndexTab(index);
                      },
                      labelStyle: const TextStyle(
                        fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                      ),
                      tabAlignment: TabAlignment.start,
                      tabs: const [
                        SizedBox(
                          width: 150,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              text: "Đã hủy",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              text: "Chờ duyệt",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              text: "Đang xử lý",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              text: "Đã giao",
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
                const SizedBox(height: 50),
                //Product
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [

                      for (int i = 0; i < tabController.length; i++)
                        Builder(
                          builder: (context) {
                            return UserOrderListItem(tabIndex: i, userToken: userToken);
                          }
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