import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ListContentPage.dart';
import 'package:flutter_app/LoginPage.dart';
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
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<List<Map<String, dynamic>>> _fetchUserListsFromFirestore() async {
    List<Map<String, dynamic>> userLists = [];

    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(_userId).get();

      List<dynamic>? listsArray = userSnapshot['portfolyo'] as List<dynamic>?;

      if (listsArray != null) {
        userLists = List<Map<String, dynamic>>.from(listsArray);
      }
    } catch (e) {
      print('Firestore veri çekme hatası: $e');
    }

    return userLists;
  }

  @override
  void initState() {
    super.initState();
    _loadUserListsFromFirestore();
  }

  Future<void> _loadUserListsFromFirestore() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> fetchedUserLists = await _fetchUserListsFromFirestore();

    setState(() {
      userLists = fetchedUserLists;
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> userLists = [];
  bool isLoading = true;

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.list),
                  title: Text(userLists[index]['list_name']),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListContentPage(
          listItemTitle: userLists[index]['list_name'],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');

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

  void _createNewList(String title) async {
    if (title.isNotEmpty) {
      setState(() {
        userLists.add({
          'list_name': title,
          'list_content': [],
        });
      });

      // Firestore'a yeni liste başlığını ekleyin
      await _saveListToFirestore(_userId, title);
    }
  }

  Future<void> _saveListToFirestore(String userId, String title) async {
    try {
      // Kullanıcının UID'siyle ilişkilendirilmiş belirli bir belge oluşturun
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'portfolyo': FieldValue.arrayUnion([
          {
            'list_name': title,
            'list_content': [],
          }
        ]),
      });

      print('Liste başlığı Firestore\'a eklendi: $title');
    } catch (e) {
      print('Firestore veri ekleme hatası: $e');
    }
  }
}
