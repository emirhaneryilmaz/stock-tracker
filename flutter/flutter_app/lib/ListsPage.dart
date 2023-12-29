import 'package:flutter/material.dart';
import 'package:flutter_app/LoginPage.dart';
import 'package:flutter_app/listContentPage.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ListsPage());
}

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<String> listTitles = []; // Liste başlıklarını saklamak için liste

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        itemCount: listTitles.length, // Liste başlıkları sayısı kadar elemanlı liste
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.list),
            title: Text(listTitles[index]),
            subtitle: Text('Detaylar burada gösterilecek'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _handleListItemTap(context, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateListDialog(context);
        },
        child: Icon(Icons.add),
        
        backgroundColor: Colors.black,
      ),
    );
  }

  void _handleSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _handleDarkMode() {
    print('Dark Mode');
  }

  void _handleListItemTap(BuildContext context, int index) {
    // ListContentPage'e yönlendirme yap
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListContentPage(
          listItemTitle: listTitles[index],
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

  void _showCreateListDialog(BuildContext context) {
    String newListTitle = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Liste Oluştur'),
          content: TextField(
            onChanged: (value) {
              newListTitle = value;
            },
            decoration: InputDecoration(
              hintText: 'Liste Başlığı Girin',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _createNewList(newListTitle);
                Navigator.pop(context); 
              },
              child: Text('Oluştur'),
            ),
          ],
        );
      },
    );
  }

  void _createNewList(String title) {
    // Yeni liste oluştur
    if (title.isNotEmpty) {
      setState(() {
        listTitles.add(title);
      });
    }
  }
}
