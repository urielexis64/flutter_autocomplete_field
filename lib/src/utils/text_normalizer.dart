/// Normalizes [value] for autocomplete text matching.
///
/// The transformation order is:
/// 1. Trim leading/trailing whitespace when [trim] is `true`.
/// 2. Convert to lowercase when [ignoreCase] is `true`.
/// 3. Strip a limited set of Latin accents when [ignoreAccents] is `true`.
///
/// Returns a transformed string suitable for comparison operations.
///
/// This helper intentionally avoids heavyweight Unicode normalization to keep
/// filtering predictable and fast on mobile devices.
String normalizeAutocompleteText(
  String value, {
  required bool trim,
  required bool ignoreCase,
  required bool ignoreAccents,
}) {
  var output = trim ? value.trim() : value;
  if (ignoreCase) {
    output = output.toLowerCase();
  }
  if (ignoreAccents) {
    output = _stripAccents(output);
  }
  return output;
}

/// Removes a conservative subset of Latin diacritics from [input].
///
/// This is intentionally not a full Unicode decomposition algorithm. Characters
/// outside the replacement table are returned unchanged.
String _stripAccents(String input) {
  const replacements = <String, String>{
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'å': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ç': 'c',
    'ñ': 'n',
    'ý': 'y',
    'ÿ': 'y',
  };
  return input.split('').map((char) => replacements[char] ?? char).join();
}
