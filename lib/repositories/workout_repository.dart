import '../models/page_result.dart';
import '../models/workout.dart';
import '../models/workout_query.dart';

abstract interface class WorkoutRepository {
  Future<PageResult<Workout>> find(WorkoutQuery query);
  Future<Workout?> findById(int id);
  Future<void> save(Workout workout);
  Future<void> softDelete(int id);
  Future<void> hardDelete(int id);
  Future<void> restore(int id);
  Future<int> deleteMany(List<int> ids);
  bool isCodeTaken(String code, [int? currentId]);
  int countWorkoutsInHall(int hallId);
}
