//with purple background
import 'package:flutter/material.dart';

class ElevButtons extends StatelessWidget {
  const ElevButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      child: const Text('Button'),
    );
  }
}
//with padding
// ElevatedButton(
//             onPressed: () {},
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.red),
//                 padding: MaterialStateProperty.all(const EdgeInsets.all(50)),
//                 textStyle:
//                     MaterialStateProperty.all(const TextStyle(fontSize: 30))),
//             child: const Text('Button'),
// ),

//with shape
// ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.pink,
//               fixedSize: const Size(300, 100),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50))),
//           child: const Text('Kindacode.com'),
// ),

// MaterialApp(
//         theme: ThemeData(
//           useMaterial3: true,
//           /* other code */
//         ),
//        /* ...*/
// );
