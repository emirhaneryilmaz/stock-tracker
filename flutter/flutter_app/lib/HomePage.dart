import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'dart:async';

class HomePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.225,
              decoration: BoxDecoration(
                color: Color(0xFF93B1A6),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Varlıklarınız',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '\$5,000.00',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              'Popüler Ürünler',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                List<String> assetNames = ['Altın', 'EUR', 'USD', 'BIST100', 'BIST30'];
                GlobalKey _buttonKey = GlobalKey();

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  height: 65.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: InkWell(
                      onTap: () {
                        _handleAssetTap(assetNames[index]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              assetNames[index][0],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(assetNames[index]),
                              Text('Fiyat: \$19.99'),
                            ],
                          ),
                          SizedBox(width: 16.0),
                          IconButton(
                            onPressed: () {
                              print('Artma/Azalma');
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                          IconButton(
                            key: _buttonKey,
                            onPressed: () {
                              _handleLikeButton(context, _buttonKey, assetNames[index]);
                            },
                            icon: Icon(Icons.thumb_up),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomMenu(),
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
    print('$assetName tiklandi');
  }

 void _handleLikeButton(BuildContext context, GlobalKey key, String selectedProduct) async {
  RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;

  if (renderBox != null) {
    var offset = renderBox.localToGlobal(Offset.zero);

    List<Map<String, dynamic>> userLists = await _fetchUserListsFromFirestore();

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: userLists.map((list) {
        return PopupMenuItem(
          child: Text(list['list_name']),
          value: list['list_name'],
        );
      }).toList(),
      elevation: 8.0,
    ).then((value) {
  if (value != null) {
    // Seçilen liste: $value, Seçilen ürün: $selectedProduct
    String selectedList = value.toString();

    // Seçilen ürünü seçilen listeye ekleyin
    _addProductToList(selectedProduct, selectedList);
  }
});
  }
}

Future<void> _addProductToList(String selectedProduct, String listName) async {
  try {
    // Firestore'dan kullanıcının verilerini çek
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

    // Kullanıcının portföy verisini al
    List<dynamic>? userLists = userSnapshot['portfolyo'] as List<dynamic>?;

    if (userLists != null) {
      // Seçilen liste ismine ait olan listeyi bul
      Map<String, dynamic>? selectedList = userLists.firstWhere(
        (list) => list['list_name'] == listName,
        orElse: () => null,
      );

      if (selectedList != null) {
        // Listeyi güncelle ve yeni ürünü ekle
        List<dynamic> listContent = selectedList['list_content'] as List<dynamic>;
        listContent.add(selectedProduct);

        // Firestore'a güncellenmiş veriyi kaydet
        await FirebaseFirestore.instance.collection('users').doc(_userId).update({
          'portfolyo': userLists,
        });

        print('Ürün başarıyla eklendi: $selectedProduct');
      } else {
        print('Hata: Belirtilen liste bulunamadı');
      }
    } else {
      print('Hata: Kullanıcının portföyü bulunamadı');
    }
  } catch (e) {
    print('Ürün eklenirken bir hata oluştu: $e');
  }
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
