class Group {
  final String id;
  final String name;
  final String? inviteCode;
  final String status;
  final int maxMembers;
  final DateTime createdAt;
  final DateTime? startedAt;
  final String creatorId;

  Group({
    required this.id,
    required this.name,
    this.inviteCode,
    required this.status,
    required this.maxMembers,
    required this.createdAt,
    this.startedAt,
    required this.creatorId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      inviteCode: json['invite_code'] as String?,
      status: json['status'] as String,
      maxMembers: json['max_members'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      creatorId: json['created_by'] as String,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'invite_code': inviteCode,
      'status': status,
      'max_members': maxMembers,
      'created_at': createdAt.toIso8601String(),
      'creator_id': creatorId,
      'started_at': startedAt?.toIso8601String(),
    };
  }
}