import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('Products');
  final CollectionReference _userRef = FirebaseFirestore.instance.collection('Users');
  User _user = FirebaseAuth.instance.currentUser;
  SnackBar _snackBar = SnackBar(content: Text('Product Removed from Cart'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('My Cart'),
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
                    return FutureBuilder(
                          future:  _productRef.doc(document.id).get(),
                          builder: (context, productSnap) {
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
                                          width: 10,
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
                                          width: 8,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                          children: [ Container(
                                            child: Text(document.data()['title'],
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              textAlign: TextAlign.center,
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
                                          width: 8,
                                        ),
                                        GestureDetector(
                                          child: Icon(Icons.delete,),
                                          onTap: () async{
                                            await _userRef.doc(_user.uid).collection('Cart').doc(document.id).delete();
                                            Scaffold.of(context).showSnackBar(_snackBar);
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => Cart()));
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ]
                                  )
                              ),
                            );
                            }
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