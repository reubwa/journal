import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journalapp/block_editors/add_block.dart';
import 'package:journalapp/block_editors/pathfinders/catchall.dart';
import 'package:journalapp/block_editors/pathfinders/text_doodle.dart';
import 'package:journalapp/block_viewer.dart';
import 'package:journalapp/header_editors/edit_header.dart';
import 'package:journalapp/header_viewer.dart';
import 'package:journalapp/helpers/ll_string_to_float_pair.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:map_launcher/map_launcher.dart';

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

  Future _deleteBlock(int id){
    return (database.delete(database.blocks)..where((i)=>i.id.equals(id))..where((i)=>i.parentEntry.equals(widget.entryIndex))).go();
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

    final blocks = await (database.select(database.blocks)
      ..where((i)=>i.parentEntry.equals(widget.entryIndex))
      ..where((i)=>i.isHeader.equals(false))).get();

    return {
      'entry': entry,
      'header': headerBlock,
      'blocks': blocks
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
          final theseBlocks = snapshot.data!['blocks'] as List<Block>?;
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
                                        EditHeader(entryId: thisEntry.id, entryDate: thisEntry.date)));
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
                    itemCount: theseBlocks?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = theseBlocks?[index];
                      return Container(
                        height: 100.0,
                        child: Row(
                          children: [
                            Expanded(child: BlockViewer(headerBlock: item, isExpanded: false,)),
                            MenuAnchor(
                              builder: (context, controller, child) {
                                return IconButton(
                                  onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                                  icon: const Icon(Icons.more_vert),
                                );
                              },
                              menuChildren: [
                                MenuItemButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>BlockExpanded(item: item)));
                                }, child: Row(spacing: 8, children: [
                                  Icon(Icons.open_in_new),
                                  Text("Expand")
                                ],)),
                                item?.type == BlockTypes.text || item?.type == BlockTypes.doodle ?
                                MenuItemButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>TextDoodlePathfinder(block: item!))).then((_)=>{
                                    setState(() {
                                      _fetchPageData();
                                    })
                                  });
                                }, child: Row(spacing: 8, children: [
                                  Icon(Icons.edit),
                                  Text("Edit")
                                ],))
                                    : MenuItemButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>CatchallPathfinder(block: item!, dt: thisEntry.date))).then((_)=>{
                                    setState(() {
                                      _fetchPageData();
                                    })
                                  });
                                }, child: Row(spacing: 8, children: [
                                  Icon(Icons.change_circle),
                                  Text("Replace")
                                ])),
                                MenuItemButton(onPressed: () {
                                  _deleteBlock(item!.id).then((_)=>{
                                    setState(() {
                                      _fetchPageData();
                                    })
                                  });
                                }, child: Row(spacing: 8, children: [
                                  Icon(Icons.delete),
                                  Text("Delete")
                                ],))
                              ],
                            )

                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AddBlock(entryId: thisEntry.id, entryDate: thisEntry.date))).then((_){
                  setState(() {
                    _fetchPageData();
                  });
                });
              }, child: Icon(Icons.add_comment))
          );
        }
        return const Scaffold();
      },
    );
  }
}

class BlockExpanded extends StatelessWidget {
  const BlockExpanded({
    super.key,
    required this.item,
  });

  final Block? item;

  Future _displayMap() async {
    final LatLong coords = llStringToFloatPair(item!.txt);
    final availableMaps = await MapLauncher.installedMaps;

    return availableMaps.first.showMarker(coords: Coords(coords.latitude, coords.longitude), title: "Location from Journal Entry");
  }

  Future _displayDirections() async {
    final LatLong coords = llStringToFloatPair(item!.txt);
    final availableMaps = await MapLauncher.installedMaps;

    return availableMaps.first.showDirections(destination: Coords(coords.latitude, coords.longitude), destinationTitle: "Location from Journal Entry");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=>{Navigator.pop(context)}, icon: Icon(Icons.close)),
        title: Text("Block"),
        actions: item!.type == BlockTypes.location ? [IconButton(onPressed: _displayMap, icon: Icon(Icons.map)), IconButton(onPressed: _displayDirections, icon: Icon(Icons.directions))] : [],
      ),
      body: BlockViewer(headerBlock: item, isExpanded: true)
    );
  }
}