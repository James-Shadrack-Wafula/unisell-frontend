import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productStarsController = TextEditingController();
  final TextEditingController productUnitsController = TextEditingController();
  File? _imageFile;

  Future<void> addProduct() async {
    final String apiUrl = 'YOUR_API_URL_HERE';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'product_name': productNameController.text,
        'product_price': double.parse(productPriceController.text),
        'product_stars': int.parse(productStarsController.text),
        'product_units': int.parse(productUnitsController.text),
        'product_image': base64Encode(await _imageFile!.readAsBytes()),
      }),
    );

    if (response.statusCode == 201) {
      // Product added successfully
      print('Product added successfully');
    } else {
      // Error occurred
      print('Failed to add product. Error: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: productPriceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: productStarsController,
              decoration: InputDecoration(labelText: 'Product Stars'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: productUnitsController,
              decoration: InputDecoration(labelText: 'Product Units'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick an Image'),
                  )
                : Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}

