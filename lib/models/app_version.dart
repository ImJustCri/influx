class AppVersion {
  final int id;
  final String versionCode;
  final String versionName;
  final String? releaseNotes;
  final String downloadUrl;
  final DateTime createdAt;
  final bool isLatest;

  AppVersion({
    required this.id,
    required this.versionCode,
    required this.versionName,
    this.releaseNotes,
    required this.downloadUrl,
    required this.createdAt,
    required this.isLatest,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      id: json['id'] as int,
      versionCode: json['version_code'] as String,
      versionName: json['version_name'] as String,
      releaseNotes: json['release_notes'] as String?,
      downloadUrl: json['download_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isLatest: json['isLatest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version_code': versionCode,
      'version_name': versionName,
      'release_notes': releaseNotes,
      'download_url': downloadUrl,
      'created_at': createdAt.toIso8601String(),
      'isLatest': isLatest,
    };
  }
}