import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalapp/header_editors/edit_header.dart';
import 'package:journalapp/header_viewer.dart';

import 'database.dart';
import 'helpers/scaffolded/error_handler.dart';
import 'helpers/scaffolded/sliver_loading_handler.dart';
import 'modals/edit_entry.dart';

class EntryView extends StatefulWidget {
  final int entryIndex;
  const EntryView({super.key, required this.entryIndex});

  @override
  State<EntryView> createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  final database = AppDatabase();
  late Future<Map<String, dynamic>> _pageDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchPageData();
  }

  void _fetchPageData() {
    _pageDataFuture = _loadData();
  }

  // Fetch both the entry and the header block before rendering the screen
  Future<Map<String, dynamic>> _loadData() async {
    final entry = await (database.select(database.entries)
      ..where((i) => i.id.equals(widget.entryIndex)))
        .getSingle();

    final headerBlock = await (database.select(database.blocks)
      ..where((fil) => fil.isHeader.equals(true))
      ..where((fil) => fil.positionAmongstSiblings.equals(0))
      ..where((fil) => fil.parentEntry.equals(widget.entryIndex))
    // limit(1) safeguards against accidental duplicate insertions
      ..limit(1))
        .getSingleOrNull();

    return {
      'entry': entry,
      'header': headerBlock,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _pageDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ScaffoldedSliverLoadingHandler(widget: widget);
        } else if (snapshot.hasError) {
          return ScaffoldedErrorHandler(snapshot: snapshot);
        } else if (snapshot.hasData) {
          final thisEntry = snapshot.data!['entry'] as Entry;
          final thisHeader = snapshot.data!['header'] as Block?;

          return Scaffold(
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  stretch: true,
                  stretchTriggerOffset: 300,
                  expandedHeight: 300,
                  pinned: true,
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EditHeader(entryId: thisEntry.id)));
                          setState(() {
                            _fetchPageData();
                          });
                        },
                        icon: const Icon(Icons.insert_page_break)),
                    IconButton(
                        onPressed: () async {
                          await showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return EditEntryModalSheet(recId: thisEntry.id);
                              });
                          setState(() {
                            _fetchPageData();
                          });
                        },
                        icon: const Icon(Icons.edit))
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    title: LayoutBuilder(
                      builder: (context, constraints) {
                        final isExpanded = constraints.maxHeight >
                            kToolbarHeight +
                                (MediaQuery.of(context).padding.top);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(thisEntry.title),
                            Visibility(
                              visible: isExpanded,
                              maintainState: false,
                              replacement: const SizedBox.shrink(),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(thisEntry.date),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    background: Hero(
                        tag: "entry-hero-${thisEntry.id}",
                        child: HeaderViewer(headerBlock: thisHeader)),
                  ),
                ),
                SliverList.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: index.isOdd ? Colors.white : Colors.black12,
                      height: 100.0,
                      child: Center(
                        child: Text(
                          '$index',
                          textScaler: const TextScaler.linear(5.0),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const Scaffold();
      },
    );
  }
}