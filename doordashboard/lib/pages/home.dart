import 'package:doordashboard/pages/auth.dart';
import 'package:doordashboard/pages/sales.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const SalesPage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
