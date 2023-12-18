import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'ListsPage.dart';
import 'NewsPage.dart';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            final token = settings.arguments as String? ?? 'default_token';
            return MaterialPageRoute(
              builder: (context) => HomePage(token),
            );
          // Burada diğer rotaları da ekleyebilirsiniz
          default:
            return null; // Uygun bir yönlendirme sağlanmadığında null dön
        }
      },
      title: 'Stock Tracker',
      home: LoginPage(),
      routes: {
        '/news': (context) => NewsPage(), // Haberler sayfası
        '/lists': (context) => ListsPage(), // Listelerim
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
