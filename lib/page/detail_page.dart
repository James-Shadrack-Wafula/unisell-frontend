import 'package:flutter/material.dart';
import 'package:uispeed_grocery_shop/page/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/food.dart';

class Product {
  final int id;
  final String productName;
  final double productPrice;
  final int productStars;
  final int productUnits;
  final String productImage;
  final String ? productDescription;
  final String ? vendor_number;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productStars,
    required this.productUnits,
    required this.productDescription,
    required this.productImage,
    required this.vendor_number,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      productPrice: json['product_price'].toDouble(),
      productStars: json['product_stars'],
      productUnits: json['product_units'],
      productDescription: json['product_description'],
      productImage: json['product_image'],
      vendor_number: json['vendor_number'],
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.food}) : super(key: key);
  final Product food;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;

  _launchWhatsApp_() async {
    // Replace 'phoneNumber' with the phone number you want to start the chat with
    String phoneNumber = "254746727592";
    // Generate a WhatsApp direct link
    String url = "https://wa.me/$phoneNumber";
    
    // Check if the WhatsApp app is installed on the device
    if (await canLaunch(url)) {
      // Open the WhatsApp chat
      await launch(url);
    } else {
      // Show an error message if WhatsApp is not installed
      throw 'Could not launch $url';
    }
  }

  _launchWhatsApp() async {
    String? phoneNumber = widget.food.vendor_number; 
    // String phoneNumber = "254715561999"; // Example phone number
    String url = "https://wa.me/$phoneNumber";
    Uri _url = Uri.parse(url);
    // String url = "https://wa.me/$phoneNumber";
    
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
  }
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

  Container details() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 34,
                        ),
                      ),
                      // Text('sh.${widget.food.productPrice}',
                      //     style: const TextStyle(
                      //       fontSize: 24,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.green,
                      //     )),
                    ],
                  ),
                ),
            
                Text('sh.${widget.food.productPrice}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )),
            
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text('@User',
                //             style:  TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.grey[400],
                //             )),
                // ),
            
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
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Icon(Icons.circle, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${widget.food.productUnits.toString()} Units',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.discount, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '25% discount',
                // '${widget.food.kcal}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.location_on, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                // widget.food.cookingTime,
                'Maseno',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'About Product',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
           '${widget.food.productDescription}',
            // 'This is product decription',
            // widget.food.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Material(
            color: Colors.green,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _launchWhatsApp();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: const Text(
                  'Contact Vendor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
                    color: Colors.grey[300]!,
                    // color: Colors.green[300]!,
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.circular(250),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "${widget.food.productImage}",
                  // "http://192.168.255.11:8000${widget.food.productImage}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                                  return Placeholder(
                                    color: Colors.grey,
                                    fallbackWidth: 120,
                                    fallbackHeight: 120,
                                  );},
                  width: 300,
                  height: 300,
                ),
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
            'Product Details',
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
