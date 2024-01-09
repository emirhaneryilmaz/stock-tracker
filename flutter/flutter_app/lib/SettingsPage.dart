import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

void main() {
  runApp(MyApp());
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
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('gs://stock-tracker-baris-emirhan.appspot.com/Crypto_Investment_Risk_Disclosure_Form_StockTracker.pdf');

    // Yerel depolama için bir File objesi oluşturun
    File localFile = File("local_path/Crypto_Investment_Risk_Disclosure_Form_StockTracker.pdf");

    // Dosyayı indirin ve File objesine yazın
    await reference.writeToFile(localFile);

    print("PDF dosyası indirildi ve yerel path'i: ${localFile.path}");
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
                    String confirmNewPassword = _confirmNewPasswordController.text;

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
      print("Şifre değiştirme sırasında bir hata oluştu: $error");
    }
  }
  
  TextEditingController _searchController = TextEditingController();
  List<String> sampleData = [
    "Ahmet",
    "Ayşe",
    "Ali",
    "Fatma",
    "Mehmet",
    "Zeynep",
    "Emre",
    "Ceren",
    // Diğer örnek isimleri buraya ekleyebilirsiniz.
  ];

  List<String> filteredData = [];
  List<String> _selectedNames = [];

  @override
  void initState() {
    super.initState();
    // Initialize filteredData with all names initially
    filteredData = List.from(sampleData);
  }

  void filterData(String query) {
    setState(() {
      // Filter names based on the search query
      filteredData = sampleData
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> showAddDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      onTap: () {
                        String selectedName = filteredData[index];
                        setState(() {
                          _selectedNames.add(selectedName);
                        });
                        print(_selectedNames); // Debugging line
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
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
                        'Varlıklarım',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showAddDialog(context); // context'i doğru şekilde geçtiğinizden emin olun
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
                          );
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
