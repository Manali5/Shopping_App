import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_products.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({Key? key}) : super(key: key);

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('Products');
  final CollectionReference _userRef = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Manage Products'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _productRef.get(),
        builder: (context,snapshot) {
          if(snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [ SizedBox(
                          width: 20,
                         ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 40,
                              width: 40,
                              child: Image(image: NetworkImage(document.data()['image']),
                                fit: BoxFit.fill,),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: Text(document.data()['title'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => EditProducts(productId: document.id)));
                              },
                              child: Container(
                                child: Icon(Icons.edit,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ]
                    ),
                  ),
                );
              }
              ).toList()
            );
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          },
      ),
    );
  }
}