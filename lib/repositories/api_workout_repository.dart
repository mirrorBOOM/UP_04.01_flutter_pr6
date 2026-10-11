import 'package:dio/dio.dart';
import '../core/api_exceptions.dart';
import '../models/workout.dart';
import '../models/workout_query.dart';
import '../models/page_result.dart';
import 'workout_repository.dart';

class ApiWorkoutRepository implements WorkoutRepository {
  final Dio _dio;
  CancelToken? _searchCancelToken;

  ApiWorkoutRepository(this._dio);

  @override
  Future<PageResult<Workout>> find(WorkoutQuery q) => guard(() async {
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
  });

  @override
  Future<Workout?> findById(int id) => guard(() async {
    final response = await _dio.get('/workouts/$id');
    return Workout.fromJson(response.data as Map<String, dynamic>);
  });

  @override
  Future<void> save(Workout workout) => guard(() async {
    if (workout.id > 100000) {
      await _dio.post('/workouts', data: workout.toJson());
    } else {
      await _dio.put('/workouts/${workout.id}', data: workout.toJson());
    }
  });

  @override
  Future<void> softDelete(int id) => guard(() async {
    await _dio.delete('/workouts/$id');
  });

  @override
  Future<void> hardDelete(int id) => guard(() async {
    await _dio.delete('/workouts/$id', queryParameters: {'hard': true});
  });

  @override
  Future<void> restore(int id) => guard(() async {
    await _dio.post('/workouts/$id/restore');
  });

  @override
  Future<int> deleteMany(List<int> ids) => guard(() async {
    final res = await _dio.post('/workouts/bulk-delete', data: {'ids': ids});
    return (res.data as Map<String, dynamic>)['deleted'] as int? ?? ids.length;
  });

  @override
  bool isCodeTaken(String code, [int? currentId]) {
    return false;
  }

  @override
  int countWorkoutsInHall(int hallId) {
    return 0;
  }
}
