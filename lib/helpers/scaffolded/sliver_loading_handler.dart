import 'package:flutter/material.dart';

import '../../entry_view.dart';

class ScaffoldedSliverLoadingHandler extends StatelessWidget {
  const ScaffoldedSliverLoadingHandler({
    super.key,
    required this.widget,
  });

  final EntryView widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
            stretch: true,
            stretchTriggerOffset: 300,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              title: const Text('Loading...'),
              // Provide the Hero immediately using the index passed to the widget
              background: Hero(
                  tag: "entry-hero-${widget.entryIndex}",
                  child: const ColoredBox(color: Colors.deepOrange)
              ),
            ),
          ),
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}