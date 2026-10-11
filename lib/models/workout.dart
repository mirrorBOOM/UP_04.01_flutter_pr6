class Workout {
  final int id;
  final String title;
  final String code;
  final int durationMinutes;
  final int caloriesBurned;
  final int intensity;
  final int hallId;
  final int trainerId;
  final List<int> categoryIds;
  final int capacityTotal;
  final int capacityAvailable;
  final DateTime? deletedAt;

  const Workout({
    required this.id,
    required this.title,
    required this.code,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.intensity,
    required this.hallId,
    required this.trainerId,
    this.categoryIds = const [],
    required this.capacityTotal,
    required this.capacityAvailable,
    this.deletedAt,
  });

  bool get isDeleted => deletedAt != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'code': code,
    'durationMinutes': durationMinutes,
    'caloriesBurned': caloriesBurned,
    'intensity': intensity,
    'hallId': hallId,
    'trainerId': trainerId,
    'categoryIds': categoryIds,
    'capacityTotal': capacityTotal,
    'capacityAvailable': capacityAvailable,
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'] as int? ?? 0,
    title: json['title'] as String? ?? '',
    code: json['code'] as String? ?? '',
    durationMinutes: json['durationMinutes'] as int? ?? 0,
    caloriesBurned: json['caloriesBurned'] as int? ?? 0,
    intensity: json['intensity'] as int? ?? 1,
    hallId: json['hallId'] as int? ?? 1,
    trainerId: json['trainerId'] as int? ?? 1,
    categoryIds: (json['categoryIds'] as List?)?.cast<int>() ?? const [],
    capacityTotal: json['capacityTotal'] as int? ?? 0,
    capacityAvailable: json['capacityAvailable'] as int? ?? 0,
    deletedAt: json['deletedAt'] == null
        ? null
        : DateTime.tryParse(json['deletedAt'] as String),
  );

  Workout copyWith({
    String? title,
    String? code,
    int? durationMinutes,
    int? caloriesBurned,
    int? intensity,
    int? hallId,
    int? trainerId,
    List<int>? categoryIds,
    int? capacityTotal,
    int? capacityAvailable,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Workout(
      id: id,
      title: title ?? this.title,
      code: code ?? this.code,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      intensity: intensity ?? this.intensity,
      hallId: hallId ?? this.hallId,
      trainerId: trainerId ?? this.trainerId,
      categoryIds: categoryIds ?? this.categoryIds,
      capacityTotal: capacityTotal ?? this.capacityTotal,
      capacityAvailable: capacityAvailable ?? this.capacityAvailable,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }
}
