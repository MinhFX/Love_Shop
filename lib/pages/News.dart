import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => WidgetNews();
}

class WidgetNews extends State<News> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.withOpacity(0.3),
        surfaceTintColor: Colors.grey.withOpacity(0.3),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tin Tức",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
              ),
            ),

            Row(
              children: [
                Text(
                  "Love",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                      color: Color.fromARGB(255, 255, 143, 171),
                  ),
                ),
                Text(
                  " Shop",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "RobotoCondensed-VariableFont_wght.ttf",
                      color: Colors.white
                  ),
                ),
              ],
            )
          ],
        )
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Tin tức nóng",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                      ),
                    ),
                  ),
                ],
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i = 1; i <= 5; i++)
                      Container(
                        width: 230,
                        height: 285,
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 220,
                              height: 160,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  child: Image.network(
                                    "https://www.aljazeera.com/wp-content/uploads/2022/01/shops.jpg?resize=770%2C513&quality=80",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 220,
                              height: 45,
                              margin: const EdgeInsets.all(2),
                              child: const Text(
                                "TIN SỐC GIẢM GIÁ CỰC CĂNG CHỈ CẦN MUA 2 CÁI ÁO GIÁ 200K MỘT CÁI",
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(2),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("23-03-2024"),
                                  Text("18:03:22"),
                                ],
                              ),
                            ),
                            const SizedBox(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 13,
                                    backgroundColor: Color.fromARGB(150, 255, 143, 171),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "Trí Minh",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Tin tức hôm nay",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  for (int i = 1; i <= 5; i++)
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 170,
                            height: 140,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                child: Image.network(
                                  "https://www.aljazeera.com/wp-content/uploads/2022/01/shops.jpg?resize=770%2C513&quality=80",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            height: 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 45,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12, right: 10),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 13,
                                          backgroundColor: Color.fromARGB(150, 255, 143, 171),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "Trí Minh",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12, right: 10, bottom: 5),
                                    child: Text(
                                      "TIN SỐC GIẢM GIÁ CỰC CĂNG CHỈ CẦN MUA 2 CÁI ÁO GIÁ 200K MỘT CÁI",
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 45,
                                  padding: const EdgeInsets.only(left: 12, right: 10),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("23-03-2024"),
                                      Text("18:03:22"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}