import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class DisabledOptionsExample extends StatelessWidget {
  const DisabledOptionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AutocompleteField<String>(
      options: timeSlots,
      getOptionDisabled: (slot) =>
          slot == timeSlots.first || slot == timeSlots[2],
      decoration: const InputDecoration(
        labelText: 'Disabled options',
        border: OutlineInputBorder(),
      ),
    );
  }
}
