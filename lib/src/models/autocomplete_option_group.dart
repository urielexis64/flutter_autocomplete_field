class AutocompleteOptionGroup<T> {
  const AutocompleteOptionGroup({required this.name, required this.options});

  final String name;
  final List<T> options;
}
