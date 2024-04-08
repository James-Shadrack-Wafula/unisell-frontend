import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/home_page.dart';
import 'package:uispeed_grocery_shop/page/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('${DimConstants.ip}/api/register/'); // Replace with your Django register API endpoint

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Specify content type
        'Accept': 'application/json', // Specify Accept header
      },
      body: json.encode({
        'username': usernameController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      // User registered successfully, now log in
      await login(); // Call your login function
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to register. Please try again.';
      });
    }
  }
   

   Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('${DimConstants.ip}/api/login/'); // Replace with your Django login API endpoint
    
    print("username: ${usernameController.text} password: ${passwordController.text}");
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
                    return HomePage();
                    // return DetailPage(product: product);
                  }));
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Invalid credentials. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              controller: emailController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'email@example.com'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
             TextField(
              controller: passwordController2,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Register'),
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
                text: 'Have an account? ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                
                  TextSpan(
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LoginPage();
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
