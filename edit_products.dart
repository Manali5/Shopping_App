import 'package:flutter/material.dart';

class EditProducts extends StatefulWidget {

  final String productId;
  const EditProducts({required this.productId});

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Edit Products'),
      ),
      body: Center(
        child: Text(widget.productId),
      ),
    );
  }
}
