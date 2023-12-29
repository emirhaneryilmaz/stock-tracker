import 'package:flutter/material.dart';
import 'package:flutter_app/LoginPage.dart';
import 'package:flutter_app/listContentPage.dart'; 
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ListsPage ());
}

class ListsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //leading: IconButton(
        //  icon: Icon(Icons.arrow_back, color: Colors.black),
        //  onPressed: () => Navigator.of(context).pop(),
        //),
        title: Text(
          'Lists',
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
      body: ListView.builder(
        itemCount: 10, // Örnek olarak 10 elemanlı liste
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.list), // Her liste öğesinin başında bir ikon
            title: Text('Liste Öğesi $index'),
            subtitle: Text('Detaylar burada gösterilecek'),
            trailing: Icon(Icons.arrow_forward_ios), // Sağ tarafta bir ikon
            onTap: () {
              _handleListItemTap(context, index);

              print('Liste Öğesi $index tıklandı');
            },
          );
        },
      ),
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

  void _handleAssetTap(String assetName) {
    print('$assetName tıklandı');
  }

  void _handleLikeButton() {
    print('Beğen');
  }
  void _handleListItemTap(BuildContext context, int index) {
    // ListContentPage'e yönlendirme yap
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListContentPage(
          listItemTitle: 'Liste Öğesi $index',
        ),
      ),
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

}



