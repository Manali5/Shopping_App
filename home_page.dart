import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/manage_products.dart';
import 'package:shopping_app/screens/my_orders.dart';
import 'package:shopping_app/screens/product_page.dart';
import 'cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorites.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('Products');
  final CollectionReference _userRef = FirebaseFirestore.instance.collection('Users');
  User _user = FirebaseAuth.instance.currentUser;
  final SnackBar _snackBar = SnackBar(content: Text('Product Added to Cart'));
  final SnackBar _snackBar2 = SnackBar(content: Text('Product Added to Favorites'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Text('Hello',
              style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white,
              ),
              textAlign: TextAlign.center,),
            ),
            ListTile(
              title: const Text('Shop',
                style: TextStyle(
                  fontSize: 20,
                ),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Orders',
                style: TextStyle(
                  fontSize: 20,
                ),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrders()));
              },
            ),
            ListTile(
              title: const Text('Manage Products',
                style: TextStyle(
                  fontSize: 20,
                ),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManageProducts()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Shopping App'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Favorites()));
                },
                child: Icon(
                  Icons.more_vert,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cart()));
                },
                child: Icon(
                    Icons.shopping_cart,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: TextButton(
                child: Text('Logout',
                   style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                   )
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
              )
          ),
        ],
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
                 return GestureDetector(
                   onTap: () {
                     Navigator.push(context,
                         MaterialPageRoute(builder: (context) => ProductPage(productId: document.id,)));
                   },
                 child: Card(
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20),
                    ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Container(
                     padding: EdgeInsets.all(8),
                     child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       SizedBox(
                         height: 20,
                       ),
                       Container(
                         height: 180,
                         width: 180,
                         child: Image(image: NetworkImage(document.data()['image']),
                           fit: BoxFit.fill,),
                       ),
                       SizedBox(
                         height: 40,
                       ),
                       Container(
                         child: Text(document.data()['title'],
                           style: TextStyle(
                             fontSize: 20,
                           ),
                           textAlign: TextAlign.center,
                         ),
                       ),
                       SizedBox(
                       height: 20,
                       ),
                      Container(
                        child: Text('\$ ${document.data()['price']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,),
                        textAlign: TextAlign.right,),
                      ),
                       SizedBox(
                         height: 20,
                       ),
                      Container(
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () async{
                                   await _userRef.doc(_user.uid).collection('Favorites').doc(document.id).set({'title':'${document.data()['title']}'});
                                   await _userRef.doc(_user.uid).collection('Favorites').doc(document.id).update({'price':'${document.data()['price']}'});
                                   await _userRef.doc(_user.uid).collection('Favorites').doc(document.id).update({'image':'${document.data()['image']}'});
                                   Scaffold.of(context).showSnackBar(_snackBar2);
                                   },
                              child: Container(
                            child: Icon(Icons.favorite,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                            ),
                           ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async{
                                await _userRef.doc(_user.uid).collection('Cart').doc(document.id).set({'title':'${document.data()['title']}'});
                                await _userRef.doc(_user.uid).collection('Cart').doc(document.id).update({'price':'${document.data()['price']}'});
                                await _userRef.doc(_user.uid).collection('Cart').doc(document.id).update({'image':'${document.data()['image']}'});
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                                    child: Container(
                                      child: Icon(Icons.shopping_cart,
                                          color: Colors.grey,
                                        size: 30,
                                      ),
                                    ),
                            ),
                          ),
                         Expanded(flex: 2, child: SizedBox()),
                          ],
                        )
                      ),
                      SizedBox(
                        height: 20,
                      ),
                     ]
                   )
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
      )
    );
  }
}