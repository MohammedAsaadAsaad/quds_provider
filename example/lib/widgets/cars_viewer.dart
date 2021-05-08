import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quds_provider/quds_provider.dart';

import '../providers/cars_provider.dart';

class CarsViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QudsProviderWatcher<CarsProvider>(builder: (p) {
      return ListView(
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    p!.cars.v.add(
                        (['Toyota', 'Mercedes', 'Volvo']..shuffle()).first);
                  })
            ],
          ),
          for (var c in p!.cars.v)
            ListTile(
              title: Text(c),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => p.cars.v.remove(c),
              ),
            )
        ],
      );
    });
  }
}
