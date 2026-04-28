import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class MultipleValuesExample extends StatelessWidget {
  const MultipleValuesExample({super.key});

  @override
  Widget build(BuildContext context) {
    const fixed = <Movie>[Movie('Pulp Fiction', 1994)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutocompleteField<Movie>(
          options: topFilms,
          multiple: true,
          filterSelectedOptions: true,
          defaultValues: const [Movie('Inception', 2010)],
          getOptionLabel: (movie) => movie.title,
          isOptionEqualToValue: (option, value) =>
              option.title == value.title && option.year == value.year,
          decoration: const InputDecoration(
            labelText: 'Multiple values',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        AutocompleteField<Movie>(
          options: topFilms,
          multiple: true,
          defaultValues: fixed,
          getOptionLabel: (movie) => movie.title,
          isOptionEqualToValue: (option, value) =>
              option.title == value.title && option.year == value.year,
          getSelectedItemDisabled: (movie) =>
              fixed.any((fixedMovie) => fixedMovie.title == movie.title),
          decoration: const InputDecoration(
            labelText: 'Fixed tag',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        AutocompleteField<Movie>(
          options: topFilms,
          multiple: true,
          disableCloseOnSelect: true,
          getOptionLabel: (movie) => movie.title,
          isOptionEqualToValue: (option, value) =>
              option.title == value.title && option.year == value.year,
          optionBuilder: (context, movie, state) => Row(
            children: [
              Icon(
                state.selected
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(movie.title)),
            ],
          ),
          decoration: const InputDecoration(
            labelText: 'Selection indicators',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
