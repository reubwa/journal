import 'package:flutter/material.dart';
import 'package:journalapp/database.dart';
import 'package:journalapp/header_editors/add_header.dart';
import 'package:journalapp/header_viewer.dart';
import 'package:journalapp/helpers/get_header.dart';

class EditHeader extends StatefulWidget {
  int entryId = 0;
  EditHeader({super.key, required this.entryId});

  @override
  State<EditHeader> createState() => _EditHeaderState();
}

class _EditHeaderState extends State<EditHeader> {
  bool isLoading = true;
  bool hasHeaderBlock = false;
  final database = AppDatabase();

  Future checkIfHasHeaderBlock() async {
    final query = database.select(database.blocks);
    query.where((fil)=>fil.isHeader.equals(true));
    query.where((fil)=>fil.parentEntry.equals(widget.entryId));
    query.where((fil)=>fil.positionAmongstSiblings.equals(0));

    final res = await query.getSingleOrNull();

    if (mounted) {
      setState(() {
        hasHeaderBlock = res != null;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfHasHeaderBlock();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return hasHeaderBlock ? HeaderEditor(entryId: widget.entryId) : AddHeader(entryId: widget.entryId);
  }
}

class HeaderEditor extends StatefulWidget {
  int entryId = 0;
  HeaderEditor({super.key, required this.entryId});

  @override
  State<HeaderEditor> createState() => _HeaderEditorState();
}

class _HeaderEditorState extends State<HeaderEditor> {
  final database = AppDatabase();
  Future deleteHeader(){
    final query = database.delete(database.blocks);
    query.where((fil)=>fil.isHeader.equals(true));
    query.where((fil)=>fil.parentEntry.equals(widget.entryId));
    query.where((fil)=>fil.positionAmongstSiblings.equals(0));
    return(query.go());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Header"),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: FutureBuilder<Block?>(
                future: getHeader(widget.entryId),
                builder: (context, snapshot) {
                  return HeaderViewer(headerBlock: snapshot.data);
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              children: [
                FilledButton(onPressed: (){
                  deleteHeader().then((_)=>{
                    Navigator.pop(context)
                  });
                }, child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.cleaning_services_rounded),
                      Text("Clear")
                    ]
                  )
                ),
                OutlinedButton(onPressed: (){
                  deleteHeader().then((_){
                    setState(() {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddHeader(entryId: widget.entryId)));
                    });
                  });
                }, child: Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.change_circle),
                      Text("Clear then Replace")
                    ]
                )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
