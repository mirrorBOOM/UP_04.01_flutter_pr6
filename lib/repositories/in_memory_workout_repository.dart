import '../models/page_result.dart';
import '../models/workout.dart';
import '../models/workout_query.dart';
import 'workout_repository.dart';

class InMemoryWorkoutRepository implements WorkoutRepository {
  final List<Workout> _items = [
    const Workout(
      id: 1,
      title: 'CrossFit WOD Pro',
      code: 'CRF-101',
      durationMinutes: 60,
      caloriesBurned: 750,
      intensity: 5,
      hallId: 1,
      trainerId: 1,
      capacityTotal: 15,
      capacityAvailable: 4,
    ),
    const Workout(
      id: 2,
      title: 'Хатха-йога для баланса',
      code: 'YOG-201',
      durationMinutes: 75,
      caloriesBurned: 320,
      intensity: 2,
      hallId: 2,
      trainerId: 2,
      capacityTotal: 20,
      capacityAvailable: 11,
    ),
    const Workout(
      id: 3,
      title: 'Классический бокс',
      code: 'BOX-301',
      durationMinutes: 60,
      caloriesBurned: 800,
      intensity: 5,
      hallId: 3,
      trainerId: 3,
      capacityTotal: 12,
      capacityAvailable: 2,
    ),
    const Workout(
      id: 4,
      title: 'Пилатес Mat',
      code: 'PIL-401',
      durationMinutes: 55,
      caloriesBurned: 280,
      intensity: 2,
      hallId: 2,
      trainerId: 2,
      capacityTotal: 18,
      capacityAvailable: 7,
    ),
    const Workout(
      id: 5,
      title: 'Spinning Сайклинг',
      code: 'CYC-501',
      durationMinutes: 45,
      caloriesBurned: 650,
      intensity: 4,
      hallId: 4,
      trainerId: 4,
      capacityTotal: 25,
      capacityAvailable: 10,
    ),
    const Workout(
      id: 6,
      title: 'Body Pump Штанга',
      code: 'PMP-601',
      durationMinutes: 60,
      caloriesBurned: 580,
      intensity: 4,
      hallId: 1,
      trainerId: 5,
      capacityTotal: 20,
      capacityAvailable: 5,
    ),
    const Workout(
      id: 7,
      title: 'Стретчинг и гибкость',
      code: 'STR-701',
      durationMinutes: 50,
      caloriesBurned: 200,
      intensity: 1,
      hallId: 2,
      trainerId: 2,
      capacityTotal: 22,
      capacityAvailable: 14,
    ),
    const Workout(
      id: 8,
      title: 'Aqua Aerobics Аква',
      code: 'AQU-801',
      durationMinutes: 45,
      caloriesBurned: 400,
      intensity: 3,
      hallId: 5,
      trainerId: 6,
      capacityTotal: 16,
      capacityAvailable: 8,
    ),
    const Workout(
      id: 9,
      title: 'TRX Suspension Training',
      code: 'TRX-102',
      durationMinutes: 55,
      caloriesBurned: 520,
      intensity: 4,
      hallId: 1,
      trainerId: 1,
      capacityTotal: 12,
      capacityAvailable: 0,
    ),
    const Workout(
      id: 10,
      title: 'Zumba Dance фитнес',
      code: 'ZUM-901',
      durationMinutes: 55,
      caloriesBurned: 490,
      intensity: 3,
      hallId: 2,
      trainerId: 7,
      capacityTotal: 30,
      capacityAvailable: 18,
    ),
    const Workout(
      id: 11,
      title: 'Табата интенсив',
      code: 'TAB-103',
      durationMinutes: 40,
      caloriesBurned: 600,
      intensity: 5,
      hallId: 1,
      trainerId: 5,
      capacityTotal: 15,
      capacityAvailable: 6,
    ),
    const Workout(
      id: 12,
      title: 'Кикбоксинг K-1',
      code: 'BOX-302',
      durationMinutes: 60,
      caloriesBurned: 780,
      intensity: 5,
      hallId: 3,
      trainerId: 3,
      capacityTotal: 14,
      capacityAvailable: 3,
    ),
    const Workout(
      id: 13,
      title: 'Аштанга Виньяса йога',
      code: 'YOG-202',
      durationMinutes: 90,
      caloriesBurned: 420,
      intensity: 3,
      hallId: 2,
      trainerId: 2,
      capacityTotal: 16,
      capacityAvailable: 9,
    ),
    const Workout(
      id: 14,
      title: 'Functional Power',
      code: 'FNC-104',
      durationMinutes: 60,
      caloriesBurned: 620,
      intensity: 4,
      hallId: 1,
      trainerId: 1,
      capacityTotal: 18,
      capacityAvailable: 7,
    ),
    const Workout(
      id: 15,
      title: 'Спортивное плавание',
      code: 'SWM-802',
      durationMinutes: 45,
      caloriesBurned: 550,
      intensity: 4,
      hallId: 5,
      trainerId: 6,
      capacityTotal: 10,
      capacityAvailable: 1,
    ),
    const Workout(
      id: 16,
      title: 'Step Interval',
      code: 'STP-902',
      durationMinutes: 50,
      caloriesBurned: 470,
      intensity: 3,
      hallId: 2,
      trainerId: 7,
      capacityTotal: 20,
      capacityAvailable: 12,
    ),
    const Workout(
      id: 17,
      title: 'Пауэрлифтинг базовый',
      code: 'PWR-602',
      durationMinutes: 75,
      caloriesBurned: 500,
      intensity: 4,
      hallId: 1,
      trainerId: 8,
      capacityTotal: 8,
      capacityAvailable: 2,
    ),
    const Workout(
      id: 18,
      title: 'Здоровая спина и МФР',
      code: 'HLT-702',
      durationMinutes: 55,
      caloriesBurned: 180,
      intensity: 1,
      hallId: 2,
      trainerId: 2,
      capacityTotal: 20,
      capacityAvailable: 15,
    ),
    const Workout(
      id: 19,
      title: 'HIIT Cardio Burn',
      code: 'HIT-105',
      durationMinutes: 45,
      caloriesBurned: 680,
      intensity: 5,
      hallId: 1,
      trainerId: 4,
      capacityTotal: 20,
      capacityAvailable: 8,
    ),
    const Workout(
      id: 20,
      title: 'Тайский бокс Муай-тай',
      code: 'BOX-303',
      durationMinutes: 60,
      caloriesBurned: 820,
      intensity: 5,
      hallId: 3,
      trainerId: 3,
      capacityTotal: 12,
      capacityAvailable: 4,
    ),
    const Workout(
      id: 21,
      title: 'Belly Dance Восточные танцы',
      code: 'BLD-903',
      durationMinutes: 55,
      caloriesBurned: 350,
      intensity: 2,
      hallId: 2,
      trainerId: 7,
      capacityTotal: 25,
      capacityAvailable: 19,
    ),
  ];

  @override
  bool isCodeTaken(String code, [int? currentId]) {
    return _items.any(
      (w) => w.code.toLowerCase() == code.toLowerCase() && w.id != currentId,
    );
  }

  @override
  int countWorkoutsInHall(int hallId) {
    return _items.where((w) => w.hallId == hallId && !w.isDeleted).length;
  }

  @override
  Future<void> save(Workout workout) async {
    final idx = _items.indexWhere((w) => w.id == workout.id);
    if (idx != -1) {
      _items[idx] = workout;
    } else {
      _items.add(workout);
    }
  }

  @override
  Future<PageResult<Workout>> find(WorkoutQuery q) async {
    var rows = _items.where((w) => q.includeDeleted || !w.isDeleted).toList();

    if (q.search.trim().isNotEmpty) {
      final needle = q.search.trim().toLowerCase();
      rows = rows
          .where(
            (w) =>
                w.title.toLowerCase().contains(needle) ||
                w.code.toLowerCase().contains(needle),
          )
          .toList();
    }

    if (q.trainerId != null) {
      rows = rows.where((w) => w.trainerId == q.trainerId).toList();
    }

    rows.sort((a, b) {
      final res = switch (q.sortField) {
        'duration' => a.durationMinutes.compareTo(b.durationMinutes),
        'calories' => a.caloriesBurned.compareTo(b.caloriesBurned),
        'intensity' => a.intensity.compareTo(b.intensity),
        _ => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      };
      return q.sortAscending ? res : -res;
    });

    final total = rows.length;
    final from = (q.page - 1) * q.size;
    if (from >= total) {
      return PageResult(items: [], page: q.page, size: q.size, total: total);
    }
    final to = (from + q.size > total) ? total : from + q.size;
    return PageResult(
      items: rows.sublist(from, to),
      page: q.page,
      size: q.size,
      total: total,
    );
  }

  @override
  Future<Workout?> findById(int id) async {
    try {
      return _items.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> softDelete(int id) async {
    final idx = _items.indexWhere((w) => w.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(deletedAt: DateTime.now());
    }
  }

  @override
  Future<void> hardDelete(int id) async {
    _items.removeWhere((w) => w.id == id);
  }

  @override
  Future<void> restore(int id) async {
    final idx = _items.indexWhere((w) => w.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(clearDeletedAt: true);
    }
  }

  @override
  Future<int> deleteMany(List<int> ids) async {
    var count = 0;
    for (final id in ids) {
      final i = _items.indexWhere((w) => w.id == id && !w.isDeleted);
      if (i != -1) {
        _items[i] = _items[i].copyWith(deletedAt: DateTime.now());
        count++;
      }
    }
    return count;
  }
}
