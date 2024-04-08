import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/detail_page.dart';
import 'package:http/http.dart' as http;
import 'package:uispeed_grocery_shop/page/home_page.dart';
import 'package:uispeed_grocery_shop/page/login.dart';

class CollectionPage extends StatefulWidget {
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  late Future<List<Product>> products;

  Future<List<Product>> fetchProducts() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('token');
  

   final response = await http.get(
    headers: {
      'Authorization': 'Token $authToken',
    },
    Uri.parse('${DimConstants.ip}/api/my_products/')); // Replace with your API URL
    // 'http://192.168.255.11:8000/products/')); // Replace with your API URL

    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  late bool? isLogged_in = false;
  //  String? token;
  Map<String, dynamic>? userInfo_ = {'': ''};
  Future<void> isLoggedIn2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    userInfo_ = await getUserInfo(token!);
    if (token == null) {
      // isLogged_in = false;
      setState(() {
        isLogged_in = false;
      });
      print('token');
      // return false;
    } else {
      // isLogged_in = true;
      setState(() {
        isLogged_in = true;
      });
      // return true;
    }
  }

   Future<Map<String, dynamic>?> getUserInfo(String? token) async {
    String apiUrl =
        '${DimConstants.ip}/api/get_user_info/'; // Replace this with your API endpoint to retrieve user info

    try {
      http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        print('================${response.body}');
        // userInfo_ = json.decode(response.body);
        return json.decode(response.body);
      } else {
        // Handle non-200 response
        print('Failed to fetch user info: ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle error
      print('Error fetching user info: $e');
      return null;
    }
  }
  
  @override
  void initState() {
    super.initState();
    isLoggedIn2();
    products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return isLogged_in == false ? LoginPage() : MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Collection'),
        ),
        body: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginPage())));
              // return LoginPage();
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Product> products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return Container(
                      child: Items(
                    product: product,
                  ));
                  // return ListTile(
                  //   title: Text(product.productName),
                  //   subtitle:
                  //       Text('Price: {product.productPrice.toStringAsFixed(2)}'),
                  //   // Add more details as needed
                  // );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shopping_cart/utils/CustomTextStyle.dart';
// import 'package:shopping_cart/utils/CustomUtils.dart';

// import 'CheckOutPage.dart';

class CollectionPage_ extends StatefulWidget {
  @override
  _CollectionPage_State createState() => _CollectionPage_State();
}

class _CollectionPage_State extends State<CollectionPage_> {
  late Future<List<Product>> products;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
        Uri.parse('${DimConstants.ip}/products/')); // Replace with your API URL
    // 'http://192.168.255.11:8000/products/')); // Replace with your API URL

    print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      // body: Builder(
      body: Builder(
        builder: (context) {
          return ListView(
            children: <Widget>[
              createHeader(),
              createSubTitle(),
              // createCartList(),
              Container(
                // child: Text('Example'),
                child: FutureBuilder<List<Product>>(
                  future: fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Product> products = snapshot.data!;
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          Product product = products[index];
                          return ListTile(
                            title: Text(product.productName),
                            subtitle: Text(
                                'Price: ${product.productPrice.toStringAsFixed(2)}'),
                            // Add more details as needed
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              footer(context)
            ],
          );
        },
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: CustomTextStyle.textFormFieldMedium
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "\$299.00",
                  style: CustomTextStyle.textFormFieldBlack.copyWith(
                      color: Colors.greenAccent.shade700, fontSize: 14),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            child: Text(
              "Checkout",
              style: CustomTextStyle.textFormFieldSemiBold
                  .copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => HomePage()));
            },
            style: ElevatedButton.styleFrom(
              // : Colors.green,
              padding:
                  EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
          ),
          SizedBox(
            height: 8,
          )
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "My COLLECTION",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 16, color: Colors.black),
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        "Total(3) Items",
        style: CustomTextStyle.textFormFieldBold
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartListV1() {
    // return ListView.builder(
    //   shrinkWrap: true,
    //   primary: false,
    //   itemBuilder: (context, position) {
    //     // return createCartListItem();
    return FutureBuilder<List<Product>>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Product> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              print('+++++++++${product.productName}');
              return createCartListItem();
              // return ListTile(
              //   title: Text(product.productName),
              //   subtitle:
              //       Text('Price: {product.productPrice.toStringAsFixed(2)}'),
              //   // Add more details as needed
              // );
            },
          );
        }
      },
    );
    // });
  }

  createCartListV2() {
    return SizedBox(
      child: FutureBuilder<List<Product>>(
        future:
            fetchProducts(), // Assuming fetchProducts() is a function that fetches products from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                // return Container(child:createCartListItem());
                return Text('Example');
              },
            );
          }
        },
      ),
    );
  }

  Widget createCartList() {
    return FutureBuilder<List<Product>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Product> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return ListTile(
                title: Text(product.productName),
                subtitle:
                    Text('Price: ${product.productPrice.toStringAsFixed(2)}'),
                // Add more details as needed
              );
            },
          );
        }
      },
    );
  }

  createCartListItem() {
    // return Items(product: ,);
  }
}

class Items extends StatelessWidget {
  Product product;
  Items({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage("${product.productImage}"))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          "${product.productName}",
                          maxLines: 2,
                          softWrap: true,
                          style: CustomTextStyle.textFormFieldSemiBold
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "${product.vendor_number}",
                        style: CustomTextStyle.textFormFieldRegular
                            .copyWith(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Kshs.${product.productPrice}",
                              style: CustomTextStyle.textFormFieldBlack
                                  .copyWith(color: Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  // Icon(
                                  //   Icons.remove,
                                  //   size: 24,
                                  //   color: Colors.grey.shade700,
                                  // ),
                                  // Container(
                                  //   color: Colors.grey.shade200,
                                  //   padding: const EdgeInsets.only(
                                  //       bottom: 2, right: 12, left: 12),
                                  //   child: Text(
                                  //     "1",
                                  //     style:
                                  //         CustomTextStyle.textFormFieldSemiBold,
                                  //   ),
                                  // ),
                                  // Icon(
                                  //   Icons.add,
                                  //   size: 24,
                                  //   color: Colors.grey.shade700,
                                  // )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: Container(
        //     width: 24,
        //     height: 24,
        //     alignment: Alignment.center,
        //     margin: EdgeInsets.only(right: 10, top: 8),
        //     child: Icon(
        //       Icons.close,
        //       color: Colors.white,
        //       size: 20,
        //     ),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(4)),
        //         color: Colors.green),
        //   ),
        // )
      ],
    );
  }
}

class Utils {
  static getSizedBox({required double width, required double height}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

class CustomTextStyle {
  static var textFormFieldRegular = TextStyle(
      fontSize: 16,
      fontFamily: "Helvetica",
      color: Colors.black,
      fontWeight: FontWeight.w400);

  static var textFormFieldLight =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w200);

  static var textFormFieldMedium =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w500);

  static var textFormFieldSemiBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w600);

  static var textFormFieldBold =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w700);

  static var textFormFieldBlack =
      textFormFieldRegular.copyWith(fontWeight: FontWeight.w900);
}

class CustomColors {
  static var COLOR_FB = Color(0xFF3b5998);
  static var COLOR_GREEN = Color(0xFF01a550);
  static var EDIT_PROFILE_PIC_FIRST_GRADIENT = Color(0xFF6713D2);
  static var EDIT_PROFILE_PIC_SECOND_GRADIENT = Color(0xFFCC208E);
}

class CustomBorder {
  static var enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.grey));

  static var focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: ThemeData.light().primaryColor, width: 1));

  static var errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(color: Colors.red, width: 1));
}
