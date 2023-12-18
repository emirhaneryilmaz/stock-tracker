import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'NewsPage.dart';
import 'ListsPage.dart';

class MainScreen extends StatefulWidget {
  // final String token;

  // MainScreen(this.token);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _pages {
    return [
      HomePage(), // Token'ı HomePage'e ilet
      NewsPage(),             // NewsPage için token gerekiyorsa ekleyin
      ListsPage(),            // ListsPage için token gerekiyorsa ekleyin
      // Diğer sayfalarınız...
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Follow Lists',
          ),
          // Diğer menü öğeleri...
        ],
      ),
    );
  }
}
