import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const Duration defaultCacheDuration = Duration(hours: 24);

  // Save data to cache with a timestamp
  Future<void> saveToCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
    await prefs.setInt(
        '${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  // Retrieve data from cache
  Future<dynamic> getFromCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(key);
    if (cachedData != null) {
      return json.decode(cachedData);
    }
    return null;
  }

  // Check if the cache is still valid
  Future<bool> isCacheValid(String key, Duration cacheDuration) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheTimestamp = prefs.getInt('${key}_timestamp') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - cacheTimestamp < cacheDuration.inMilliseconds;
  }

  // Invalidate a specific cache entry
  Future<void> invalidateCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.remove('${key}_timestamp');
  }

  // Invalidate all cache entries
  Future<void> invalidateAllCaches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
