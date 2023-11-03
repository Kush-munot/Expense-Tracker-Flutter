// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  const PlusButton({super.key, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 65,
        width: 65,
        decoration:
            BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle),
        child: const Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
