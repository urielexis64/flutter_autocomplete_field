import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class SearchAsYouTypeExample extends StatefulWidget {
  const SearchAsYouTypeExample({super.key});

  @override
  State<SearchAsYouTypeExample> createState() => _SearchAsYouTypeExampleState();
}

class _SearchAsYouTypeExampleState extends State<SearchAsYouTypeExample> {
  final AutocompleteDebouncer _debouncer = AutocompleteDebouncer(
    const Duration(milliseconds: 300),
  );
  var _options = <String>[];
  var _loading = false;

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutocompleteField<String>(
      options: _options,
      loading: _loading,
      filterOptions: identityAutocompleteFilter,
      onInputChanged: (query) {
        _debouncer(() async {
          setState(() => _loading = true);
          await Future<void>.delayed(const Duration(milliseconds: 350));
          final lower = query.toLowerCase();
          setState(() {
            _options = filmTitles
                .where((title) => title.toLowerCase().contains(lower))
                .toList();
            _loading = false;
          });
        });
      },
      decoration: const InputDecoration(
        labelText: 'Search as you type',
        border: OutlineInputBorder(),
      ),
    );
  }
}
