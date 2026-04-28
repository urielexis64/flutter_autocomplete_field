import 'package:flutter/material.dart';

import 'examples/async_load_on_open_example.dart';
import 'examples/combo_box_example.dart';
import 'examples/custom_filter_example.dart';
import 'examples/custom_option_rendering_example.dart';
import 'examples/disabled_options_example.dart';
import 'examples/free_solo_example.dart';
import 'examples/grouped_options_example.dart';
import 'examples/limit_tags_example.dart';
import 'examples/multiple_values_example.dart';
import 'examples/search_as_you_type_example.dart';
import 'examples/virtualized_options_example.dart';

void main() {
  runApp(const AutocompleteExampleApp());
}

class AutocompleteExampleApp extends StatelessWidget {
  const AutocompleteExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Autocomplete',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const AutocompleteExampleHome(),
    );
  }
}

class AutocompleteExampleHome extends StatelessWidget {
  const AutocompleteExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <_ExampleSection>[
      const _ExampleSection('Combo box and object options', ComboBoxExample()),
      const _ExampleSection('Free solo and creatable', FreeSoloExample()),
      const _ExampleSection('Grouped options', GroupedOptionsExample()),
      const _ExampleSection('Disabled options', DisabledOptionsExample()),
      const _ExampleSection('Multiple values', MultipleValuesExample()),
      const _ExampleSection('Limit tags', LimitTagsExample()),
      const _ExampleSection('Load on open', AsyncLoadOnOpenExample()),
      const _ExampleSection('Search as you type', SearchAsYouTypeExample()),
      const _ExampleSection('Custom rendering', CustomOptionRenderingExample()),
      const _ExampleSection('Custom filter', CustomFilterExample()),
      const _ExampleSection(
        'Virtualized large list',
        VirtualizedOptionsExample(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Autocomplete examples')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const SizedBox(height: 28),
        itemBuilder: (context, index) {
          final section = sections[index];
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                section.child,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExampleSection {
  const _ExampleSection(this.title, this.child);

  final String title;
  final Widget child;
}
