import 'dart:math';
import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color(0xFF4CAF50), // Màu xanh lá cây
            Color(0xFF8BC34A), // Màu xanh cây non
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black26,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Transform.rotate(
        angle: 0 * pi / 180,
        child: Text(
          'Books Review',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontFamily: 'Anton',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
