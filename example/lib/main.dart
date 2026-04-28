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
      title: 'Flutter Autocomplete',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005C4B)),
        useMaterial3: true,
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
  static const fruits = ['Apple', 'Banana', 'Cherry', 'Dragonfruit', 'Fig'];

  final allTags = <Tag>[
    const Tag('Work'),
    const Tag('Personal'),
    const Tag('Urgent'),
  ];

  String? selectedFruit;
  List<String> selectedFruits = const ['Apple'];
  String? selectedCity;
  Tag? selectedTag;
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
          _Section(
            title: 'Creatable Single',
            child: AutocompleteField<Tag>.creatable(
              options: allTags,
              value: selectedTag,
              onChanged: (value) => setState(() => selectedTag = value),
              getOptionLabel: (option) => option.label,
              creatableConfig: AutocompleteCreatableConfig<Tag>(
                createOption: (input) => Tag(input),
              ),
              decoration: const InputDecoration(
                labelText: 'Tag',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _Section(
            title: 'Creatable Multiple With Grouping',
            child: AutocompleteField<Tag>.creatableMultiple(
              options: allTags,
              values: selectedTags,
              onChanged: (values) => setState(() => selectedTags = values),
              getOptionLabel: (option) => option.label,
              creatableConfig: AutocompleteCreatableConfig<Tag>(
                createOption: (input) => Tag(input),
              ),
              groupingConfig: AutocompleteGroupingConfig<Tag>(
                groupBy: (option) => option.label[0],
                stickyHeaders: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Project Tags',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
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

class Tag {
  const Tag(this.label);

  final String label;
}
