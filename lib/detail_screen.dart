import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';
  DetailScreen({Key? key}) : super(key: key);

  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('destination');

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(place['image']),
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                place['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  Column(
                    children: <Widget> [
                      Icon(Icons.watch_later_outlined),
                      Text(place['jam'])
                    ],
                  ),
                  Column(
                    children: <Widget> [
                      Icon(Icons.attach_money_outlined),
                      Text(place['tiket'].toString())
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                place['description'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      )
    );
  }
}
