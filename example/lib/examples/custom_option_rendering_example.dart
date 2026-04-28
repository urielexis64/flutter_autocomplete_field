import 'package:flutter/material.dart';
import 'package:flutter_autocomplete/flutter_autocomplete.dart';

import 'data.dart';

class CustomOptionRenderingExample extends StatelessWidget {
  const CustomOptionRenderingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AutocompleteField<Movie>(
      options: topFilms,
      getOptionLabel: (movie) => movie.title,
      optionBuilder: (context, movie, state) {
        return _HighlightedText(
          text: movie.title,
          query: state.inputValue,
          trailing: '${movie.year}',
        );
      },
      decoration: const InputDecoration(
        labelText: 'Custom option rendering',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.trailing,
  });

  final String text;
  final String query;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final lower = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerQuery.isEmpty ? -1 : lower.indexOf(lowerQuery);
    final normalStyle = Theme.of(context).textTheme.bodyMedium;
    final highlightStyle = normalStyle?.copyWith(fontWeight: FontWeight.w700);

    final spans = <TextSpan>[];
    if (index == -1) {
      spans.add(TextSpan(text: text, style: normalStyle));
    } else {
      spans
        ..add(TextSpan(text: text.substring(0, index), style: normalStyle))
        ..add(
          TextSpan(
            text: text.substring(index, index + query.length),
            style: highlightStyle,
          ),
        )
        ..add(
          TextSpan(
            text: text.substring(index + query.length),
            style: normalStyle,
          ),
        );
    }

    return Row(
      children: [
        Expanded(
          child: RichText(text: TextSpan(children: spans)),
        ),
        Text(trailing, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
