import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Hive-based caching service for AI API responses
/// Reduces redundant API calls by caching results
class HiveCacheService {
  static const String _aiCacheBox = 'ai_cache';
  static const String _questionCacheBox = 'question_cache';

  late Box<String> _aiCache;
  late Box<String> _questionCache;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();
    _aiCache = await Hive.openBox<String>(_aiCacheBox);
    _questionCache = await Hive.openBox<String>(_questionCacheBox);
  }

  /// Generate a cache key from a prompt string
  String _generateKey(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  // ─────────── AI RESPONSE CACHE ───────────

  /// Cache an AI response
  Future<void> cacheAIResponse(String prompt, String response) async {
    final key = _generateKey(prompt);
    await _aiCache.put(key, response);
  }

  /// Get cached AI response, returns null if not cached
  String? getCachedAIResponse(String prompt) {
    final key = _generateKey(prompt);
    return _aiCache.get(key);
  }

  /// Check if AI response is cached
  bool hasAICache(String prompt) {
    final key = _generateKey(prompt);
    return _aiCache.containsKey(key);
  }

  // ─────────── QUESTION CACHE ───────────

  /// Cache generated questions for a specific config
  Future<void> cacheQuestions({
    required String position,
    required String company,
    required String level,
    required String type,
    required String language,
    required String questionsJson,
  }) async {
    final key = _generateKey('$position|$company|$level|$type|$language');
    await _questionCache.put(key, questionsJson);
  }

  /// Get cached questions
  String? getCachedQuestions({
    required String position,
    required String company,
    required String level,
    required String type,
    required String language,
  }) {
    final key = _generateKey('$position|$company|$level|$type|$language');
    return _questionCache.get(key);
  }

  // ─────────── MANAGEMENT ───────────

  /// Clear all caches
  Future<void> clearAll() async {
    await _aiCache.clear();
    await _questionCache.clear();
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'aiResponses': _aiCache.length,
      'questionSets': _questionCache.length,
    };
  }
}
