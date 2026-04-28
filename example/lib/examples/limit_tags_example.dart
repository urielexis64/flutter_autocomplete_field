import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class LimitTagsExample extends StatelessWidget {
  const LimitTagsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AutocompleteField<Movie>(
      options: topFilms,
      multiple: true,
      limitTags: 2,
      defaultValues: const [
        Movie('Inception', 2010),
        Movie('Forrest Gump', 1994),
        Movie('The Matrix', 1999),
      ],
      getOptionLabel: (movie) => movie.title,
      isOptionEqualToValue: (option, value) =>
          option.title == value.title && option.year == value.year,
      decoration: const InputDecoration(
        labelText: 'limitTags',
        hintText: 'Favorites',
        border: OutlineInputBorder(),
      ),
    );
  }
}
