import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familionapp/src/ui/pages/add_product_screen.dart';
import 'package:familionapp/src/ui/pages/wallpaper_view_screen.dart';
import 'package:familionapp/src/util/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:familionapp/src/bloc/authentication_bloc/bloc.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  //String name;

  final Firestore _db = Firestore.instance;

  // var images = [
  //   "https://images.unsplash.com/photo-1597130440911-460f95bab68b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
  //   "https://images.unsplash.com/photo-1596896639823-da416a9d3960?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=331&q=80",
  //   "https://images.unsplash.com/photo-1551515300-2d3b7bb80920?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=752&q=80",
  //   "https://images.unsplash.com/photo-1589578228447-e1a4e481c6c8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=889&q=80",
  //   "https://images.pexels.com/photos/1957477/pexels-photo-1957477.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
  //   "https://images.pexels.com/photos/7974/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //   "https://images.pexels.com/photos/416320/pexels-photo-416320.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //   "https://images.pexels.com/photos/2528116/pexels-photo-2528116.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //   "https://images.unsplash.com/photo-1593118247619-e2d6f056869e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  //   "https://images.unsplash.com/photo-1597260491619-bab87197869f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=281&q=80",
  // ];

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  void fetchUserData() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      _user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: _user != null
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage(
                      width: 200,
                      height: 200,
                      image: NetworkImage("${_user.photoUrl}"),
                      placeholder: AssetImage("assets/placeholder.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Text("${_user.displayName}"),
                  //Center(child: Text('$name'),),
                  Center(
                    child: Text("${_user.displayName}"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      //_auth.signOut();
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedOut());
                    },
                    child: Text("Logout"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //add product buttom icon
                        Text("My Products"),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddProductScreen(),
                                  fullscreenDialog: true,
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                  // StaggeredGridView.countBuilder(
                  //   crossAxisCount: 2,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  //   itemCount: images.length,
                  //   mainAxisSpacing: 15,
                  //   crossAxisSpacing: 15,
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 15,
                  //   ),
                  //   itemBuilder: (ctx, index) {
                  //     return ClipRRect(
                  //       borderRadius: BorderRadius.circular(10),
                  //       child: Image(
                  //         image: NetworkImage(images[index]),
                  //       ),
                  //     );
                  //   },
                  // ),

                  StreamBuilder(
                    stream: _db
                        .collection("products")
                        .where("uploaded_by", isEqualTo: _user.uid)
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return StaggeredGridView.countBuilder( 
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.fit(1),
                          itemCount: snapshot.data.documents.length,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          itemBuilder: (ctx, index) {
                            return InkWell( //abre la imagen del producto
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductViewPage(
                                              image: snapshot.data
                                                  .documents[index].data["url"],
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: snapshot
                                        .data.documents[index].data["url"],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      // child: Image(
                                      //   image: NetworkImage(images[index]),
                                      // ),
                                      child: CachedNetworkImage(
                                        placeholder: (ctx, url) => Image(
                                          image: AssetImage(
                                              "assets/placeholder.jpg"),
                                        ),
                                        imageUrl: snapshot
                                            .data.documents[index].data["url"],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                  title: Text("Confirmation"),
                                                  content: Text(
                                                      "Are you sure, you are deleting product"),
                                                  actions: <Widget>[
                                                    RaisedButton(
                                                      child: Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    ),
                                                    RaisedButton(
                                                      child: Text("Delete"),
                                                      onPressed: () {
                                                        _db
                                                            .collection(
                                                                "products")
                                                            .document(snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .documentID)
                                                            .delete();
                                                        Navigator.of(ctx).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                      SizedBox(
                                        width: 77,
                                      ),
                                      IconButton(
                                          //add details product button icon
                                          icon: Icon(Icons.visibility),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductViewPage(
                                              image: snapshot.data
                                                  .documents[index].data["url"],
                                            )));
                                          }),
                                    ],
                                  ),
                                ],
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
              )
            : LinearProgressIndicator(),
      ),
    );
  }
}
