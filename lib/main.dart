import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/bottom_app_bar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme:
          ThemeData(primarySwatch: Colors.red, accentColor: Colors.redAccent),
      home: BottomNayBar(),
    );
  }
}
