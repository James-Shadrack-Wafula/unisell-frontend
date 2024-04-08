import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uispeed_grocery_shop/model/food.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/detail_page.dart';
import 'package:uispeed_grocery_shop/page/login.dart';
import 'package:uispeed_grocery_shop/page/my_collection.dart';
import 'package:uispeed_grocery_shop/page/my_product.dart';
import 'package:http/http.dart' as http;
import 'package:uispeed_grocery_shop/page/profile.dart';

// class Product {
//   final int id;
//   final String productName;
//   final double productPrice;
//   final int productStars;
//   final int productUnits;
//   final String productImage;

//   Product({
//     required this.id,
//     required this.productName,
//     required this.productPrice,
//     required this.productStars,
//     required this.productUnits,
//     required this.productImage,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       productName: json['product_name'],
//       productPrice: json['product_price'].toDouble(),
//       productStars: json['product_stars'],
//       productUnits: json['product_units'],
//       productImage: json['product_image'],
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexCategory = 0;

  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(
        '${DimConstants.ip}/products/')); // Replace with your API URL
        // 'http://192.168.255.11:8000/products/')); // Replace with your API URL

    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  bool isLoading = false;
  List<Product> products = [];

   Future<void> refreshCallfetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('${DimConstants.ip}/products/'));
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        setState(() {
          products = list.map((model) => Product.fromJson(model)).toList();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> ft() async {
    final response = await http.get(Uri.parse(
        '${DimConstants.ip}/products/')); // Replace with your API URL
        // 'http://192.168.255.11:8000/products/')); // Replace with your API URL

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  final List<Widget> _screens = [
    HomePage(),
    MyProduct(),
    // Collection(),
    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    int length = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   selectedItemColor: Colors.green,
      //   unselectedItemColor: Colors.green[200],
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
      //     BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Cart'),
      //     // BottomNavigationBarItem(
      //     //     icon: Icon(Icons.notifications), label: 'Notification'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Favorite'),
      //   ],
      // ),

      body: RefreshIndicator(
        onRefresh: refreshCallfetchData,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            header(),
            const SizedBox(height: 30),
            title(),
            const SizedBox(height: 20),
            search(),
            const SizedBox(height: 30),
            categories(),
            const SizedBox(height: 20),
            // gridFood(),
            // FutureBuilder<List<Product>>(
            SingleChildScrollView(
              child: FutureBuilder(
                future: fetchProducts(),
                // future: ft(),
                builder: ((context, snapshot) {
                  futureProducts.then((products) {
                    length = products.length;
                    print('Length of products list: $length');
                  });
                  print('snapshot:${snapshot}');
                  // (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return gridFood2(length);
                    // return ListView.builder(
                    //   itemCount: snapshot.data!.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     Product product = snapshot.data![index];
                    //     return ListTile(
                    //       title: Text(product.productName),
                    //       subtitle: Text(
                    //           'Price: \$${product.productPrice.toStringAsFixed(2)}'),
                    //       // You can add more details here if needed
                    //     );
                    //   },
                    // );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Material(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyProduct();
                }));
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.menu, color: Colors.black),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.location_on, color: Colors.green, size: 18),
          const Text('Maseno, Main Campus'),
          const Spacer(),
          GestureDetector(
            onTap: () async{
              bool isLoggedIn = await AuthService.isLoggedIn2();
              if(isLoggedIn){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyProduct();
              }));

              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context){ return LoginPage();}));
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              // child: Image.asset(
              //   'asset/salad.webp',
              //   fit: BoxFit.cover,
              //   width: 40,
              //   height: 40,
              // ),
              child: Icon(Icons.sell, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Hi Jimmy',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          Text(
            'Find your product',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget search() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                hintText: 'Search product',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: const Icon(Icons.bar_chart, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categories() {
    List list = ['All Products'];
    // List list = ['All', 'Electronics', 'Fashion', 'Food', 'Services'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              indexCategory = index;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(
                index == 0 ? 16 : 16,
                0,
                index == list.length - 1 ? 16 : 16,
                0,
              ),
              alignment: Alignment.center,
              child: Text(
                list[index],
                style: TextStyle(
                  fontSize: 22,
                  color: indexCategory == index ? Colors.green : Colors.grey,
                  fontWeight: indexCategory == index ? FontWeight.bold : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget gridFood2(int productCount) {
    return FutureBuilder<List<Product>>(
      future:
          fetchProducts(), // Replace fetchProductsFromApi with your API call
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Product> products = snapshot.data!;
          return GridView.builder(
            itemCount: products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 261,
            ),
            itemBuilder: (context, index) {
              Product product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailPage(food: product);
                    // return DetailPage(product: product);
                  }));
                },
                child: Container(
                  height: 261,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${product.productImage}',
                                // "${DimConstants.ip}${product.productImage}",
                                // "http://192.168.255.11:8000${product.productImage}",
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Placeholder(
                                    color: Colors.grey,
                                    fallbackWidth: 120,
                                    fallbackHeight: 120,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              product.productName,
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Text(
                              'Ksh.${product.productPrice}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Units: ${product.productUnits}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                const Icon(Icons.circle,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  'Rate: ${product.productStars}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                       Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          // height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: Colors.green,
                             borderRadius: BorderRadius.circular(2)
                          ),
                          child: Center(child: Text('-20%', style: TextStyle(fontSize: 10, color: Colors.white),))
                          // child: Icon(Icons.favorite_border, color: Colors.green)
                          ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // Widget gridFood(int productCount) {
  //   return GridView.builder(
  //     itemCount: dummyFoods.length,
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: const EdgeInsets.all(16),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       mainAxisSpacing: 8,
  //       crossAxisSpacing: 8,
  //       mainAxisExtent: 261,
  //     ),
  //     itemBuilder: (context, index) {
  //       Food food = dummyFoods[index];
  //       // Product product = products[index];
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) {
  //             return DetailPage(food: food);
  //           }));
  //         },
  //         child: Container(
  //           height: 261,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[200],
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Stack(
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(height: 16),
  //                   Center(
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(8),
  //                       child: Image.asset(
  //                         food.image,
  //                         width: 120,
  //                         height: 120,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16),
  //                     child: Text(
  //                       food.name,
  //                       style: Theme.of(context).textTheme.headline6,
  //                       textAlign: TextAlign.center,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 16, vertical: 5),
  //                     child: Text(
  //                       '\sh.${food.price}',
  //                       style: const TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 20,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16),
  //                     child: Row(
  //                       children: [
  //                         Text(
  //                           // food.cookingTime,
  //                           'units',
  //                           style: TextStyle(color: Colors.grey[600]),
  //                         ),
  //                         const Spacer(),
  //                         const Icon(Icons.circle,
  //                             color: Colors.amber, size: 18),
  //                         const SizedBox(width: 4),
  //                         Text(
  //                           // food.rate.toString(),
  //                           '3',
  //                           style: TextStyle(color: Colors.grey[600]),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const Positioned(
  //                 top: 12,
  //                 right: 12,
  //                 child: Icon(Icons.favorite_border, color: Colors.grey),
  //               ),
  //               // const Align(
  //               //   alignment: Alignment.bottomRight,
  //               //   child: Material(
  //               //     color: Colors.green,
  //               //     borderRadius: BorderRadius.only(
  //               //       topLeft: Radius.circular(16),
  //               //       bottomRight: Radius.circular(16),
  //               //     ),
  //               //     child: InkWell(
  //               //       child: Padding(
  //               //         padding: EdgeInsets.all(8),
  //               //         // child: Icon(Icons.add, color: Colors.white),
  //               //         child: Text("3", style: TextStyle(color: Colors.white, fontSize: 8),),
  //               //       ),
  //               //     ),
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
