import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/cars_viewer.dart';

class CarsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cars'),
        actions: [
          IconButton(
              icon: Icon(Icons.border_bottom),
              onPressed: () => showModalBottomSheet(
                  context: context, builder: (c) => CarsViewer()))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CarsViewer(),
          ),
        ],
      ),
    );
  }
}
