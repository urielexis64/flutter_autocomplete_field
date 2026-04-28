import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

class VirtualizedOptionsExample extends StatelessWidget {
  const VirtualizedOptionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final options = List<String>.generate(10000, (index) => 'Option $index');
    return AutocompleteField<String>(
      options: options,
      virtualized: true,
      popupMaxHeight: 320,
      decoration: const InputDecoration(
        labelText: '10,000 options',
        border: OutlineInputBorder(),
      ),
    );
  }
}
