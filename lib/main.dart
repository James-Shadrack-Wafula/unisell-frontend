import 'package:flutter/material.dart';
import 'package:uispeed_grocery_shop/page/bottom_nav.dart';
import 'package:uispeed_grocery_shop/page/login.dart';
// import 'package:uispeed_grocery_shop/page/my_product.dart';
import 'package:uispeed_grocery_shop/page/products.dart';
import 'package:uispeed_grocery_shop/page/profile.dart';
import 'package:uispeed_grocery_shop/page/register.dart';
import 'page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
     
      // home: HomePage(),
      // home: LoginPage()
      // home: ProfilePage(),
      home: BottomNav(),
      // home: RegisterPage(),

    );
  }
}
