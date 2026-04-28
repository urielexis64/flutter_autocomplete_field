import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class AsyncLoadOnOpenExample extends StatelessWidget {
  const AsyncLoadOnOpenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AutocompleteField<String>(
      options: const [],
      loadOptionsOnOpen: () async {
        await Future<void>.delayed(const Duration(milliseconds: 700));
        return filmTitles;
      },
      decoration: const InputDecoration(
        labelText: 'Asynchronous',
        border: OutlineInputBorder(),
      ),
    );
  }
}
