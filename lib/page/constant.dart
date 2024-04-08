import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart'; // Import JWT decoding library
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  // static int ? user_Id;
  static Future<int> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);

    if (token == null) {
      return -1;
    }

    // Decode the token to check if it's valid
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    int? userId = decodedToken['user_id'];
    // user_Id = userId;

    // You can save the user ID or any other information from the token
    // to use it throughout your app
    prefs.setInt('userId', userId!);

    return userId;
  }

  static bool isLogged_in = false;

  static Future<bool> isLoggedIn2() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token==null){
      isLogged_in = false;
      return false;
    } else {
      isLogged_in = true;
      return true;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo(String token) async {
  String apiUrl = 'YOUR_USER_INFO_ENDPOINT'; // Replace this with your API endpoint to retrieve user info
  
  try {
    http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON
      print(response.body);
      return json.decode(response.body);
    } else {
      // Handle non-200 response
      print('Failed to fetch user info: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Handle error
    print('Error fetching user info: $e');
    return null;
  }
}
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token from SharedPreferences
  }
}

// Example usage:
// class YourWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: AuthService.isLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Show loading indicator
//         }

//         if (snapshot.hasData && snapshot.data!) {
//           // User is logged in
//           return YourHomePage(); // Navigate to the home page
//         } else {
//           // User is not logged in
//           return LoginPage(); // Navigate to the login page
//         }
//       },
//     );
//   }
// }

class DimConstants{
  static String ip = 'https://unisell.onrender.com';
  // static String ip = 'http://192.168.1.148:8000';
  // static String ip = 'http://192.168.185.11:8000';

}