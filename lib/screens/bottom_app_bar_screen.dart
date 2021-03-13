import 'package:flutter/material.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:note_app/screens/trash_note_screen.dart';

class BottomNayBar extends StatefulWidget {
  @override
  _BottomNayBarState createState() => _BottomNayBarState();
}

class _BottomNayBarState extends State<BottomNayBar> {
  int currentScreen = 0;

  final List<Widget> screens = [
    HomeScreen(),
    TrashTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentScreen],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewTaskScreen()));
        },
        child: Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    currentScreen = 0;
                  });
                },
                tooltip: 'Home',
                iconSize: currentScreen == 0 ? 35.0 : 24.0,
                color: currentScreen == 0 ? Colors.red : Colors.grey,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    currentScreen = 1;
                  });
                },
                iconSize: currentScreen == 1 ? 35.0 : 24.0,
                tooltip: 'Trash',
                color: currentScreen == 1 ? Colors.red : Colors.grey,
              )
            ],
          )),
    );
  }
}
