import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productes'),
      ),
      body: const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(74, 20, 140, 1),
          strokeWidth: 6.0,
        ),
      ),
    );
  }
}
