import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/LoginPage.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListContentPage extends StatefulWidget {
  final String listItemTitle;

  ListContentPage({required this.listItemTitle});

  @override
  _ListContentPageState createState() => _ListContentPageState();
}

class _ListContentPageState extends State<ListContentPage> {
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

Future<List<Map<String, dynamic>>> _fetchListContentFromFirestore() async {
  List<Map<String, dynamic>> listContent = [];

  try {
    DocumentSnapshot? userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    if (userSnapshot?.exists ?? false) {
      Map<String, dynamic>? selectedList = (userSnapshot!['portfolyo'] as List?)
          ?.firstWhere((list) => list['list_name'] == widget.listItemTitle, orElse: () => null);

      if (selectedList != null) {
        dynamic rawListContent = selectedList['list_content'];

        if (rawListContent is String) {
          // rawListContent beklenen türde bir dize ise işlemi gerçekleştir
          listContent = [
            {'item_name': rawListContent}
          ];
        } else if (rawListContent is List) {
          // Eğer rawListContent bir liste ise, dönüşüm yaparak işlemi gerçekleştir
          listContent = List<Map<String, dynamic>>.from(rawListContent.map((item) => {'item_name': item}));
        } else {
          print('Hata: list_content beklenen türde değil: $rawListContent');
        }
      } else {
        print('Hata: Seçilen liste bulunamadı');
      }
    } else {
      print('Belge bulunamadı');
    }
  } catch (e) {
    print('Firestore veri çekme hatası: $e');
  }

  return listContent;
}

  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.listItemTitle,
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
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder(
        future: _fetchListContentFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: Veri çekilirken bir sorun oluştu.'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('Liste içeriği bulunamadı.'));
          } else {
            List<Map<String, dynamic>> listContent = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: listContent.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(listContent[index]['item_name'] ?? ''),
                  // Diğer öğe bilgilerini buraya ekle
                );
              },
            );
          }
        },
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
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
          // Diğer menü öğeleri...
        ],
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

  void _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}

