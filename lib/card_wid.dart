import 'package:flutter/material.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.deepPurpleAccent, //<-- SEE HERE
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Text(
          'Product Name',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
