import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'NewsPage.dart';
import 'ListsPage.dart';
import 'SettingsPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Her sayfanın adını tutan bir liste
  final List<String> _pageTitles = [
    'Welcome to Stock Tracker!',
    'News',
    'Follow Lists',
    'Settings',
    // Diğer sayfa başlıklarınız...
  ];

  List<Widget> get _pages {
    return [
      HomePage(),
      NewsPage(),
      ListsPage(),
      SettingsPage(),
      // Diğer sayfalarınız...
    ];
  }

  void _handleDarkMode() {
    print('Dark Mode toggled');
  }

  void _handleSettings(BuildContext context) {
    // SettingsPage'e geçiş yap
    setState(() {
      _selectedIndex = 3; // SettingsPage'in indexi
    });
  }

  void _handleLogout(BuildContext context) {
    // Logout işlemleri
    print('Logged out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => _handleDarkMode(),
            icon: Icon(Icons.nightlight_round),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () => _handleSettings(context),
            icon: Icon(Icons.settings),
            color: Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          // Diğer menü öğeleri...
        ],
      ),
    );
  }
}
