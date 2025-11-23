/// Entity representing an API configuration
class ApiConfiguration {
  final String id;
  final String url;
  final String label;
  final bool isActive;

  const ApiConfiguration({
    required this.id,
    required this.url,
    required this.label,
    this.isActive = false,
  });

  /// Create a copy with updated fields
  ApiConfiguration copyWith({
    String? id,
    String? url,
    String? label,
    bool? isActive,
  }) {
    return ApiConfiguration(
      id: id ?? this.id,
      url: url ?? this.url,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'label': label, 'isActive': isActive};
  }

  /// Create from JSON
  factory ApiConfiguration.fromJson(Map<String, dynamic> json) {
    return ApiConfiguration(
      id: json['id'] as String,
      url: json['url'] as String,
      label: json['label'] as String,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiConfiguration &&
        other.id == id &&
        other.url == url &&
        other.label == label &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, url, label, isActive);
}
