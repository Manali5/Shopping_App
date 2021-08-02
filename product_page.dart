import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class ProductPage extends StatefulWidget {

  final String productId;
  const ProductPage({required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('Products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(widget.productId),
      ),
      body: FutureBuilder(
      future: _productRef.doc(widget.productId).get(),
      builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          if(snapshot.connectionState == ConnectionState.done) {

               //child: snapshot.data!.docs.map((document) {
                 //final Map docData = snapshot.data[0].;
                 //GetOptions getOptions(widget.productId);
             //  }
            //  );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}