import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('Users');
  final CollectionReference _userRef = FirebaseFirestore.instance.collection('Users');
  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('My Orders'),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _userRef.doc(_user.uid).collection('Cart').get(),
          builder: (context,snapshot) {
            if(snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            if(snapshot.connectionState == ConnectionState.done) {
              return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: () {

                      },
                      child: FutureBuilder(
                          future:  FirebaseFirestore.instance.collection('Products').doc(document.id).get(), //productRef.doc(document.id).get(),
                          builder: (context, productSnap) {
                            //   final Map<String, dynamic> map = productSnap.data!.data('');
                            // productSnap.data;
                            //String _productMap = productSnap.data.data();
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
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              child: Image(image: NetworkImage(document.data()['image']),
                                                fit: BoxFit.fill,),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                              children: [ Container(
                                                child: Text(document.data()['title'],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: Text('\$${document.data()['price']}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.green,),
                                                    textAlign: TextAlign.center,),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ]
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ]
                                  )
                              ),
                            );
                          }
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
      ),
    );
  }
}