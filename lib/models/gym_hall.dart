class GymHall {
  final int id;
  final String name;
  final int capacity;

  const GymHall({required this.id, required this.name, required this.capacity});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'capacity': capacity,
  };

  factory GymHall.fromJson(Map<String, dynamic> json) => GymHall(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    capacity: json['capacity'] as int? ?? 0,
  );
}
