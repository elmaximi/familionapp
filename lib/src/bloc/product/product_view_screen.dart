import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductViewPage extends StatefulWidget {
  final DocumentSnapshot data;

  ProductViewPage({this.data});

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}
//final productReference = FirebaseDatabase.instance.reference().child('products');

class _ProductViewPageState extends State<ProductViewPage> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    List<dynamic> tags = widget.data["tags"].toList();

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: Hero(
                tag: widget.data["url"],
                child: CachedNetworkImage(
                  placeholder: (ctx, url) => Image(
                    image: AssetImage("assets/placeholder.jpg"),
                  ),
                  imageUrl: widget.data["url"],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  RaisedButton.icon(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                    label: Text("Share"),
                  ),
                  RaisedButton.icon(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: _addToShoppingCart,
                    label: Text("Add to shopping cart"),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  // void _lauchURL() async {
  //   try {
  //     await launch(
  //       widget.data["url"],
  //       option: CustomTabsOption(
  //         toolbarColor: primaryColor
  //       ),

  //     );
  //   } catch (e) {
  //   }
  // }

  void _addToShoppingCart() async {
    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid;

    _db
        .collection("users")
        .document(uid)
        .collection("favorites")
        .document(widget.data.documentID)
        .setData(widget.data.data);
  }
}
