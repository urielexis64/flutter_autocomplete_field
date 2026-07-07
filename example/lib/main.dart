import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_autocomplete examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFD52028)),
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final _formKey = GlobalKey<FormState>();

  static const _fruits = <String>[
    'Apple',
    'Banana',
    'Cherry',
    'Dragonfruit',
    'Fig',
    'Grape',
    'Mango',
    'Orange',
    'Papaya',
    'Strawberry',
  ];

  static const _cities = <City>[
    City('Amsterdam', 'Netherlands', 'Europe'),
    City('Athens', 'Greece', 'Europe'),
    City('Barcelona', 'Spain', 'Europe'),
    City('Berlin', 'Germany', 'Europe'),
    City('Bogota', 'Colombia', 'South America'),
    City('Buenos Aires', 'Argentina', 'South America'),
    City('Lima', 'Peru', 'South America'),
    City('Lisbon', 'Portugal', 'Europe'),
    City('London', 'United Kingdom', 'Europe'),
    City('Madrid', 'Spain', 'Europe'),
    City('Mexico City', 'Mexico', 'North America'),
    City('Monterrey', 'Mexico', 'North America'),
    City('Montreal', 'Canada', 'North America'),
    City('New York', 'United States', 'North America'),
    City('Paris', 'France', 'Europe'),
    City('Toronto', 'Canada', 'North America'),
    City('Tokyo', 'Japan', 'Asia'),
    City('Washington', 'USA', 'North America'),
    City('Seoul', 'South Korea', 'Asia'),
  ];

  static const _teams = <Team>[
    Team(1, 'Design'),
    Team(2, 'Engineering'),
    Team(3, 'Marketing'),
    Team(4, 'Operations'),
  ];

  String? _singleFruit;
  City? _singleCity;
  Team? _selectedTeam;

  List<String> _multipleFruits = const ['Apple'];
  List<String> _tagValues = const ['critical'];

  String? _searchAsTypeCity;
  String? _comboCity;
  String? _pagedCity;
  String? _patchedAsyncFruit;
  final List<String> _patchedAsyncFruits = <String>[];

  String? _submittedSummary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flutter_autocomplete examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _IntroCard(),
          _SectionCard(
            title: '1) Single select (primitive values)',
            subtitle: 'Basic one-value selection from local data.',
            child: AutocompleteField<String>.single(
              options: _fruits,
              value: _singleFruit,
              onChanged: (value) => setState(() => _singleFruit = value),
              getOptionLabel: (option) => option,
              decoration: const InputDecoration(
                labelText: 'Favorite fruit',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '2) Single select (objects + equality)',
            subtitle:
                'Useful when your selected model is not the same instance.',
            child: AutocompleteField<City>.single(
              options: _cities,
              value: _singleCity,
              onChanged: (value) => setState(() => _singleCity = value),
              getOptionLabel: (city) => '${city.name}, ${city.country}',
              isOptionEqualToValue: (option, value) =>
                  option.name == value.name,
              renderingConfig: AutocompleteRenderingConfig<City>(
                selectedItemBuilder: (context, value, label) {
                  return Row(
                    children: [
                      const Icon(Icons.location_city, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(label)),
                    ],
                  );
                },
              ),
              decoration: const InputDecoration(
                labelText: 'Home city',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '3) Multiple chips (fixed values, limits, custom layout)',
            subtitle:
                'Shows chip behavior options for forms, filters, and tag pickers.',
            child: AutocompleteField<String>.multiple(
              options: _fruits,
              values: _multipleFruits,
              onChanged: (values) => setState(() => _multipleFruits = values),
              getOptionLabel: (option) => option,
              chipConfig: const AutocompleteChipConfig<String>(
                fixedValues: ['Apple'],
                limitTags: 3,
                showHiddenCountChip: true,
                layoutMode: AutocompleteChipLayoutMode.wrap,
              ),
              decoration: const InputDecoration(
                labelText: 'Fruits for basket',
                helperText: 'Apple is fixed and cannot be removed.',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '4) Creatable multiple tags',
            subtitle:
                'Users can create values not present in the original list.',
            child: AutocompleteField<String>.multiple(
              options: const ['critical', 'feature', 'bug', 'blocked'],
              values: _tagValues,
              onChanged: (values) => setState(() => _tagValues = values),
              getOptionLabel: (option) => option,
              creatableConfig: AutocompleteCreatableConfig<String>(
                createOption: (input) => input.toLowerCase().trim(),
                createLabel: (input) => 'Create tag "$input"',
              ),
              behaviorConfig: const AutocompleteBehaviorConfig(
                closeOnSelect: false,
                clearInputOnSelect: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Issue tags',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '5) Grouping + custom option row + disabled options',
            subtitle:
                'Visual grouping is independent from selected value semantics.',
            child: AutocompleteField<Team>.single(
              options: _teams,
              value: _selectedTeam,
              onChanged: (value) => setState(() => _selectedTeam = value),
              getOptionLabel: (team) => team.name,
              groupingConfig: const AutocompleteGroupingConfig<Team>(
                groupBy: _teamGroup,
                sortGroups: true,
                stickyHeaders: true,
              ),
              isOptionDisabled: (team) => team.id == 4,
              renderingConfig: AutocompleteRenderingConfig<Team>(
                optionBuilder: (context, option) {
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      option.isSelected
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 18,
                    ),
                    title: Text(option.label),
                    subtitle: Text('Team id: ${option.option.id}'),
                    trailing: option.isDisabled
                        ? const Text('Disabled')
                        : const SizedBox.shrink(),
                  );
                },
              ),
              decoration: const InputDecoration(
                labelText: 'Default owner team',
                helperText: 'Operations is disabled in this demo.',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '6) Async search-as-type',
            subtitle:
                'Remote query on text change with debounce and min length.',
            child: AutocompleteField<String>.async(
              asyncConfig: AutocompleteAsyncConfig<String>(
                optionsBuilder: _searchCitiesAsType,
                debounceDuration: const Duration(milliseconds: 300),
                minQueryLength: 2,
                reloadOnQueryChange: true,
                retainPreviousOptionsWhileLoading: true,
              ),
              value: _searchAsTypeCity,
              onChanged: (value) => setState(() => _searchAsTypeCity = value),
              getOptionLabel: (option) => option,
              renderingConfig: const AutocompleteRenderingConfig<String>(
                emptyBuilder: _typeToSearch,
              ),
              decoration: const InputDecoration(
                labelText: 'Search city (type at least 2 chars)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '7) Async combobox (load once, then local filtering)',
            subtitle:
                'Loads options when focused, then does not re-hit backend on input changes.',
            child: AutocompleteField<String>.async(
              asyncConfig: AutocompleteAsyncConfig<String>(
                optionsBuilder: _loadAllCitiesOnce,
                loadOnFocus: true,
                reloadOnQueryChange: false,
                loadOnlyOnce: true,
                searchOnEmptyQuery: false,
                debounceDuration: Duration.zero,
              ),
              value: _comboCity,
              onChanged: (value) => setState(() => _comboCity = value),
              getOptionLabel: (option) => option,
              decoration: const InputDecoration(
                labelText: 'Combobox city',
                helperText: 'Focus again: no remote reload.',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '8) Async pagination',
            subtitle:
                'Fetches options page by page when scrolling near list end.',
            child: AutocompleteField<String>.async(
              asyncConfig: AutocompleteAsyncConfig<String>(
                optionsBuilder: _noopOptionsBuilder,
                loadOnFocus: true,
                debounceDuration: Duration.zero,
                paginationConfig: AutocompleteAsyncPaginationConfig<String>(
                  pageSize: 6,
                  optionsPageBuilder: _pagedCitySearch,
                  showEndOfListIndicator: true,
                ),
              ),
              value: _pagedCity,
              onChanged: (value) => setState(() => _pagedCity = value),
              getOptionLabel: (option) => option,
              decoration: const InputDecoration(
                labelText: 'Paged city search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _SectionCard(
            title: '9) Form integration + validators + onSaved',
            subtitle: 'Use package fields exactly like regular Form fields.',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AutocompleteField<String>.single(
                    options: _fruits,
                    getOptionLabel: (option) => option,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one fruit';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _submittedSummary = 'Fruit: ${value ?? '-'}';
                    },
                    decoration: const InputDecoration(
                      labelText: 'Required fruit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AutocompleteField<String>.multiple(
                    options: _fruits,
                    getOptionLabel: (option) => option,
                    validator: (values) {
                      if (values == null || values.length < 2) {
                        return 'Select at least 2 items';
                      }
                      return null;
                    },
                    onSaved: (values) {
                      final current = _submittedSummary ?? '';
                      _submittedSummary =
                          '$current | Count: ${values?.length ?? 0}';
                    },
                    decoration: const InputDecoration(
                      labelText: 'Required list',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        onPressed: () {
                          final valid =
                              _formKey.currentState?.validate() ?? false;
                          if (!valid) {
                            return;
                          }
                          _formKey.currentState?.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_submittedSummary ?? 'Saved'),
                            ),
                          );
                        },
                        child: const Text('Validate + Save'),
                      ),
                      OutlinedButton(
                        onPressed: () => _formKey.currentState?.reset(),
                        child: const Text('Reset Form'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _SectionCard(
            title: '10) External patching for async fields',
            subtitle:
                'Patch async single and async multiple values from parent state without changing widget keys.',
            child: Column(
              children: [
                AutocompleteField<String>.async(
                  asyncConfig: AutocompleteAsyncConfig<String>(
                    optionsBuilder: _loadAllFruitsOnce,
                    loadOnFocus: true,
                    reloadOnQueryChange: false,
                    loadOnlyOnce: true,
                    debounceDuration: Duration.zero,
                  ),
                  value: _patchedAsyncFruit,
                  onChanged: (value) =>
                      setState(() => _patchedAsyncFruit = value),
                  getOptionLabel: (option) => option,
                  decoration: const InputDecoration(
                    labelText: 'Patched async single',
                    helperText: 'Use the buttons below to patch this field.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () =>
                          setState(() => _patchedAsyncFruit = 'Banana'),
                      child: const Text('Patch single: Banana'),
                    ),
                    OutlinedButton(
                      onPressed: () =>
                          setState(() => _patchedAsyncFruit = null),
                      child: const Text('Clear single'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AutocompleteField<String>.asyncMultiple(
                  asyncConfig: AutocompleteAsyncConfig<String>(
                    optionsBuilder: _loadAllFruitsOnce,
                    loadOnFocus: true,
                    reloadOnQueryChange: false,
                    loadOnlyOnce: true,
                    searchOnEmptyQuery: false,
                    debounceDuration: Duration.zero,
                  ),
                  values: _patchedAsyncFruits,
                  onChanged: (values) => setState(() {
                    _patchedAsyncFruits
                      ..clear()
                      ..addAll(values);
                  }),
                  getOptionLabel: (option) => option,
                  behaviorConfig: const AutocompleteBehaviorConfig(
                    closeOnSelect: false,
                    clearInputOnSelect: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Patched async multiple',
                    helperText:
                        'Select items, then patch or clear them externally with the same list instance.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() {
                        _patchedAsyncFruits
                          ..clear()
                          ..addAll(const ['Apple', 'Banana']);
                      }),
                      child: const Text('Patch multiple: Apple + Banana'),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(_patchedAsyncFruits.clear),
                      child: const Text('Clear multiple'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _searchCitiesAsType(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final normalized = query.toLowerCase();
    return _cities
        .map((city) => city.name)
        .where((name) => name.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  Future<List<String>> _loadAllCitiesOnce(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return _cities.map((city) => city.name).toList(growable: false);
  }

  Future<List<String>> _loadAllFruitsOnce(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    return _fruits;
  }

  Future<List<String>> _noopOptionsBuilder(String query) async {
    return const [];
  }

  Future<List<String>> _pagedCitySearch(
    String query,
    int page,
    int pageSize,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    final normalized = query.toLowerCase();

    final filtered = _cities
        .map((city) => '${city.name}, ${city.country}')
        .where(
          (label) =>
              normalized.isEmpty || label.toLowerCase().contains(normalized),
        )
        .toList(growable: false);

    final start = (page - 1) * pageSize;
    if (start >= filtered.length) {
      return const [];
    }
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  static String _teamGroup(Team team) {
    if (team.id == 1) {
      return 'Product';
    }
    if (team.id <= 3) {
      return 'Delivery';
    }
    return 'Business';
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'This example covers most package features',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Use this page as a cookbook for common app flows: '
              'single/multiple, async search, combobox behavior, pagination, '
              'creatable options, grouping, custom rendering, and form validation.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(subtitle),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class Team {
  const Team(this.id, this.name);

  final int id;
  final String name;
}

class City {
  const City(this.name, this.country, this.continent);

  final String name;
  final String country;
  final String continent;
}

Widget _typeToSearch(BuildContext context, String query) {
  if (query.trim().isEmpty) {
    return Center(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Type to find something...'),
      ),
    );
  }
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text('No results for "$query"'),
    ),
  );
}
