import 'package:flutter/material.dart';

class ThreeDotsWidget extends StatelessWidget {
  const ThreeDotsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 50,
      height: 20,
      child: Stack(
        children: [
          Positioned(
            left: 30,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.orange,
            ),
          ),
          Positioned(
            left: 15,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.blueAccent,
            ),
          ),
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
