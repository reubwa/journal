import 'package:flutter/material.dart';

import '../../database.dart';

class ScaffoldedErrorHandler extends StatelessWidget {
  AsyncSnapshot<Map<String, dynamic>> snapshot;
  ScaffoldedErrorHandler({
    super.key, required this.snapshot
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () { Navigator.pop(context); },
            icon: const Icon(Icons.arrow_back)
        ),
        title: const Text('Error'),
      ),
      body: Center(child: Text('Error: ${snapshot.error}')),
    );
  }
}