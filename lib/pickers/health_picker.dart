import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:journalapp/helpers/health/health_pair.dart';
import 'package:journalapp/helpers/health/prepare_for_health_access.dart';

class HealthPicker extends StatefulWidget {
  final Future Function(HealthDataPoint) onPointPicked;
  final DateTime dt;

  const HealthPicker({super.key, required this.onPointPicked, required this.dt});

  @override
  State<HealthPicker> createState() => _HealthPickerState();
}

class _HealthPickerState extends State<HealthPicker> {
  late Future<List<HealthDataPoint>> _healthDataFuture;

  @override
  void initState() {
    super.initState();
    _healthDataFuture = PrepareForHealthAccess(widget.dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close)),
            title: const Text("Pick a Health Point")
        ),
        body: FutureBuilder<List<HealthDataPoint>>(
            future: _healthDataFuture,
            builder: (context, asyncSnapshot) {
              // Handle the loading state
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle any errors that occurred during the fetch
              if (asyncSnapshot.hasError) {
                return Center(child: Text("An error occurred: ${asyncSnapshot.error}"));
              }

              final data = asyncSnapshot.data;

              // Handle empty or null data safely
              if (data == null || data.isEmpty) {
                return const Center(child: Text("No health points found for this date."));
              }

              // Render the list only when data is successfully resolved
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    final item = data[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(HealthPointToIcon(item.type.name).icon),
                        ),
                      ),
                      title: Text(item.sourceName),
                      titleTextStyle: Theme.of(context).textTheme.headlineLarge,
                      onTap: (){
                        widget.onPointPicked(item).then((_)=>{
                          Navigator.pop(context)
                        });
                      },
                    );
                  }
              );
            }
        )
    );
  }
}