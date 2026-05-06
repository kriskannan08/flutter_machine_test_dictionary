import 'dart:convert';

import 'package:machine_test_dictionary/modules/dictionary/domain/entities/word_details.dart';

class WordDetailsModel extends WordDetails {
  const WordDetailsModel({
    required super.word,
    required super.phonetic,
    required super.definition,
    required super.example,
    required super.synonyms,
  });

  factory WordDetailsModel.fromJson(Map<String, dynamic> json) {
    final meanings = _asList(json['meanings']);
    final firstMeaning = meanings.whereType<Map<String, dynamic>>().firstOrNull;
    final definitions = _asList(firstMeaning?['definitions']);
    final firstDefinition = definitions
        .whereType<Map<String, dynamic>>()
        .firstOrNull;

    return WordDetailsModel(
      word: json['word']?.toString() ?? '',
      phonetic: _readPhonetic(json),
      definition: firstDefinition?['definition']?.toString() ?? '',
      example: firstDefinition?['example']?.toString() ?? '',
      synonyms: _readSynonyms(firstDefinition, firstMeaning),
    );
  }

  factory WordDetailsModel.fromDatabase(Map<String, dynamic> row) {
    return WordDetailsModel(
      word: row['word']?.toString() ?? '',
      phonetic: row['phonetic']?.toString() ?? '',
      definition: row['definition']?.toString() ?? '',
      example: row['example']?.toString() ?? '',
      synonyms: _decodeSynonyms(row['synonyms']),
    );
  }

  Map<String, dynamic> toDatabaseMap() {
    return {
      'word': word.trim().toLowerCase(),
      'phonetic': phonetic,
      'definition': definition,
      'example': example,
      'synonyms': jsonEncode(synonyms),
    };
  }

  static String _readPhonetic(Map<String, dynamic> json) {
    final phonetic = json['phonetic']?.toString();
    if (phonetic != null && phonetic.isNotEmpty) {
      return phonetic;
    }

    final phonetics = _asList(json['phonetics']);
    for (final item in phonetics.whereType<Map<String, dynamic>>()) {
      final text = item['text']?.toString();
      if (text != null && text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }

  static List<String> _readSynonyms(
    Map<String, dynamic>? definition,
    Map<String, dynamic>? meaning,
  ) {
    final synonyms = [
      ..._asList(definition?['synonyms']),
      ..._asList(meaning?['synonyms']),
    ];

    return synonyms
        .map((synonym) => synonym.toString())
        .where((synonym) => synonym.isNotEmpty)
        .toSet()
        .toList();
  }

  static List<dynamic> _asList(dynamic value) {
    return value is List ? value : const [];
  }

  static List<String> _decodeSynonyms(dynamic value) {
    if (value == null) {
      return const [];
    }

    final decodedValue = jsonDecode(value.toString());
    if (decodedValue is! List) {
      return const [];
    }

    return decodedValue
        .map((synonym) => synonym.toString())
        .where((synonym) => synonym.isNotEmpty)
        .toList();
  }
}
