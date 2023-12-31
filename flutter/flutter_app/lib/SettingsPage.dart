import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Settings',
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
              // _handleSettings(context);
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
      body: ListView.builder(
        itemCount: 5, // Ayar sayısı
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.settings), 
            title: Text('Ayar ${index + 1}'),
            onTap: () {
              // Ayar öğesine tıklandığında yapılacak işlemler
            },
          );
        },
      ),
      // bottomNavigationBar: BottomMenu(),
    );
  }

  
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
  void _handleSettings(BuildContext context) {
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),);
  }

  void _handleDarkMode() {
    print('Dark Mode');
  }




}

  