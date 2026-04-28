import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database.dart';
import '../entry_view.dart';
import '../header_viewer.dart';
import 'get_header.dart';

class SearchProvider extends SearchDelegate{
  final database = AppDatabase();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  Future<List<Entry>> fetchResults(String q){
    if (q.isEmpty) return Future.value([]);
    return (database.select(database.entries)..where((i)=>i.title.like('%$q%'))).get();
  }


  Widget _buildList(BuildContext context, String searchQuery) {
    return FutureBuilder<List<Entry>>(
        future: fetchResults(searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred whilst fetching results.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          final res = snapshot.data!;
          return ListView.builder(
              itemCount: res.length,
              padding: const EdgeInsets.only(top: 8,bottom: 8),
              itemBuilder: (context, index){
                final item = res[index];
                bool showHeader = false;
                if(index == 0){
                  showHeader = true;
                } else {
                  final prevItem = res[index-1];
                  if(prevItem.date.day != item.date.day){
                    showHeader = true;
                  }
                }
                Widget entryTile = ListTile(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context)=>EntryView(entryIndex: item.id)));
                      query = query;
                    },
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
                    title: Text(item.title),
                    titleTextStyle: Theme.of(context).textTheme.headlineLarge
                );

                if(showHeader){
                  return Column(children: [
                    Text(
                        DateFormat('dd/MM/yyyy').format(item.date),
                        style: Theme.of(context).textTheme.titleMedium
                    ),
                    entryTile
                  ]);
                } else {
                  return entryTile;
                }
              }
          );
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context, query);
  }
}