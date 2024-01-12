import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/UserAssetsEvent.dart';
import 'dart:html' as html;
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

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

    return assetList;
  } catch (e) {
    print('Firestore veri alma hatası: $e');
    return [];
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> downloadPDF() async {
    try {
      // Firebase Storage referansını alın
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref(
              'gs://stock-tracker-baris-emirhan.appspot.com/Crypto_Investment_Risk_Disclosure_Form_StockTracker.pdf');

      // Dosyanın URL'sini alın
      String downloadURL = await reference.getDownloadURL();

      // URL'yi kullanarak dosyayı indirin
      html.AnchorElement(href: downloadURL)
        ..target = 'a_target_name' // İstediğiniz bir hedef adı verin
        ..click();

      print("PDF dosyası indirildi");
    } catch (error) {
      print("PDF indirme sırasında bir hata oluştu: $error");
    }
  }

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  Future<void> changePassword() async {
    try {
      // Firebase Authentication servisini kullanmak için bir referans oluşturun
      FirebaseAuth _auth = FirebaseAuth.instance;

      // Kullanıcının mevcut kimlik bilgilerini alın
      User? user = _auth.currentUser;

      // Popup menü gösterimi
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Old password',
                  ),
                ),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New password',
                  ),
                ),
                TextField(
                  controller: _confirmNewPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New password again.',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // Kullanıcının girdiği değerleri al
                    String oldPassword = _oldPasswordController.text;
                    String newPassword = _newPasswordController.text;
                    String confirmNewPassword =
                        _confirmNewPasswordController.text;

                    // Eski şifre kontrolü
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user?.email ?? '',
                      password: oldPassword,
                    );
                    await user?.reauthenticateWithCredential(credential);

                    // Yeni şifrelerin eşleşip eşleşmediğini kontrol et
                    if (newPassword == confirmNewPassword) {
                      // Şifre değiştirme işlemini başlat
                      await user?.updatePassword(newPassword);
                      print("Password changed succesfully.");
                    } else {
                      print("New passwords does not match.");
                    }

                    // Popup menüyü kapat
                    Navigator.of(context).pop();
                  },
                  child: Text("Change"),
                ),
              ],
            ),
          );
        },
      );
    } catch (error) {
      print("An error occurred while changing the password: $error");
    }
  }

  TextEditingController _searchController = TextEditingController();
  List<String> sampleData = [
    "ADA",
    "ATOM",
    "AVAX",
    "BNB",
    "BTC",
    "MINA",
    "DOGE",
    "DOT",
    "ETH",
    "ICP",
    "INJ",
    "LINK",
    "LTC",
    "MATIC",
    "NEAR",
    "GRT",
    "SHIB",
    "SOL",
    "NEO",
    "TRX",
    "UNI",
    "USDC",
    "USDT",
    "SAND"
        "XRP"
  ];

  List<String> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadUserAssets();
    // Initialize filteredData with all names initially
    filteredData = List.from(sampleData);
  }

  Future<void> _loadUserAssets() async {
    List<Map<String, dynamic>> userAssets = await _getUserAssets(_userId);

    setState(() {
      _selectedNames =
          userAssets.map((asset) => asset['coin_name'] as String).toList();
      _selectedQuantities =
          userAssets.map((asset) => asset['amount'] as int).toList();
    });
  }

  void filterData(String query) {
    setState(() {
      // Filter names based on the search query
      filteredData = sampleData
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  List<String> _selectedNames = [];
  List<int> _selectedQuantities = [];
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> showAddDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedName = ""; // Seçilen ürün adını saklamak için
        int? selectedQuantity; // Seçilen adet sayısını saklamak için (nullable)

        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    filterData(query);
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredData[index]),
                      onTap: () async {
                        // Adet girişi için bir dialog göster
                        selectedQuantity =
                            await showQuantityInputDialog(context);

                        if (selectedQuantity != null && selectedQuantity! > 0) {
                          selectedName = filteredData[index];

                          // Ek parametreleri ekleyerek _saveListToFirestore'yi çağırın
                          await _saveListToFirestore(
                              _userId, selectedName, selectedQuantity!);
                          await _loadUserAssets();

                          print(
                              "Selected Name: $selectedName, Quantity: $selectedQuantity");
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (selectedQuantity != null && selectedQuantity! > 0) {
                    await _saveListToFirestore(
                        _userId, selectedName, selectedQuantity!);

                    // Seçilen ürün ve adeti ayrı ayrı kaydet
                    _selectedNames.add(selectedName);
                    _selectedQuantities.add(selectedQuantity!);
                    print(_selectedNames); // Debugging line
                    print(_selectedQuantities); // Debugging line

                    await _loadUserAssets();
                  }
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveListToFirestore(
      String userId, String coinName, int amount) async {
    try {
      // Kullanıcının UID'siyle ilişkilendirilmiş belirli bir belge oluşturun
      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // user_assets adlı array içindeki bir dokümanı alın
      DocumentSnapshot userDocumentSnapshot = await userDocument.get();

      // Explicitly cast the dynamic data to Map<String, dynamic>
      Map<String, dynamic>? userData =
          userDocumentSnapshot.data() as Map<String, dynamic>?;

      // Check if 'user_assets' exists in the data and is a List<dynamic>
      List<dynamic> userAssets =
          (userData?['user_assets'] as List<dynamic>?) ?? [];

      // Yeni bir map oluşturun
      Map<String, dynamic> newMap = {
        'coin_name': coinName,
        'amount': amount,
      };

      // Yeni map'i user_assets array'inin içine ekleyin
      userAssets.add(newMap);

      // Oluşturulan belgeyi güncelleyin
      await userDocument.update({
        'user_assets': userAssets,
      });

      // Event'i yayınlayın
      UserAssetsEvent.notifyUserAssetsChanged();

      print('Yeni map eklendi: $newMap');
    } catch (e) {
      print('Firestore veri ekleme hatası: $e');
    }
  }

  void _deleteAsset(int index) async {
    try {
      // Kullanıcının UID'siyle ilişkilendirilmiş belirli bir belgeyi alın
      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(_userId);

      // user_assets adlı array içindeki bir dokümanı alın
      DocumentSnapshot userDocumentSnapshot = await userDocument.get();

      // Explicitly cast the dynamic data to Map<String, dynamic>
      Map<String, dynamic>? userData =
          userDocumentSnapshot.data() as Map<String, dynamic>?;

      // Check if 'user_assets' exists in the data and is a List<dynamic>
      List<dynamic> userAssets =
          (userData?['user_assets'] as List<dynamic>?) ?? [];

      // Seçilen varlığı listeden kaldırın
      userAssets.removeAt(index);

      // Kaldırılan varlığı güncellenmiş listeyle birlikte Firestore'a geri kaydedin
      await userDocument.update({
        'user_assets': userAssets,
      });

      // Event'i yayınlayın
      UserAssetsEvent.notifyUserAssetsChanged();

      // _loadUserAssets fonksiyonunu kullanarak ListView'ı güncelleyin
      await _loadUserAssets();

      print('Varlık silindi: index $index');
    } catch (e) {
      print('Firestore veri silme hatası: $e');
    }
  }

// Adet girişi için bir dialog gösteren fonksiyon
  Future<int?> showQuantityInputDialog(BuildContext context) async {
    int? quantity; // nullable integer

    return showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              quantity = int.tryParse(value);
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(quantity);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kullanıcı Kartı
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  // Boş profil resmi
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('kullanici@email.com'),
                  ],
                ),
              ],
            ),
          ),

          // Butonlar
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    changePassword();
                  },
                  child: Text('Change Password'),
                ),
                ElevatedButton(
                  onPressed: () {
                    downloadPDF();
                  },
                  child: Text('Download Risk Disclosure Form'),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // yapılacak işlemler
                //   },
                //   child: Text('Buton 3'),
                // ),
              ],
            ),
          ),

          // Varlıklar Listesi
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'My Assets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showAddDialog(
                              context); // context'i doğru şekilde geçtiğinizden emin olun
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Seçilen isimleri göster
                  Expanded(
                    child: Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _selectedNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Text(_selectedNames[index]),
                              subtitle:
                                  Text('Amount: ${_selectedQuantities[index]}'),
                              trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    // silme metodu çağır.
                                    _deleteAsset(index);
                                  }));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
