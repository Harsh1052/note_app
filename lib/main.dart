import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_task.dart';
import 'model/firebase_events.dart';
import 'screens/bottom_app_bar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
      create: (context) => NoteBloc(firebaseCRUD: FirebaseCRUD()),
      lazy: false,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Note App',
          theme: ThemeData(
              primarySwatch: Colors.red, accentColor: Colors.redAccent),
          home: BottomNayBar()),
    );
  }
}
