import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/login.dart';
import 'package:http/http.dart' as http;

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.green, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green[200]),
//       ),
//       home: ProfileScreen(),
//     );
//   }
// }

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  Future<void> logout(BuildContext context) async {
    String apiUrl =
        '${DimConstants.ip}/api/logout/'; // Replace this with your API endpoint to retrieve user info
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    // Clear the stored token

    // http logout
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

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
        // userInfo_ = json.decode(response.body);
        print('logout successfuly');
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
    // http logout

    // Navigate back to the login screen or any other screen you prefer
    // Navigator.pushReplacementNamed(context, '/login'); // Replace '/login' with the route to your login screen
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: isLoggedIn2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'asset/uploadimage.jpeg'), // Add your profile image asset here
            ),
            SizedBox(height: 20),
            Text(
              userInfo_?['username'] == null ? ' ' : '${userInfo_!['username']}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Software Developer',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('john.doe@example.com'),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1234567890'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Add onPressed action
                    },
                    child: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                  isLogged_in == true
                      ? ElevatedButton(
                          onPressed: () async {
                            await logout(context);
                          },
                          child: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginPage();
                            }));
                          },
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
