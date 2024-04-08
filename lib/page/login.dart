import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uispeed_grocery_shop/page/bottom_nav.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/home_page.dart';
import 'package:uispeed_grocery_shop/page/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        '${DimConstants.ip}/api/login/'); // Replace with your Django login API endpoint

    print(
        "username: ${usernameController.text} password: ${passwordController.text}");
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json', // Specify content type
          'Accept': 'application/json', // Specify Accept header
        },
        body: json.encode({
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        }));

    if (response.statusCode == 200) {
      print('successful🎉🏆🙌');
      var jsonResponse = json.decode(response.body);
      var token = jsonResponse['token'];

      // Store the token securely
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Navigate to the next screen after successful login
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        // return HomePage();
        return BottomNav();
        // return DetailPage(product: product);
      }));
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Invalid credentials. Please try again.';
      });
    }
  }

//   Future<void> login() async {
//   setState(() {
//     isLoading = true;
//   });

//   var url = Uri.parse('${DimConstants.ip}/api/login/'); // Replace with your Django login API endpoint

//   var headers = {
//       'Content-Type': 'application/json', // Specify content type
//     };

//   print(passwordController.text);
//   var response = await http.post(
//     url,
//     headers: headers,
//     body: {
//       'username': usernameController.text.trim(),
//       'password': passwordController.text.trim(),
//     },
//   );

//   if (response.statusCode == 200) {
//     var jsonResponse = json.decode(response.body);
//     var token = jsonResponse['token'];

//     // Store the token securely
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);

//     // Navigate to the next screen after successful login
//     print("Success");
//     // Navigator.pushReplacementNamed(context, '/home');
//   } else {
//     setState(() {
//       isLoading = false;
//       errorMessage = 'Invalid credentials. Please try again.';
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
            SizedBox(height: 10.0),
            errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : SizedBox(),
            SizedBox(height: 10.0),
            RichText(
              text: TextSpan(
                text: 'New to Unisell? ',
                style: TextStyle(color: Colors.black),
                // style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  
                  TextSpan(
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      text: ' Register Now',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context){
                          return RegisterPage();
                        }))),
                        // ..onTap = () => print('click')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
