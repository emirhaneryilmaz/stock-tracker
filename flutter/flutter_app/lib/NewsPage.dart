import 'package:flutter/material.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'News',
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
        itemCount: 5, // Örnek olarak 5 haber
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Yuvarlak köşeler
              ),
              child: Row(
                children: [
                  // Sol tarafta yuvarlak köşeli resim
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15.0), // Sadece sol taraf yuvarlak
                      ),
                      child: Image.network(
                        'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        height: 100.0,
                      ),
                    ),
                  ),
                  // Sağ tarafta başlık ve içerik
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Haber Başlığı $index',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Haber içeriği burada yer alacak. Bu kısım, haberin kısa bir özeti olabilir.',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
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

