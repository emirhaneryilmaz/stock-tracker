import 'dart:convert';
import 'package:flutter_app/UserAssetsEvent.dart';
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
  Future<List<Map<String, dynamic>>> _getUserAssets(String userId) async {
    try {
      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentSnapshot userDocumentSnapshot = await userDocument.get();

      Map<String, dynamic>? userData =
          userDocumentSnapshot.data() as Map<String, dynamic>?;

      List<dynamic> userAssets =
          (userData?['user_assets'] as List<dynamic>?) ?? [];

      List<Map<String, dynamic>> assetList = [];

      for (var asset in userAssets) {
        assetList.add(Map<String, dynamic>.from(asset));
      }

      print('User assets: $assetList'); // Konsola çıktıyı yazdır

      return assetList;
    } catch (e) {
      print('Firestore veri alma hatası: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> userAssets = [];
  double totalAssetsValue = 0.0;

  void _initializeUserAssets() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      List<Map<String, dynamic>> assets = await _getUserAssets(userId);
      setState(() {
        userAssets = assets;
        
      });
    }
  }

  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://ws.coinapi.io/v1/'));
  Map<String, String> prices = {
    "ADA": '-',
    "ALGO": '-',
    "ATOM": '-',
    "AVAX": '-',
    "BNB": '-',
    "BTC": '-',
    "MINA": '-',
    "DOGE": '-',
    "DOT": '-',
    "ETH": '-',
    "ICP": '-',
    "INJ": '-',
    "LINK": '-',
    "LTC": '-',
    "MATIC": '-',
    "NEAR": '-',
    "GRT": '-',
    "SHIB": '-',
    "SOL": '-',
    "NEO": '-',
    "TRX": '-',
    "UNI": '-',
    "USDC": '-',
    "USDT": '-',
    "XRP": '-',
  };

  @override
  void initState() {
    super.initState();
    // Event'i dinleyin
    UserAssetsEvent.onUserAssetsChanged.stream.listen((_) {
      _initializeUserAssets();
    });
    _initializeUserAssets();
    // Subscribe to the WebSocket channel
    channel.sink.add(jsonEncode({
      // WebSocket subscription details
      "type": "hello",
      "apikey": coinApiKey,
      "subscribe_data_type": ["trade"],
      "subscribe_filter_symbol_id": [
        "BINANCE_SPOT_ADA_USDT\$",
        "BINANCE_SPOT_ALGO_USDT\$",
        "BINANCE_SPOT_ATOM_USDT\$",
        "BINANCE_SPOT_AVAX_USDT\$",
        "BINANCE_SPOT_BNB_USDT\$",
        "BINANCE_SPOT_BTC_USDT\$",
        "BINANCE_SPOT_MINA_USDT\$",
        "BINANCE_SPOT_DOGE_USDT\$",
        "BINANCE_SPOT_DOT_USDT\$",
        "BINANCE_SPOT_ETH_USDT\$",
        "BINANCE_SPOT_ICP_USDT\$",
        "BINANCE_SPOT_INJ_USDT\$",
        "BINANCE_SPOT_LINK_USDT\$",
        "BINANCE_SPOT_LTC_USDT\$",
        "BINANCE_SPOT_MATIC_USDT\$",
        "BINANCE_SPOT_NEAR_USDT\$",
        "BINANCE_SPOT_GRT_USDT\$",
        "BINANCE_SPOT_SHIB_USDT\$",
        "BINANCE_SPOT_SOL_USDT\$",
        "BINANCE_SPOT_NEO_USDT\$",
        "BINANCE_SPOT_TRX_USDT\$",
        "BINANCE_SPOT_UNI_USDT\$",
        "BINANCE_SPOT_USDC_USDT\$",
        "BINANCE_SPOT_USDT_TRY\$",
        "BINANCE_SPOT_XRP_USDT\$",
      ]
    }));

    channel.stream.listen((data) {
      final jsonData = jsonDecode(data);
      setState(() {
        // Assuming jsonData contains the updated price for each asset
        if (jsonData['type'] == 'trade') {
          String symbolId = jsonData['symbol_id'];
          String price = jsonData['price'].toString();
          // Assuming 'symbol_id' tells you whether the data is for BTC or ETH
          if (symbolId.contains('BTC')) {
            prices['BTC'] = price;
          } else if (symbolId.contains('ETH')) {
            prices['ETH'] = price;
          } else if (symbolId.contains('BNB')) {
            prices['BNB'] = price;
          } else if (symbolId.contains('SOL')) {
            prices['SOL'] = price;
          } else if (symbolId.contains('XRP')) {
            prices['XRP'] = price;
          } else if (symbolId.contains('ADA')) {
            prices['ADA'] = price;
          } else if (symbolId.contains('ALGO')) {
            prices['ALGO'] = price;
          } else if (symbolId.contains('ATOM')) {
            prices['ATOM'] = price;
          } else if (symbolId.contains('AVAX')) {
            prices['AVAX'] = price;
          } else if (symbolId.contains('MINA')) {
            prices['MINA'] = price;
          } else if (symbolId.contains('DOGE')) {
            prices['DOGE'] = price;
          } else if (symbolId.contains('DOT')) {
            prices['DOT'] = price;
          } else if (symbolId.contains('ICP')) {
            prices['ICP'] = price;
          } else if (symbolId.contains('INJ')) {
            prices['INJ'] = price;
          } else if (symbolId.contains('LINK')) {
            prices['LINK'] = price;
          } else if (symbolId.contains('LTC')) {
            prices['LTC'] = price;
          } else if (symbolId.contains('MATIC')) {
            prices['MATIC'] = price;
          } else if (symbolId.contains('NEAR')) {
            prices['NEAR'] = price;
          } else if (symbolId.contains('GRT')) {
            prices['GRT'] = price;
          } else if (symbolId.contains('SHIB')) {
            prices['SHIB'] = price;
          } else if (symbolId.contains('NEO')) {
            prices['NEO'] = price;
          } else if (symbolId.contains('TRX')) {
            prices['TRX'] = price;
          } else if (symbolId.contains('UNI')) {
            prices['UNI'] = price;
          } else if (symbolId.contains('USDC')) {
            prices['USDC'] = price;
          } else if (symbolId.contains('USDT')) {
            prices['USDT'] = price;
          }
        }

        // Fiyatları güncelle ve toplam varlık değerini hesapla
        updatePricesAndCalculateTotalValue(jsonData);
      });
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  void updatePricesAndCalculateTotalValue(dynamic jsonData) {
    if (jsonData['type'] == 'trade') {
      String symbolId = jsonData['symbol_id']; // Örn: "BINANCE_SPOT_ETH_USDT"
      double price = double.tryParse(jsonData['price'].toString()) ?? 0.0;
      // Fiyatı güncelle
      prices[symbolId] = price.toString(); // double'dan String'e çevirme

      // Toplam varlık değerini hesapla
      totalAssetsValue = 0.0;
      for (var asset in userAssets) {
        String coinName = asset['coin_name']; // Örn: "ETH"
        double amount = asset['amount']; // Örn: 4

        // WebSocket'ten gelen veri ile eşleşecek şekilde anahtar oluştur
        String assetKey = "BINANCE_SPOT_${coinName}_USDT";

        // Eşleşen fiyatı al ve miktarla çarp
        double assetPrice = double.tryParse(prices[assetKey] ?? '0.0') ?? 0.0;

        totalAssetsValue += assetPrice * amount;
      }
    }
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
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Gölge rengi ve opaklığı
                    spreadRadius: 4, // Yayılma yarıçapı
                    blurRadius: 7, // Bulanıklık yarıçapı
                    offset: Offset(0, 3), // Gölgenin konumu (x, y)
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Assets',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '\$${totalAssetsValue.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
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
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                  height: 65.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: InkWell(
                      onTap: () {
                        _handleAssetTap(assetName);
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                    '../utils/$assetName.png'),
                                // child: Text(
                                //   assetName[0],
                                //   style: TextStyle(color: Colors.white),
                                // ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(assetName),
                                    Text('Price: \$${assetPrice}'),
                                  ],
                                ),
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
                                  _handleLikeButton(
                                      context, _buttonKey, assetName);
                                },
                                icon: Icon(Icons.thumb_up),
                              ),
                            ],
                          ),
                          Divider(),
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
