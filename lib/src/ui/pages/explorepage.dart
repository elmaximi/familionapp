import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familionapp/src/ui/pages/wallpaper_view_screen.dart';
import 'package:familionapp/src/util/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // var images = [
  //   "https://images.pexels.com/photos/1957477/pexels-photo-1957477.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
  //   "https://images.pexels.com/photos/7974/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //   "https://images.pexels.com/photos/416320/pexels-photo-416320.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //   "https://images.pexels.com/photos/2528116/pexels-photo-2528116.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //   "https://images.unsplash.com/photo-1593118247619-e2d6f056869e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //   "https://images.unsplash.com/photo-1597260491619-bab87197869f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=281&q=80",
  //   "https://images.unsplash.com/photo-1597130440911-460f95bab68b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
  //   "https://images.unsplash.com/photo-1596896639823-da416a9d3960?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=331&q=80",
  //   "https://images.unsplash.com/photo-1551515300-2d3b7bb80920?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=752&q=80",
  //   "https://images.unsplash.com/photo-1589578228447-e1a4e481c6c8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=889&q=80"
  // ];

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(
              top: 5,
              left: 20,
              bottom: 20,
            ),
            child: Text(
              "Explore",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          StreamBuilder(
            stream: _db
                .collection("products")
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  itemCount: snapshot.data.documents.length,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductViewPage(
                                      image: snapshot
                                          .data.documents[index].data["url"],
                                    )));
                      },
                      child: Hero(
                        tag: snapshot.data.documents[index].data["url"],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // child: Image(
                          //   image: NetworkImage(images[index]),
                          // ),
                          child: CachedNetworkImage(
                            placeholder: (ctx, url) => Image(
                              image: AssetImage("assets/placeholder.jpg"),
                            ),
                            imageUrl:
                                snapshot.data.documents[index].data["url"],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              );
            },
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    ));
  }
}
