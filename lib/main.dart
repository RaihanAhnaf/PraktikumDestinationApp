import 'package:destination_app/detail_screen.dart';
import 'package:destination_app/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // import firebase_core
import 'package:destination_app/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Destination App Gan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => const HomePage(),
        '/edit':(context) => const EditPage(),
        '/detail':(context)=>DetailScreen()
      },
    );
  }
}
