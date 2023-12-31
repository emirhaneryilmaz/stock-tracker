import 'package:flutter/material.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  // final _userIdController = TextEditingController();
  // final String token;

  // // Constructor ile token parametresini alıyoruz
  // HomePage(this.token);

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
                              _handleLikeButton(context, _buttonKey);
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

   void _handleLikeButton(BuildContext context, GlobalKey key) {
    print('Beğen');

    // IconButton'un pozisyonunu bul
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;

    // ignore: unnecessary_null_comparison
    if (renderBox != null) {
      var offset = renderBox.localToGlobal(Offset.zero);

      // PopupMenuButton kullanarak bir menü oluştur
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
        items: [
          PopupMenuItem(
            child: Text('Öğe 1'),
            value: 1,
          ),
          PopupMenuItem(
            child: Text('Öğe 2'),
            value: 2,
          ),
          PopupMenuItem(
            child: Text('Öğe 3'),
            value: 3,
          ),
        ],
        elevation: 8.0,
      ).then((value) {
        // Menü öğesi seçildiğinde yapılacak işlemleri burada ekleyebilirsiniz.
        if (value != null) {
          print('Seçilen öğe: $value');
        }
      });
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
