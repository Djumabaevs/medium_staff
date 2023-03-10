import 'package:flutter/material.dart';

class CardWithLeftSide extends StatelessWidget {
  const CardWithLeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.greenAccent, width: 5),
            ),
          ),
          child: Text(
            'Product Name',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      ),
    );
  }
}
