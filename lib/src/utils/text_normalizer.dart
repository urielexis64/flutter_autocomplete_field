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
