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
          icon: Icon(Icons.account_balance_wallet),
          label: 'Portföyüm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Listelerim',
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
    switch (index) {
      case 0:
        print('Haberler');
        break;
      case 1:
        print('Ana Sayfa');
        break;
      case 2:
        print('Portföyüm');
        break;
      case 3:
        print('Listelerim');
        break;
    }
  }
}
