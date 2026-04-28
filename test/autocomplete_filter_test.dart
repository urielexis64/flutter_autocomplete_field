import 'package:flutter_autocomplete/flutter_autocomplete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AutocompleteFilterState<String> state(String input) {
    return AutocompleteFilterState<String>(
      inputValue: input,
      getOptionLabel: (option) => option,
    );
  }

  test('default filter ignores case and accents and matches anywhere', () {
    final filter = createAutocompleteFilter<String>();

    expect(filter(['Amelie', 'Pulp Fiction'], state('amel')), ['Amelie']);
    expect(filter(['Amelie', 'Pulp Fiction'], state('FICTION')), [
      'Pulp Fiction',
    ]);
    expect(filter(['Amélie', 'Pulp Fiction'], state('amelie')), ['Amélie']);
  });

  test('trim, limit, and matchFrom start are configurable', () {
    final filter = createAutocompleteFilter<String>(
      trim: true,
      limit: 2,
      matchFrom: AutocompleteFilterMatchFrom.start,
    );

    expect(filter(['Alpha', 'Alpine', 'Beta', 'Pal'], state(' al')), [
      'Alpha',
      'Alpine',
    ]);
  });

  test('stringify controls option matching', () {
    final filter = createAutocompleteFilter<_Film>(
      stringify: (film) => '${film.title} ${film.year}',
    );

    final films = [_Film('Inception', 2010), _Film('The Matrix', 1999)];
    final result = filter(
      films,
      AutocompleteFilterState<_Film>(
        inputValue: '1999',
        getOptionLabel: (film) => film.title,
      ),
    );

    expect(result.single.title, 'The Matrix');
  });

  test('identity filter returns options unchanged for server filtering', () {
    final options = ['Paris', 'Pamplona'];

    expect(identityAutocompleteFilter(options, state('zzz')), same(options));
  });
}

class _Film {
  const _Film(this.title, this.year);

  final String title;
  final int year;
}
