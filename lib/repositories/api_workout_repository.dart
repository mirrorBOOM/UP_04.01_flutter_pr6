import 'package:dio/dio.dart';
import '../models/workout.dart';
import '../models/workout_query.dart';
import '../models/page_result.dart';
import 'workout_repository.dart';

class ApiWorkoutRepository implements WorkoutRepository {
  final Dio _dio;
  CancelToken? _searchCancelToken;

  static final List<Workout> _fallbackWorkouts = [
    const Workout(id: 1, title: 'CrossFit WOD Pro', code: 'CRF-101', durationMinutes: 60, caloriesBurned: 750, intensity: 5, hallId: 1, trainerId: 1, categoryIds: [1, 2], capacityTotal: 15, capacityAvailable: 4),
    const Workout(id: 2, title: 'Хатха-йога Баланс', code: 'YOG-201', durationMinutes: 75, caloriesBurned: 320, intensity: 2, hallId: 2, trainerId: 2, categoryIds: [3], capacityTotal: 20, capacityAvailable: 11),
    const Workout(id: 3, title: 'Бокс Classic', code: 'BOX-301', durationMinutes: 60, caloriesBurned: 800, intensity: 5, hallId: 3, trainerId: 3, categoryIds: [4], capacityTotal: 12, capacityAvailable: 2),
    const Workout(id: 4, title: 'Пилатес Mat', code: 'PIL-401', durationMinutes: 55, caloriesBurned: 280, intensity: 2, hallId: 2, trainerId: 2, categoryIds: [3], capacityTotal: 18, capacityAvailable: 7),
    const Workout(id: 5, title: 'Сайклинг Race', code: 'CYC-501', durationMinutes: 45, caloriesBurned: 650, intensity: 4, hallId: 1, trainerId: 1, categoryIds: [2], capacityTotal: 20, capacityAvailable: 8),
    const Workout(id: 6, title: 'Body Pump', code: 'PMP-601', durationMinutes: 60, caloriesBurned: 580, intensity: 4, hallId: 2, trainerId: 2, categoryIds: [1], capacityTotal: 25, capacityAvailable: 12),
  ];

  ApiWorkoutRepository(this._dio);

  @override
  Future<PageResult<Workout>> find(WorkoutQuery q) async {
    try {
      _searchCancelToken?.cancel();
      _searchCancelToken = CancelToken();

      final queryMap = <String, dynamic>{
        if (q.search.trim().isNotEmpty) 'search': q.search.trim(),
        if (q.trainerId != null) 'trainerId': q.trainerId,
        'sort': '${q.sortField},${q.sortAscending ? 'asc' : 'desc'}',
        'page': q.page,
        'size': q.size,
        if (q.includeDeleted) 'includeDeleted': true,
      };

      final response = await _dio.get(
        '/workouts',
        queryParameters: queryMap,
        cancelToken: _searchCancelToken,
      );

      final data = response.data as Map<String, dynamic>;
      final items = (data['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Workout.fromJson)
          .toList();

      return PageResult(
        items: items,
        page: data['page'] as int? ?? 1,
        size: data['size'] as int? ?? q.size,
        total: data['total'] as int? ?? 0,
      );
    } catch (_) {
      var list = List<Workout>.from(_fallbackWorkouts);
      if (q.search.isNotEmpty) {
        final s = q.search.toLowerCase();
        list = list.where((w) => w.title.toLowerCase().contains(s) || w.code.toLowerCase().contains(s)).toList();
      }
      return PageResult(items: list, page: 1, size: 10, total: list.length);
    }
  }

  @override
  Future<Workout?> findById(int id) async {
    try {
      final response = await _dio.get('/workouts/$id');
      return Workout.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _fallbackWorkouts.firstWhere((w) => w.id == id, orElse: () => _fallbackWorkouts.first);
    }
  }

  @override
  Future<void> save(Workout workout) async {
    try {
      if (workout.id > 100000) {
        await _dio.post('/workouts', data: workout.toJson());
      } else {
        await _dio.put('/workouts/${workout.id}', data: workout.toJson());
      }
    } catch (_) {
      final idx = _fallbackWorkouts.indexWhere((w) => w.id == workout.id);
      if (idx != -1) {
        _fallbackWorkouts[idx] = workout;
      } else {
        _fallbackWorkouts.add(workout);
      }
    }
  }

  @override
  Future<void> softDelete(int id) async {
    try {
      await _dio.delete('/workouts/$id');
    } catch (_) {
      _fallbackWorkouts.removeWhere((w) => w.id == id);
    }
  }

  @override
  Future<void> hardDelete(int id) => softDelete(id);

  @override
  Future<void> restore(int id) async {}

  @override
  Future<int> deleteMany(List<int> ids) async {
    try {
      final res = await _dio.post('/workouts/bulk-delete', data: {'ids': ids});
      return (res.data as Map<String, dynamic>)['deleted'] as int? ?? ids.length;
    } catch (_) {
      _fallbackWorkouts.removeWhere((w) => ids.contains(w.id));
      return ids.length;
    }
  }

  @override
  bool isCodeTaken(String code, [int? currentId]) => false;

  @override
  int countWorkoutsInHall(int hallId) => 0;
}