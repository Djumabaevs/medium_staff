import 'package:flutter/material.dart';

class CardWithDiffSides extends StatelessWidget {
  const CardWithDiffSides({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
  shape: RoundedRectangleBorder( //<-- 1. SEE HERE
    side: BorderSide(
      color: Colors.greenAccent,
      width: 3,
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
),
Card( 
  shape: BeveledRectangleBorder( //<-- 2. SEE HERE
    side: BorderSide(
      color: Colors.greenAccent,
      width: 3,
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
),
Card(
  shape: StadiumBorder( //<-- 3. SEE HERE
    side: BorderSide(
      color: Colors.greenAccent,
      width: 2.0,
    ),
  ),
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text(
      'Product Name',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
  ),
),;
  }
}

//shadow
Container(
  child: new Card(
    child: Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Product Name',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  decoration: new BoxDecoration(
    boxShadow: [
      BoxShadow( //<-- SEE HERE
        color: Colors.greenAccent,
        blurRadius: 10.0,
      ),
    ],
  ),
)

//thick border
Card(
  shape: RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.greenAccent,
      width: 5, //<-- SEE HERE
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
)