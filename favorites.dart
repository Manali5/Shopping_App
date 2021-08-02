import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/product_page.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  final CollectionReference _productRef = FirebaseFirestore.instance.collection('Products');
  final CollectionReference _userRef = FirebaseFirestore.instance.collection('Users');
  User _user = FirebaseAuth.instance.currentUser;
  final SnackBar _snackBar = SnackBar(content: Text('Product Added to Cart'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Favorites'),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _userRef.doc(_user.uid).collection('Favorites').get(),
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
            await _userRef.doc(_user.uid).collection('Favorites').doc(document.id).delete();
            Navigator.pop(context);
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => Favorites()));
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
      )
    );
  }
}