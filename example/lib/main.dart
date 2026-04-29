import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

/// Runs the package example application.
void main() {
  runApp(const ExampleApp());
}

/// Root example app shell.
class ExampleApp extends StatelessWidget {
  /// Creates the root example app widget.
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Autocomplete',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005C4B)),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

/// Example page showcasing single, multiple, and async constructors.
class ExampleHomePage extends StatefulWidget {
  /// Creates the example home page.
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

/// State holder for demo selections and async search behavior.
class _ExampleHomePageState extends State<ExampleHomePage> {
  /// Local options used by sync examples.
  static const fruits = ['Apple', 'Banana', 'Cherry', 'Dragonfruit', 'Fig'];

  /// Example tag models for generic multiple selection.
  final allTags = <Tag>[
    const Tag('Work'),
    const Tag('Personal'),
    const Tag('Urgent'),
  ];

  /// Current single selected fruit value.
  String? selectedFruit;

  /// Current selected fruits for multiple mode.
  List<String> selectedFruits = const ['Apple'];

  /// Current selected city from async mode.
  String? selectedCity;

  /// Current selected single tag.
  Tag? selectedTag;

  /// Current selected tags for multiple generic mode.
  List<Tag> selectedTags = const [Tag('Work')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Autocomplete')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(
            title: 'Single',
            child: AutocompleteField<String>.single(
              options: fruits,
              value: selectedFruit,
              onChanged: (value) => setState(() => selectedFruit = value),
              getOptionLabel: (option) => option,
              decoration: const InputDecoration(
                labelText: 'Fruit',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _Section(
            title: 'Multiple',
            child: AutocompleteField<String>.multiple(
              options: fruits,
              values: selectedFruits,
              onChanged: (values) => setState(() => selectedFruits = values),
              getOptionLabel: (option) => option,
              decoration: const InputDecoration(
                labelText: 'Fruits',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _Section(
            title: 'Async',
            child: AutocompleteField<String>.async(
              asyncConfig: AutocompleteAsyncConfig(
                optionsBuilder: _searchCities,
                debounceDuration: const Duration(milliseconds: 250),
                minQueryLength: 1,
              ),
              value: selectedCity,
              onChanged: (value) => setState(() => selectedCity = value),
              getOptionLabel: (option) => option,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Simulates an async city search.
  Future<List<String>> _searchCities(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    const cities = [
      'Amsterdam',
      'Barcelona',
      'Berlin',
      'Bogota',
      'Lisbon',
      'London',
      'Madrid',
      'Mexico City',
      'Monterrey',
      'Paris',
    ];
    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList(growable: false);
  }
}

/// Simple section container used to format example blocks.
class _Section extends StatelessWidget {
  /// Creates a titled section with [child] content.
  const _Section({required this.title, required this.child});

  /// Section title.
  final String title;

  /// Section body content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Minimal example model for demonstrating generic autocomplete types.
class Tag {
  /// Creates a [Tag] with display [label].
  const Tag(this.label);

  /// Human-readable tag label.
  final String label;
}
