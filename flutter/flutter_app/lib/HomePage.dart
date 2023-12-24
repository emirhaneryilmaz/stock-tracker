import 'package:flutter/material.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  // final String token;

  // // Constructor ile token parametresini alıyoruz
  // HomePage(this.token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Welcome to Stock Tracker',
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
                            onPressed: () {
                              _handleLikeButton();
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
    print('$assetName tıklandı');
  }

  void _handleLikeButton() {
    print('Beğen');
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
