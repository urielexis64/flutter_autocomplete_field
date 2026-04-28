import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class FreeSoloExample extends StatelessWidget {
  const FreeSoloExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutocompleteField<String>(
          options: filmTitles,
          freeSolo: true,
          decoration: const InputDecoration(
            labelText: 'Search input',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        AutocompleteField<String>(
          options: filmTitles,
          freeSolo: true,
          selectOnFocus: true,
          clearOnBlur: true,
          handleHomeEndKeys: true,
          filterOptions: (options, state) {
            final filter = createAutocompleteFilter<String>();
            final matches = filter(options, state);
            final query = state.inputValue.trim();
            if (query.isNotEmpty &&
                !options.any(
                  (option) => option.toLowerCase() == query.toLowerCase(),
                )) {
              return <String>[...matches, 'Add "$query"'];
            }
            return matches;
          },
          decoration: const InputDecoration(
            labelText: 'Creatable',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
