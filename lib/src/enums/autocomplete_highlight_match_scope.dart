/// Defines how many query matches are highlighted per option label.
enum AutocompleteHighlightMatchScope {
  /// Highlights every occurrence of the query in the label.
  allOccurrences,

  /// Highlights only the first occurrence of the query in the label.
  firstOccurrence,
}
