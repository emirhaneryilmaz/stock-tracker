import 'package:flutter/material.dart';
import 'package:flutter_app/LoginPage.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListContentPage extends StatelessWidget {
  final String listItemTitle;

  ListContentPage({required this.listItemTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        elevation: 0,
        title: Text(
          listItemTitle,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _handleDarkMode();
              },
              icon: Icon(Icons.nightlight_round),
              color: Colors.black,
            ),
          IconButton(
            onPressed: () {
              _handleSettings(context);
            },
            icon: Icon(Icons.settings),
            color: Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text('Detaylar burada gösterilecek'),
      ),
    );
  }
}
 void _handleSettings(BuildContext context) {
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),);
  }
  
  void _handleDarkMode() {
    print('Dark Mode');
  }

  void _handleAssetTap(String assetName) {
    print('$assetName tıklandı');
  }

  // void _handleLikeButton() {
  //  print('Beğen');
  //}
  void _handleLogout(BuildContext context) async {
    // Logout işlevi

    // Local storage'dan token'ı kaldır
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');

    // Diğer temizleme işlemleri.

    // Logout olduğunda LoginPage'e yönlendirme
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

