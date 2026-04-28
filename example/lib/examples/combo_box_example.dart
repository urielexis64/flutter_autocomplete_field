import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class ComboBoxExample extends StatelessWidget {
  const ComboBoxExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutocompleteField<Movie>(
          options: topFilms,
          getOptionLabel: (movie) => movie.title,
          decoration: const InputDecoration(
            labelText: 'Movie',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        AutocompleteField<Movie>(
          options: duplicateFilms,
          getOptionLabel: (movie) => movie.title,
          getOptionKey: (movie) => '${movie.title}-${movie.year}',
          isOptionEqualToValue: (option, value) =>
              option.title == value.title && option.year == value.year,
          decoration: const InputDecoration(
            labelText: 'Object options with stable keys',
            border: OutlineInputBorder(),
          ),
          optionBuilder: (context, movie, state) => Row(
            children: [
              Expanded(child: Text(movie.title)),
              Text(
                '${movie.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
