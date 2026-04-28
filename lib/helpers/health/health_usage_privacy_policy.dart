import 'package:flutter/material.dart';

class HealthUsagePrivacyPolicy extends StatelessWidget {
  const HealthUsagePrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Usage Privacy Policy"),
        leading: IconButton(onPressed: ()=>{Navigator.pop(context)}, icon: Icon(Icons.close))
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("This app can connect to your health data so that you can easily add it to your journal. No data other than what you choose is accessed and at no time does it leave your device."),
        ),
      ),
    );
  }
}
