import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MainScreen.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // User successfully registered, now add user info to Firestore
      await _addUserToFirestore(userCredential.user!.uid);

      // Navigate to the main page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );

      print("User registered: ${userCredential.user!.uid}");
      // Optionally: Do something else after successful registration
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      _showRegistrationErrorAlert(context, e.message ?? 'An error occurred during registration.');
    } catch (e) {
      print("General error: $e");
      // Optionally: Handle other errors
      _showRegistrationErrorAlert(context, 'An error occurred during registration.');
    }
  }

  Future<void> _addUserToFirestore(String userId) async {
    try {
      // Firestore'da 'users' koleksiyonuna kullanıcı belgesi eklenir
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'portfolyo': {
          'title': 'Portföy', // Default olarak eklenen liste
          // Diğer alanları eklemek isterseniz buraya ekleyebilirsiniz.
        },
        // Diğer kullanıcı özel bilgilerini eklemek isterseniz buraya ekleyebilirsiniz.
      });

      print('User added to Firestore: $userId');
    } catch (e) {
      print('Firestore error: $e');
      // Handle Firestore errors here
    }
  }

  void _showRegistrationErrorAlert(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
      appBar: AppBar(
        title: Text('Sign up Page'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _register();
                    },
                    child: Text('Sign up'),
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
