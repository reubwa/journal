import 'package:flutter/material.dart';

class RetText extends StatefulWidget {
  final Future Function(String) onTextHanded;
  final String? text;
  const RetText({super.key, required this.onTextHanded, this.text});

  @override
  State<RetText> createState() => _RetTextState();
}

class _RetTextState extends State<RetText> {
  final textController = TextEditingController();
  bool isComp = false;
  @override
  void initState() {
    if(widget.text != null){
      textController.text = widget.text!;
    }
    super.initState();
  }
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Text"),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
        actions: [
          IconButton(onPressed: isComp ? (){
            widget.onTextHanded(textController.text).then((_)=>{
              Navigator.pop(context)
            });
          } : null, icon: Icon(Icons.check))
        ],
      ),
      body: TextField(controller: textController, maxLines: null, onChanged: (_)=>{
        setState(() {
          isComp = textController.text.isNotEmpty;
        })
      },),
    );
  }
}
