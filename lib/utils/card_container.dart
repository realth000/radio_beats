import 'package:flutter/material.dart';

/// A card has children works like a container.
class CardContainer extends StatelessWidget {
  /// Constructor
  const CardContainer({
    this.children = const [],
    super.key,
    this.elevation = 4,
  });

  /// Card elevation.
  final double elevation;

  /// Card children.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        elevation: elevation,
        child: Column(
          children: children,
        ),
      );
}
