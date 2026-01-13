import '../../core/constants/app_constants.dart';

class CacheMetadata {
  final DateTime lastUpdated;
  final String version;
  final int totalItems;
  final Map<String, DateTime> itemTimestamps;

  CacheMetadata({
    required this.lastUpdated,
    required this.version,
    required this.totalItems,
    required this.itemTimestamps,
  });

  Map<String, dynamic> toJson() => {
        'lastUpdated': lastUpdated.toIso8601String(),
        'version': version,
        'totalItems': totalItems,
        'itemTimestamps': itemTimestamps.map(
          (k, v) => MapEntry(k, v.toIso8601String()),
        ),
      };

  factory CacheMetadata.fromJson(Map<String, dynamic> json) => CacheMetadata(
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
        version: json['version'] as String,
        totalItems: json['totalItems'] as int,
        itemTimestamps: (json['itemTimestamps'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, DateTime.parse(v as String)),
        ),
      );

  bool isExpired({Duration? ttl}) {
    final maxAge = ttl ?? AppConstants.cacheTTL;
    return DateTime.now().difference(lastUpdated) > maxAge;
  }

  bool isItemExpired(String itemId, {Duration? ttl}) {
    final timestamp = itemTimestamps[itemId];
    if (timestamp == null) return true;

    final maxAge = ttl ?? AppConstants.cacheTTL;
    return DateTime.now().difference(timestamp) > maxAge;
  }
}

