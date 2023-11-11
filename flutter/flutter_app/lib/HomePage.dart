import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  final String token;

  // Constructor ile token parametresini alıyoruz
  HomePage(this.token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }

  void _handleLogout(BuildContext context) async{
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
}
