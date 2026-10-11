class Trainer {
  final int id;
  final String fullName;
  final String specialization;
  final int experienceYears;
  final String category;
  final DateTime? deletedAt;

  const Trainer({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.experienceYears,
    required this.category,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'specialization': specialization,
    'experienceYears': experienceYears,
    'category': category,
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
    id: json['id'] as int? ?? 0,
    fullName: json['fullName'] as String? ?? '',
    specialization: json['specialization'] as String? ?? '',
    experienceYears: json['experienceYears'] as int? ?? 0,
    category: json['category'] as String? ?? 'PRO',
    deletedAt: json['deletedAt'] == null
        ? null
        : DateTime.tryParse(json['deletedAt'] as String),
  );

  Trainer copyWith({
    String? fullName,
    String? specialization,
    int? experienceYears,
    String? category,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Trainer(
      id: id,
      fullName: fullName ?? this.fullName,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      category: category ?? this.category,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
