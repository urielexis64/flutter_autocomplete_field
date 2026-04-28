/// Controls where the default filter matches the query.
enum AutocompleteMatchFrom {
  /// Matches only from the start of the normalized option text.
  start,

  /// Matches anywhere inside the normalized option text.
  anywhere,
}
