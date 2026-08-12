class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;

  Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
  });

  // json to profile object
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}