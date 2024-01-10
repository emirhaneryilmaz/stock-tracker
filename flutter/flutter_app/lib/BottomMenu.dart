import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Haberler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Ana Sayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'My Lists',
        ),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,  
      onTap: (index) {
        _handleBottomNav(context, index);
      },
    );
  }

  void _handleBottomNav(BuildContext context, int index) {
    String routeName = '';

    switch (index) {
      case 0:
        routeName = '/news';
        break;
      case 1:
        routeName = '/home';
        break;
      case 2:
        routeName = '/lists';
        break;    
    }

    if (routeName != null) {
      Navigator.pushNamed(context, routeName);
    }
  }
}
