import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database.dart';

class AddEntryModalSheet extends StatefulWidget {
  const AddEntryModalSheet({super.key});

  @override
  State<AddEntryModalSheet> createState() => _AddEntryModalSheetState();
}

class _AddEntryModalSheetState extends State<AddEntryModalSheet> {
  @override
  void dispose(){
    titleController.dispose();
    super.dispose();
  }

  final titleController = TextEditingController();
  final database = AppDatabase();
  DateTime dateSelected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(spacing: 30,children: [
        TextField(decoration: const InputDecoration(hintText: "Title"),style: Theme.of(context).textTheme.headlineLarge,controller: titleController),
        Row(children: [
          IconButton(onPressed: (){
            showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now()).then((v)=>{
              setState(() {
                dateSelected = v ?? DateTime.now();
              })
            });
          }, icon: const Icon(Icons.calendar_month)),
          Text(DateFormat('dd/MM/yyyy').format(dateSelected))
        ]),
        FilledButton(onPressed: () async {
          if(titleController.text.isEmpty){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                  title: const Text("Oh dear!"),
                  content: const Text("You've got to enter a title in order to continue"),
                  actions: [
                    TextButton(onPressed: (){Navigator.of(context).pop();}, style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge), child: const Text("Sure"))
                  ]
              );
            });
          } else {
            await database.into(database.entries).insert(
                EntriesCompanion.insert(date: dateSelected, title: titleController.text)
            );
            Navigator.pop(context);
          }
        }, child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(spacing: 8,children: [
            Icon(Icons.add),
            Text("Add")
          ]),
        ))
      ],),
    );
  }
}