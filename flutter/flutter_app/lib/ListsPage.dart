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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.list),
                  title: Text(userLists[index]['list_name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(context, index),
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
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
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteListItem(index);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteListItem(int index) async {
  String listName = userLists[index]['list_name'];

  // Remove locally
  setState(() {
    userLists.removeAt(index);
  });

  // Remove from Firestore
  await _removeListFromFirestore(index, listName);
}

Future<void> _removeListFromFirestore(int index, String listName) async {
  try {
    // Get the current list from Firestore
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    List<dynamic> currentList = List.from(documentSnapshot['portfolyo']);

    // Remove the item at the specified index
    currentList.removeAt(index);

    // Update Firestore with the modified list
    await FirebaseFirestore.instance.collection('users').doc(_userId).update({
      'portfolyo': currentList,
    });

    print('List removed from Firestore at index $index: $listName');
  } catch (e) {
    print('Error removing list from Firestore: $e');
  }
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
          title: Text('Create new list.'),
          content: TextField(
            onChanged: (value) {
              newListTitle = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter List Title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createNewList(newListTitle);
                Navigator.pop(context);
              },
              child: Text('Create'),
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
