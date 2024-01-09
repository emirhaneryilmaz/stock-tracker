import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginPage.dart';
import 'ListsPage.dart';
import 'NewsPage.dart';
import 'HomePage.dart';
import 'SettingsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      storageBucket: "gs://stock-tracker-baris-emirhan.appspot.com", 
      apiKey: "AIzaSyCtXUNJXvoIEzqnkh8LJmHmIyhcaQ3UzH4",
      appId: "1:447049274163:android:545b52892c691195bf2446",
      messagingSenderId: "447049274163",
      projectId: "stock-tracker-baris-emirhan",
    ),
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Bildirim alındığında yapılacak işlemler
    print('Bildirim alındı: ${message.notification!.title}');
  });

   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Uygulama açıkken bildirim tıklandığında yapılacak işlemler
    print('Uygulama açıkken bildirim tıklandı: ${message.notification!.title}');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            // final token = settings.arguments as String? ?? 'default_token';
            return MaterialPageRoute(
              builder: (context) => HomePage(),
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
        '/settings' :(context) => SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
