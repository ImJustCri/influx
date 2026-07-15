class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final double budget;

  Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    required this.budget,
  });

  // json to profile object
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      budget: (json['budget_personale'] as num?)?.toDouble() ?? 0.0,
    );
  }
}