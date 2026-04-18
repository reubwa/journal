import 'package:flutter/material.dart';

class ColourPicker extends StatelessWidget {
  final Future Function(Color) onColorPicked;
  const ColourPicker({super.key, required this.onColorPicked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
        title: Text("Pick a Colour")
      ),
      body: ListView.builder(itemCount: Colors.primaries.length,itemBuilder: (context, index){
        final item = Colors.primaries[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: ColoredBox(color: item),
            ),
          ),
          title: Text(item.toARGB32().toString()),
          titleTextStyle: Theme.of(context).textTheme.headlineLarge,
          onTap: (){
            onColorPicked(item).then((_)=>{
              Navigator.pop(context)
            });
          },
        );
      })
    );
  }
}
