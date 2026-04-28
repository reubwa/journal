import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

/*https://pub.dev/packages/location_picker_flutter_map*/

class LocPicker extends StatefulWidget {
  final Future Function(LatLong) onLocPicked;
  const LocPicker({super.key, required this.onLocPicked});

  @override
  State<LocPicker> createState() => _LocPickerState();
}

class _LocPickerState extends State<LocPicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose a Location"),
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close))),
      body: FlutterLocationPicker(onPicked: (picked){
        widget.onLocPicked(picked.latLong);
        Navigator.pop(context);
      }, userAgent: 'Journal/1.0.0 (journalapp@reub.33mail.com)'),
    );
  }
}
