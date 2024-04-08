import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uispeed_grocery_shop/page/constant.dart';

class Product {
  final int id;
  final String productName;
  final double productPrice;
  final int? productStars;
  final int productUnits;
  final String productImage;
  final String productDescription;
  final String vendor_number;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productStars,
    required this.productUnits,
    required this.productImage,
    required this.productDescription,
    required this.vendor_number,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      productPrice: json['product_price'].toDouble(),
      productStars: json['product_stars'],
      productUnits: json['product_units'],
      productImage: json['product_image'],
      productDescription: json['product_description'],
      vendor_number: json['vendor_number']
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('${DimConstants.ip}/products/')); // Replace with your API URL

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = snapshot.data![index];
                return ListTile(
                  title: Text(product.productName),
                  subtitle: Text('Price: \$${product.productPrice.toStringAsFixed(2)}'),
                  // You can add more details here if needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
