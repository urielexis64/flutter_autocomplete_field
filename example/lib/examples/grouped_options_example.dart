import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class GroupedOptionsExample extends StatelessWidget {
  const GroupedOptionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final sorted = [...topFilms]
      ..sort((a, b) => a.title[0].compareTo(b.title[0]));
    return AutocompleteField<Movie>(
      options: sorted,
      getOptionLabel: (movie) => movie.title,
      groupBy: (movie) => movie.title[0],
      groupBuilder: (context, group, children) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(group, style: Theme.of(context).textTheme.labelLarge),
          ),
          ...children,
        ],
      ),
      decoration: const InputDecoration(
        labelText: 'With categories',
        border: OutlineInputBorder(),
      ),
    );
  }
}
