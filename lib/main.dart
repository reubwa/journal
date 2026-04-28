import 'package:drift/drift.dart' hide Column;
import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalapp/database.dart';
import 'package:journalapp/entry_view.dart';
import 'package:journalapp/header_viewer.dart';
import 'package:journalapp/settings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'helpers/get_header.dart';
import 'helpers/search_provider.dart';
import 'modals/add_entry.dart';

/*
* I confirm that no AI tools were used in the preparation or completion of this assessment.
* This submission aligns with AITS 1 of the Artificial Intelligence Transparency Scale (AITS).
* */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyNotify.init();
  await EasyNotifyPermissions.requestAll();
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
  List<Map<String, Entry>> heroEntries = [];
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    _loadEntries();
    super.initState();
  }

  void jumpToDate(DateTime targetDate) {
    final index = entries.indexWhere((item) => item.date.year == targetDate.year && item.date.month == targetDate.month && item.date.day == targetDate.day);
    if (index != -1) {
      // Jump to the found index
      _itemScrollController.jumpTo(index: index);
    }
  }

  Future getEntryByDate(DateTime dt){
    return(database.select(database.entries)..where((fil)=>fil.date.year.equals(dt.year))
      ..where((fil)=>fil.date.month.equals(dt.month))
      ..where((fil)=>fil.date.day.equals(dt.day))
    ).getSingleOrNull();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Journal"),
            leading: IconButton(
                onPressed: () async {
                  await showSearch(context: context, delegate: SearchProvider());
                  if (!context.mounted) return;
                  _loadEntries();
                },
                icon: const Icon(Icons.search)
            ),
            actions: [
              IconButton(onPressed: ()=>{
                showDatePicker(context: context, firstDate: DateTime(1900), lastDate: DateTime.now()).then((res)=>{
                  jumpToDate(res!)
                })
              }, icon: const Icon(Icons.calendar_month)),
              IconButton(onPressed: ()=>{
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const Settings()))
              }, icon: const Icon(Icons.settings))
            ]
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showModalBottomSheet<void>(context: context, builder: (BuildContext context){return const AddEntryModalSheet();});
              if (!context.mounted) return;
              _loadEntries();
            },
            label: const Text("New Entry"),
            icon: const Icon(Icons.add)
        ),
        body: Column(
          children: [
            Expanded(
              child: ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
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
                        if (!context.mounted) return;
                        _loadEntries();
                      },
                      title: Text(item.title),
                      key: Key(index.toString()),
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
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const ColoredBox(color: Colors.grey);
                                    }
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
              ),
            ),
          ],
        )
    );
  }
}