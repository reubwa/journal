
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as ip;

class ImagePicker extends StatefulWidget {
  final Future Function(ip.XFile?) onFilePicked;
  const ImagePicker({required this.onFilePicked, super.key});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  bool isComp = false;
  ip.XFile? chosenFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick Image"),
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
      actions: [
        IconButton(onPressed: isComp ? (){
          widget.onFilePicked(chosenFile);
          Navigator.pop(context);
        } : null, icon: Icon(Icons.check))
      ],),
      body: Column(
        children: [
          chosenFile == null ? ColoredBox(color: Colors.grey) : Image.file(File(chosenFile!.path), height: 300,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              children: [
                FilledButton(onPressed: (){
                  ip.ImagePicker().pickImage(source: ip.ImageSource.gallery).then((res)=>{
                    setState(() {
                      chosenFile = res;
                      isComp = true;
                    })
                  });
                }, child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.photo_album),
                    Text("From Gallery")
                  ],
                )),
                OutlinedButton(onPressed: (){
                  ip.ImagePicker().pickImage(source: ip.ImageSource.camera).then((res)=>{
                    setState(() {
                      chosenFile = res;
                      isComp = true;
                    })
                  });
                }, child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.camera_alt),
                    Text("From Camera")
                  ],
                )),
              ],
            ),
          )
        ]
      )
    );
  }
}

