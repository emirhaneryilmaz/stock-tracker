import 'package:flutter/material.dart';
import 'package:flutter_app/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ListsPage ());
}

class ListsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Lists',
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
              _handleSettings();
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
        itemCount: 10, // Örnek olarak 10 elemanlı liste
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.list), // Her liste öğesinin başında bir ikon
            title: Text('Liste Öğesi $index'),
            subtitle: Text('Detaylar burada gösterilecek'),
            trailing: Icon(Icons.arrow_forward_ios), // Sağ tarafta bir ikon
            onTap: () {
              // Liste öğesi tıklandığında yapılacak işlem
              print('Liste Öğesi $index tıklandı');
            },
          );
        },
      ),
    );
  }

    void _handleSettings() {
    print('Settings');
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



class ListsLightMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 18,
                top: 56,
                child: Text(
                  'Lists',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 0.04,
                    letterSpacing: -0.41,
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 96,
                child: Container(
                  width: 360,
                  height: 65,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 327,
                top: 116,
                child: Container(
                  width: 24,
                  height: 24,
                  child: Stack(children: [
                  
                  ]),
                ),
              ),
              Positioned(
                left: 22,
                top: 104,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFF66D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 35,
                top: 112,
                child: SizedBox(
                  width: 23,
                  height: 32,
                  child: Text(
                    'A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                      height: 0.04,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 104,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFF66D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 35,
                top: 112,
                child: SizedBox(
                  width: 23,
                  height: 32,
                  child: Text(
                    'F',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w700,
                      height: 0.04,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 90,
                top: 117,
                child: Text(
                  'Favoriler',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                    letterSpacing: -0.41,
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 177,
                child: Container(
                  width: 360,
                  height: 65,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 327,
                top: 197,
                child: Container(
                  width: 24,
                  height: 24,
                  child: Stack(children: [
                  
                  ]),
                ),
              ),
              Positioned(
                left: 22,
                top: 185,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFF66D8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 35,
                top: 193,
                child: SizedBox(
                  width: 23,
                  height: 32,
                  child: Text(
                    'A',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                      height: 0.04,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 185,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: Color(0xFF7B2D26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 35,
                top: 193,
                child: SizedBox(
                  width: 23,
                  height: 32,
                  child: Text(
                    'L',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w700,
                      height: 0.04,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 98,
                top: 198,
                child: Text(
                  'Liste 2',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 0.10,
                    letterSpacing: -0.41,
                  ),
                ),
              ),
              Positioned(
                left: 339,
                top: 52,
                child: Container(
                  width: 24,
                  height: 24,
                  child: Stack(children: [
                  
                  ]),
                ),
              ),
              Positioned(
                left: 0,
                top: 796,
                child: Container(
                  width: 392,
                  height: 56,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 392,
                          height: 56,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 301,
                        top: 15,
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 3,
                                top: 1,
                                child: Container(
                                  width: 18,
                                  height: 21.62,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("https://via.placeholder.com/18x22"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 57,
                        top: 19.50,
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 3,
                                child: Container(
                                  width: 20,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("https://via.placeholder.com/20x18"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 179,
                        top: 16,
                        child: Container(
                          width: 24,
                          height: 24,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 1,
                                top: 2,
                                child: Container(
                                  width: 21.78,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("https://via.placeholder.com/22x20"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}