import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalapp/database.dart';
import 'package:journalapp/entry_view.dart';
import 'package:journalapp/header_viewer.dart';

import 'helpers/get_header.dart';
import 'helpers/search_provider.dart';
import 'modals/add_entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const MainBody(),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  Future deleteSelected(int id){
    return(database.delete(database.entries)..where((i)=>i.id.equals(id))).go();
  }

  void _loadEntries() {
    database.select(database.entries).get().then((res) {
      // Sort the entries descending so the most recent is at the top
      res.sort((a, b) => b.date.compareTo(a.date));
      setState(() {
        entries = res;
      });
    });
  }

  final database = AppDatabase();
  List<Entry> entries = [];

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Journal"),
            leading: IconButton(
                onPressed: () async {
                  await showSearch(context: context, delegate: SearchProvider());
                  _loadEntries();
                },
                icon: const Icon(Icons.search)
            ),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.calendar_month)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.filter_alt))
            ]
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showModalBottomSheet<void>(context: context, builder: (BuildContext context){return const AddEntryModalSheet();});
              _loadEntries();
            },
            label: const Text("New Entry"),
            icon: const Icon(Icons.add)
        ),
        body: ListView.builder(
            itemCount: entries.length,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            itemBuilder: (context, index){
              final item = entries[index];
              bool showHeader = false;

              if(index == 0){
                showHeader = true;
              } else {
                final prevItem = entries[index-1];
                if(prevItem.date.day != item.date.day){
                  showHeader = true;
                }
              }

              Widget entryTile = ListTile(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>EntryView(entryIndex: item.id)));
                  _loadEntries();
                },
                title: Text(item.title),
                leading: Hero(
                  tag: "entry-hero-${item.id}",
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: FutureBuilder<Block?>(
                            future: getHeader(item.id),
                            builder: (context, snapshot) {
                              return HeaderViewer(headerBlock: snapshot.data);
                            }
                        ),
                      )
                  ),
                ),
                titleTextStyle: Theme.of(context).textTheme.headlineLarge,
                trailing: IconButton(onPressed: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text("If you delete this item, you won't be able to get it back"),
                        actions: [
                          TextButton(onPressed: (){Navigator.of(context).pop();}, style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge), child: const Text("Cancel")),
                          TextButton(onPressed: (){
                            deleteSelected(item.id);
                            _loadEntries();
                            Navigator.of(context).pop();
                          }, style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge), child: const Text("Delete"))
                        ]
                    );
                  });
                }, icon: const Icon(Icons.delete)),
              );

              if(showHeader){
                return Column(children: [Text(DateFormat('dd/MM/yyyy').format(item.date),style: Theme.of(context).textTheme.titleMedium), entryTile]);
              } else {
                return entryTile;
              }
            }
        )
    );
  }
}



