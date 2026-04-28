import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        title: Text("Settings"),
      ),
      body: Center(
        child: Padding(padding: EdgeInsetsGeometry.all(8), child: Column(
          spacing: 8,
          children: [
            FilledButton(onPressed: (){
              EasyNotify.showRepeatedNotification(
                id: 2,
                title: "It's time to be mindful!",
                body: 'How about taking a minute to write a journal entry?',
              );
            }, child: Text("Set Daily Notification Reminder")),
            OutlinedButton(onPressed: (){
              EasyNotify.showBasicNotification(
                id: 1,
                title: "It's time to be mindful!",
                body: 'How about taking a minute to write a journal entry?',
              );
            }, child: Text("Trigger Example of Notification Reminder"))
          ],
        ),),
      ),
    );
  }
}
