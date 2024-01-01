import 'package:flutter/material.dart';
import 'package:flutter_app/SettingsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../keys.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<void> _onRefresh() async {
    await fetchNews();
  }

  List newsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=crypto&language=en&sortBy=relevancy&pageSize=10&page=1&apiKey=$newsApiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          newsData = data['articles'];
          isLoading = false;
        });
      } else {
        print('API isteğinde hata: ${response.statusCode}');
      }
    } catch (e) {
      print('API isteği sırasında hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: newsData.length,
                itemBuilder: (context, index) {
                  final article = newsData[index];
                  return GestureDetector(
                    onTap: () => _launchURL(article['url']),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(15.0)),
                                child: Image.network(
                                  article['urlToImage'] ??
                                      'https://via.placeholder.com/150',
                                  fit: BoxFit.cover,
                                  height: 100.0,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      '../utils/news-placeholder.png', // Yerel bir yedek resim
                                      fit: BoxFit.cover,
                                      height: 100.0,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'] ?? 'Haber Başlığı',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      article['description'] ??
                                          'Haber içeriği burada yer alacak.',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'URL açılamadı: $url';
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
}
