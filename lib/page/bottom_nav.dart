import 'package:flutter/material.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/home_page.dart';
import 'package:uispeed_grocery_shop/page/login.dart';
import 'package:uispeed_grocery_shop/page/my_collection.dart';
import 'package:uispeed_grocery_shop/page/my_product.dart';
import 'package:uispeed_grocery_shop/page/profile.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomePage(),
    MyProduct(),
    CollectionPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Bar Demo'),
      // ),
      body: _screens[_currentIndex], // Show the current screen based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green[200],
        currentIndex: _currentIndex, // Set the current index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index when an item is tapped
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sell'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'My Collection'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profuile'),
        ],
      ),
    );
  }
}



