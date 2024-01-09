import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'LoginPage.dart';
import 'dart:async';
import '../keys.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://ws.coinapi.io/v1/'));
  Map<String, String> prices = {'BTC': '-', 'ETH': '-', 'BNB': '-' , 'SOL': '-', 'XRP': '-'};

  @override
  void initState() {
    super.initState();
    // Subscribe to the WebSocket channel
    channel.sink.add(jsonEncode({
      // WebSocket subscription details
      "type": "hello",
      "apikey": coinApiKey,
      "subscribe_data_type": ["trade"],
      "subscribe_filter_symbol_id": [
        "BINANCE_SPOT_BTC_USDT\$",
        "BINANCE_SPOT_ETH_USDT\$",
        "BINANCE_SPOT_BNB_USDT\$",
        "BINANCE_SPOT_SOL_USDT\$",
        "BINANCE_SPOT_XRP_USDT\$"
      ]
    }));

    channel.stream.listen((data) {
      final jsonData = jsonDecode(data);
      setState(() {
        // Update prices based on received data
        // Assuming jsonData contains the updated price for each asset
        if (jsonData['type'] == 'trade') {
          String symbolId = jsonData['symbol_id'];
          String price = jsonData['price'].toString();
          // Assuming 'symbol_id' tells you whether the data is for BTC or ETH
          if (symbolId.contains('BTC')) {
            prices['BTC'] = price;
          } else if (symbolId.contains('ETH')) {
            prices['ETH'] = price;
          }
          else if (symbolId.contains('BNB')) {
            prices['BNB'] = price;
          }
          else if (symbolId.contains('SOL')) {
            prices['SOL'] = price;
          }
          else if (symbolId.contains('XRP')) {
            prices['XRP'] = price;
          }
        }
      });
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  Future<List<Map<String, dynamic>>> _fetchUserListsFromFirestore() async {
    List<Map<String, dynamic>> userLists = [];

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

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
                      'Your Assets',
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
              'Populer Assets',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prices.keys
                  .length, // Adjusted to the number of assets in the prices map
              itemBuilder: (context, index) {
                String assetName = prices.keys
                    .elementAt(index); // Get the asset name (BTC, ETH)
                String assetPrice = prices[assetName] ??
                    '-'; // Get the price of the asset, default to '-'

                GlobalKey _buttonKey = GlobalKey(); // Unique key for each asset

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
                        _handleAssetTap(assetName);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              assetName[0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(assetName),
                              Text(
                                  'Price: \$${assetPrice}'), // Display the actual price
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
                            key:
                                _buttonKey, // Use the unique key for the like button
                            onPressed: () {
                              _handleLikeButton(context, _buttonKey, assetName);
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

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
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

  void _handleAssetTap(String assetName) {
    print('$assetName tiklandi');
  }

  void _handleLikeButton(
      BuildContext context, GlobalKey key, String selectedProduct) async {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;

    if (renderBox != null) {
      var offset = renderBox.localToGlobal(Offset.zero);

      List<Map<String, dynamic>> userLists =
          await _fetchUserListsFromFirestore();

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

  Future<void> _addProductToList(
      String selectedProduct, String listName) async {
    try {
      // Firestore'dan kullanıcının verilerini çek
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

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
          List<dynamic> listContent =
              selectedList['list_content'] as List<dynamic>;
          listContent.add(selectedProduct);

          // Firestore'a güncellenmiş veriyi kaydet
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_userId)
              .update({
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
