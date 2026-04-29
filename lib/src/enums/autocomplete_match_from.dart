/// Controls where the default filter matches the query.
enum AutocompleteMatchFrom {
  /// Matches only from the start of the normalized option text.
  ///
  /// Example: query `ap` matches `Apple` but not `Grape`.
  start,

  /// Matches anywhere inside the normalized option text.
  ///
  /// Example: query `ap` matches both `Apple` and `Grape`.
  anywhere,
}
