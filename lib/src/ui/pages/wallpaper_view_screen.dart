import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductViewPage extends StatefulWidget {

  final String image;

  ProductViewPage({this.image});

  @override
  _ProductViewPageState createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[

              Container(
                child: Hero(
                  tag: widget.image,
                  child: CachedNetworkImage(
                    placeholder: (ctx, url) => Image(image: AssetImage("assets/placeholder.jpg"),),
                    imageUrl: widget.image,
                  ),
                ),
              ),
            ],
          ),
        )),
    );
  }
}