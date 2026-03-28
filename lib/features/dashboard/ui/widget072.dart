import 'package:flutter/material.dart';

class Widget072 extends StatelessWidget {
  const Widget072({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          delegate: SliverChildBuilderDelegate((
            BuildContext context,
            int index,
          ) {
            return Container(
              alignment: Alignment.center,
              // Ensure the color is not null for index % 9 == 0 (Colors.orange[0] is null)
              // Use a default value or adjust the index calculation
              color: Colors.pink[100 * (index % 9) + 100],
              child: Text(
                'Grid Item $index',
                style: TextStyle(
                  color: Colors.black87,
                  backgroundColor: Color(0x00000000),
                  decoration: TextDecoration.none,
                ),
              ),
            );
          }, childCount: 50),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
        ),
      ],
    );
  }
}
