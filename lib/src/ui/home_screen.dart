import 'package:familionapp/src/ui/pages/accountpage.dart';
import 'package:familionapp/src/ui/pages/explorepage.dart';
import 'package:familionapp/src/ui/pages/favoritespage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  
   @override
  _HomeScreenState createState() => _HomeScreenState();

 
}

class _HomeScreenState extends State<HomeScreen>{
  
  //screen list
  //1. explore
  //2. my account > Add/ Remove Image, logout, profile
  //3. favorites
  //4. settings



  int _selectedPageIndex = 0;

  var _pages=[
    ExplorePage(),
    FavoritesPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("FamApp"),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Explore"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Favorites"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("Account"),
          ),
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index){
          setState(() {
            _selectedPageIndex = index;
          });

        },
      ),
    );
  }
}

