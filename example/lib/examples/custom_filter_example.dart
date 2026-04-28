import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class CustomFilterExample extends StatelessWidget {
  const CustomFilterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AutocompleteField<Movie>(
      options: topFilms,
      getOptionLabel: (movie) => movie.title,
      filterOptions: createAutocompleteFilter<Movie>(
        matchFrom: AutocompleteFilterMatchFrom.start,
        stringify: (movie) => movie.title,
      ),
      decoration: const InputDecoration(
        labelText: 'Custom filter: starts with query',
        border: OutlineInputBorder(),
      ),
    );
  }
}
