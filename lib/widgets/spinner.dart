import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final int tabIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: SpinKitCircle(
            color: Colors.grey[800],
            size: 50.0,
          ),
        )
      ),
    );
  }
}