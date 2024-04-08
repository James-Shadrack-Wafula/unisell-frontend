import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uispeed_grocery_shop/page/bottom_nav.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:uispeed_grocery_shop/page/flutter_wave_pay.dart';
import 'package:uispeed_grocery_shop/page/home_page.dart';
import 'package:uispeed_grocery_shop/page/login.dart';

import '../model/food.dart';
import 'package:http/http.dart' as http;

class MyProduct extends StatefulWidget {
  const MyProduct({Key? key}) : super(key: key);

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  int quantity = 1;

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productStarsController = TextEditingController();
  final TextEditingController productUnitsController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  File? _imageFile;
  late bool? isLogged_in = false;

  String errorMsg = '';

  Future<void> isLoggedIn2() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token==null){
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



  Future<Map<String, dynamic>?> getUserInfo(String token) async {
  String apiUrl = '${DimConstants.ip}/api/get_user_info/'; // Replace this with your API endpoint to retrieve user info
  
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
  

  Future<void> addProduct() async {
    final String apiUrl = '${DimConstants.ip}/new_products/';
    // final int user_id = await AuthService.isLoggedIn();
    // print('user id => ${user_id}');
    // String token = 'b0919395fb02119da53ba54055b48573f93cd914'; // Your token
    final String ?authToken = await AuthService.getToken();
    print('token => ${authToken} user id => {user_id}');
    Map<String, dynamic>? userInfo = await getUserInfo(authToken!);
    print('user id => ${userInfo}');
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Basic $authToken',
      },
        
      body: jsonEncode(<String, dynamic>{
        'user': userInfo!['user_id'],
        'product_name': productNameController.text,
        'product_price': int.parse(productPriceController.text),
        'product_units': int.parse(productUnitsController.text),
        'product_description': productDescriptionController.text,
        'product_image': base64Encode(await _imageFile!.readAsBytes()),
        'vendor_number': '254${phoneNumberController.text}',
      }),
    );

    if (response.statusCode == 201) {
      // Product added successfully
      print('Product added successfully');
    } else {
      setState(() {
        errorMsg = response.body;
      });

      // Error occurred
      print('Failed to add product. Error: ${errorMsg}');
      // print('Failed to add product. Error: ${response.body}');
      // print('Failed to add product. Error: ${response.statusCode}');
    }
  }
  // 'product_stars': int.parse(productStarsController.text),
       // 'Authorization': 'Bearer $authToken',

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }
  Future<bool> isLoggedIn = AuthService.isLoggedIn2();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        children: [
          const SizedBox(height: 20),
          header(),
          const SizedBox(height: 20),
          image(),
          details(),
        ],
      ),
    );
  }

  bool is_valid_var = true;
  bool isValidNumber(String phoneNumber){
     // Regular expression to match a valid phone number
    RegExp regExp = RegExp(r'^\d{10}$'); // Assumes 10 digits for a valid phone number
    
    // Check if the provided phone number matches the regular expression
    if(regExp.hasMatch(phoneNumber)){
      setState(() {
        is_valid_var = true;
      });
      return true;
    } else {
      setState(() {
        is_valid_var = true;
      });
      return false;
    }
   
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn2();
  }

  

  Container details() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Product Name",
                            hintStyle: TextStyle(color: Colors.grey[600])
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.grey),
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            ),
                        // style: TextStyle(
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.black,
                        //   fontSize: 34,
                        // ),
                      ),
                    ),
                    // Text(
                    //   // widget.food.name,
                    //   "Burger Cheese",
                    //   style: const TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black,
                    //     fontSize: 34,
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text("THis is element of row"),
                        Expanded(
                          // child: TextField(
                          //   decoration: InputDecoration(
                          //     hintText: "Unit Price",
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide:
                          //           const BorderSide(color: Colors.grey),
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          // ),

                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: productPriceController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Unit Price",
                                  hintStyle: TextStyle(color: Colors.grey[600])
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: const BorderSide(color: Colors.grey),
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  ),
                              // style: TextStyle(
                              //   fontWeight: FontWeight.bold,
                              //   color: Colors.black,
                              //   fontSize: 34,
                              // ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: productUnitsController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Units",
                                  hintStyle: TextStyle(color: Colors.grey[600])
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: const BorderSide(color: Colors.grey),
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                  ),
                              // style: TextStyle(
                              //   fontWeight: FontWeight.bold,
                              //   color: Colors.black,
                              //   fontSize: 34,
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone number",
                            hintStyle: TextStyle(color: Colors.grey[600])
                            ),
                      ),
                    ),

                    is_valid_var == false || errorMsg.isNotEmpty? 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20),
                      child: Text(
                        "Invalid Phone number ${errorMsg}", style: TextStyle(
                          color: Colors.red
                        ),
                      ),
                    ) :
                    SizedBox(),
                  ],
                ),
              ),
              // Material(
              //   color: Colors.green,
              //   borderRadius: BorderRadius.circular(30),
              //   child: Row(
              //     children: [
              //       IconButton(
              //         onPressed: () {
              //           if (quantity > 1) {
              //             quantity -= 1;
              //             setState(() {});
              //           }
              //         },
              //         icon: const Icon(Icons.remove, color: Colors.white),
              //       ),
              //       const SizedBox(width: 4),
              //       Text(
              //         '$quantity',
              //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //               color: Colors.white,
              //             ),
              //       ),
              //       const SizedBox(width: 4),
              //       IconButton(
              //         onPressed: () {
              //           quantity += 1;
              //           setState(() {});
              //         },
              //         icon: const Icon(Icons.add, color: Colors.white),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 30),
          // Row(
          //   children: [
          //     const Icon(Icons.star, color: Colors.amber),
          //     const SizedBox(width: 4),
          //     Text(
          //       '4.5',
          //       style: const TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const Spacer(),
          //     const Icon(Icons.fiber_manual_record, color: Colors.red),
          //     const SizedBox(width: 4),
          //     Text(
          //       '100 kcal',
          //       style: const TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const Spacer(),
          //     const Icon(Icons.access_time_filled, color: Colors.amber),
          //     const SizedBox(width: 4),
          //     Text(
          //       'time',
          //       style: const TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Product Description',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          // TextField(
          //   keyboardType: TextInputType.multiline,
          //   maxLines: null,
          //   minLines: 2,
          //   decoration: InputDecoration(
          //     // hintText: "Products in stock",
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: const BorderSide(color: Colors.grey),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //   ),
          // ),

          Container(
            //height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: productDescriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Product Description",
                  hintStyle: TextStyle(color: Colors.grey[600])
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(color: Colors.grey),
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  ),
              // style: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   color: Colors.black,
              //   fontSize: 34,
              // ),
            ),
          ),
          // Text(
          //   'Food description',
          //   style: const TextStyle(
          //     fontSize: 16,
          //     color: Colors.black54,
          //   ),
          // ),
          const SizedBox(height: 30),
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async{
                try {

                  if(isLogged_in== true){
                    if (!isValidNumber(phoneNumberController.text)){
                      setState(() {
                        is_valid_var = false;
                      });
                    } else {
                      print("Product added successfuly");
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return PayPage(title: "Pay to Unisell");
                    // return DetailPage(product: product);
                  }));
                      await addProduct();

                      
                    }

                    } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                    // return DetailPage(product: product);
                  }));

                  }
                } catch (e) {
                  print('Error occured while adding Product: $e');
                }
                // await addProduct();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: const Text(
                  'Sell',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // ElevatedButton(onPressed: (){addProduct();}, child: Text("Add Product")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  SizedBox image() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.green[300]!,
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.circular(250),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _imageFile == null 
                ? GestureDetector(
                  onTap: (){
                    _pickImage();
                  },
                  child: Image.asset(
                    'asset/uploadimage.jpeg',
                    fit: BoxFit.cover,
                    width: 250,
                    height: 250,
                  ),
                ) : Image.file(_imageFile!, height: 250, width: 250, fit: BoxFit.cover,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Material(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            child: const BackButton(color: Colors.white),
          ),
          const Spacer(),
          Text(
            'My Product',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.white,
                ),
          ),
          const Spacer(),
          Material(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: Text('-25%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                // child: const Icon(Icons.favorite_border, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
