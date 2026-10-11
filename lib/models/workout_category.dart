class WorkoutCategory {
  final int id;
  final String name;

  const WorkoutCategory({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory WorkoutCategory.fromJson(Map<String, dynamic> json) =>
      WorkoutCategory(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
      );
}
