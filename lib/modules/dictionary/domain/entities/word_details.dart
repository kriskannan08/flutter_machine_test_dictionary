class WordDetails {
  const WordDetails({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.example,
    required this.synonyms,
  });

  final String word;
  final String phonetic;
  final String definition;
  final String example;
  final List<String> synonyms;
}
