import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/page_result.dart';
import '../models/workout.dart';
import '../models/workout_query.dart';
import '../repositories/workout_repository.dart';

enum LoadStatus { idle, loading, success, error }

class WorkoutListNotifier extends ChangeNotifier {
  final WorkoutRepository _repository;

  WorkoutListNotifier(this._repository);

  WorkoutQuery _query = const WorkoutQuery();
  PageResult<Workout> _result = PageResult.empty();
  LoadStatus _status = LoadStatus.idle;
  String? _error;
  final Set<int> _selected = {};
  Timer? _debounceTimer;

  WorkoutQuery get query => _query;
  PageResult<Workout> get result => _result;
  LoadStatus get status => _status;
  String? get error => _error;
  Set<int> get selected => Set.unmodifiable(_selected);
  bool get hasSelection => _selected.isNotEmpty;

  Future<void> load() async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _result = await _repository.find(_query);
      _status = LoadStatus.success;
    } catch (e) {
      _error = 'Ошибка загрузки тренировок: $e';
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> applyQuery(WorkoutQuery next) async {
    _query = next;
    _selected.clear();
    await load();
  }

  void setSearchDebounced(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      applyQuery(_query.copyWith(search: text, page: 1));
    });
  }

  void toggleSelection(int id) {
    if (_selected.contains(id)) {
      _selected.remove(id);
    } else {
      _selected.add(id);
    }
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    await _repository.deleteMany(_selected.toList());
    _selected.clear();
    await load();
  }

  Future<void> softDelete(int id) async {
    await _repository.softDelete(id);
    await load();
  }

  Future<void> restore(int id) async {
    await _repository.restore(id);
    await load();
  }

  Future<void> hardDelete(int id) async {
    await _repository.hardDelete(id);
    await load();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
