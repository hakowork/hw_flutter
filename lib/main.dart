import 'package:flutter/material.dart';

import 'page/crud_todo/index.dart';

void main() {
  runApp(const MyApp());
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hakowork x flutter'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.data_array),
            title: const Text('CRUD Todo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CRUDPage()),
              );
            },
          )
        ],
      ),
    );
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),

  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hakowork x flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(          // Add the 5 lines from here... 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
        //outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
      ),
      home: const HomeRoute(),
    );
  }
}