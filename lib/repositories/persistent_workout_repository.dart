import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';
import '../models/trainer.dart';
import '../models/gym_hall.dart';
import '../models/workout_category.dart';
import '../models/client.dart';
import '../models/workout_query.dart';
import '../models/page_result.dart';
import 'workout_repository.dart';

class FitnessClubRepository implements WorkoutRepository {
  final SharedPreferences _prefs;

  List<Workout> _workouts = [];
  List<Trainer> _trainers = [];
  List<GymHall> _halls = [];
  List<WorkoutCategory> _categories = [];
  List<Client> _clients = [];

  FitnessClubRepository(this._prefs) {
    _restoreAll();
  }

  void _restoreAll() {
    final hallsRaw = _prefs.getString('halls_v1');
    if (hallsRaw != null) {
      _halls = (jsonDecode(hallsRaw) as List)
          .map((e) => GymHall.fromJson(e))
          .toList();
    } else {
      _halls = [
        const GymHall(id: 1, name: 'Главный CrossFit зал', capacity: 25),
        const GymHall(id: 2, name: 'Зал групповых программ', capacity: 20),
        const GymHall(id: 3, name: 'Бойцовский ринг и татами', capacity: 15),
      ];
      _saveHalls();
    }

    final catsRaw = _prefs.getString('categories_v1');
    if (catsRaw != null) {
      _categories = (jsonDecode(catsRaw) as List)
          .map((e) => WorkoutCategory.fromJson(e))
          .toList();
    } else {
      _categories = [
        const WorkoutCategory(id: 1, name: 'Силовые'),
        const WorkoutCategory(id: 2, name: 'Кардио'),
        const WorkoutCategory(id: 3, name: 'Mind & Body'),
        const WorkoutCategory(id: 4, name: 'Единоборства'),
      ];
      _saveCategories();
    }

    final trainersRaw = _prefs.getString('trainers_v1');
    if (trainersRaw != null) {
      _trainers = (jsonDecode(trainersRaw) as List)
          .map((e) => Trainer.fromJson(e))
          .toList();
    } else {
      _trainers = [
        const Trainer(
          id: 1,
          fullName: 'Александр Ковалёв',
          specialization: 'CrossFit & TRX',
          experienceYears: 8,
          category: 'VIP',
        ),
        const Trainer(
          id: 2,
          fullName: 'Елена Миронова',
          specialization: 'Йога & Пилатес',
          experienceYears: 10,
          category: 'MASTER',
        ),
        const Trainer(
          id: 3,
          fullName: 'Руслан Багиров',
          specialization: 'Бокс & Кикбоксинг',
          experienceYears: 12,
          category: 'VIP',
        ),
      ];
      _saveTrainers();
    }

    final clientsRaw = _prefs.getString('clients_v1');
    if (clientsRaw != null) {
      _clients = (jsonDecode(clientsRaw) as List)
          .map((e) => Client.fromJson(e))
          .toList();
    } else {
      _clients = [
        const Client(
          id: 1,
          fullName: 'Иван Иванов',
          email: 'ivan@fitness.ru',
          phone: '+7 999 111-22-33',
          card: MembershipCard(
            cardNumber: 'CARD-101',
            validUntil: '2026-12-31',
            status: 'ACTIVE',
          ),
        ),
      ];
      _saveClients();
    }

    final workoutsRaw = _prefs.getString('workouts_v4');
    if (workoutsRaw != null) {
      _workouts = (jsonDecode(workoutsRaw) as List)
          .map((e) => Workout.fromJson(e))
          .toList();
    } else {
      _workouts = [
        const Workout(
          id: 1,
          title: 'CrossFit WOD Pro',
          code: 'CRF-101',
          durationMinutes: 60,
          caloriesBurned: 750,
          intensity: 5,
          hallId: 1,
          trainerId: 1,
          categoryIds: [1, 2],
          capacityTotal: 15,
          capacityAvailable: 4,
        ),
        const Workout(
          id: 2,
          title: 'Хатха-йога Баланс',
          code: 'YOG-201',
          durationMinutes: 75,
          caloriesBurned: 320,
          intensity: 2,
          hallId: 2,
          trainerId: 2,
          categoryIds: [3],
          capacityTotal: 20,
          capacityAvailable: 11,
        ),
        const Workout(
          id: 3,
          title: 'Бокс Classic',
          code: 'BOX-301',
          durationMinutes: 60,
          caloriesBurned: 800,
          intensity: 5,
          hallId: 3,
          trainerId: 3,
          categoryIds: [4],
          capacityTotal: 12,
          capacityAvailable: 2,
        ),
      ];
      _saveWorkouts();
    }
  }

  Future<void> _saveWorkouts() => _prefs.setString(
    'workouts_v4',
    jsonEncode(_workouts.map((e) => e.toJson()).toList()),
  );
  Future<void> _saveTrainers() => _prefs.setString(
    'trainers_v1',
    jsonEncode(_trainers.map((e) => e.toJson()).toList()),
  );
  Future<void> _saveHalls() => _prefs.setString(
    'halls_v1',
    jsonEncode(_halls.map((e) => e.toJson()).toList()),
  );
  Future<void> _saveCategories() => _prefs.setString(
    'categories_v1',
    jsonEncode(_categories.map((e) => e.toJson()).toList()),
  );
  Future<void> _saveClients() => _prefs.setString(
    'clients_v1',
    jsonEncode(_clients.map((e) => e.toJson()).toList()),
  );

  List<GymHall> get allHalls => List.unmodifiable(_halls);
  List<WorkoutCategory> get allCategories => List.unmodifiable(_categories);
  List<Trainer> get allTrainers => List.unmodifiable(_trainers);
  List<Client> get allClients => List.unmodifiable(_clients);

  @override
  Future<void> save(Workout item) async {
    final idx = _workouts.indexWhere((w) => w.id == item.id);
    if (idx != -1) {
      _workouts[idx] = item;
    } else {
      _workouts.add(item);
    }
    await _saveWorkouts();
  }

  @override
  bool isCodeTaken(String code, [int? currentId]) => _workouts.any(
    (w) => w.code.toLowerCase() == code.toLowerCase() && w.id != currentId,
  );

  @override
  int countWorkoutsInHall(int hallId) =>
      _workouts.where((w) => w.hallId == hallId && !w.isDeleted).length;

  @override
  Future<PageResult<Workout>> find(WorkoutQuery q) async {
    var rows = _workouts
        .where((w) => q.includeDeleted || !w.isDeleted)
        .toList();
    if (q.search.isNotEmpty) {
      final needle = q.search.toLowerCase();
      rows = rows
          .where(
            (w) =>
                w.title.toLowerCase().contains(needle) ||
                w.code.toLowerCase().contains(needle),
          )
          .toList();
    }
    final total = rows.length;
    final from = (q.page - 1) * q.size;
    final to = (from + q.size > total) ? total : from + q.size;
    final paged = from >= total ? <Workout>[] : rows.sublist(from, to);
    return PageResult(items: paged, page: q.page, size: q.size, total: total);
  }

  @override
  Future<Workout?> findById(int id) async {
    try {
      return _workouts.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> softDelete(int id) async {
    final i = _workouts.indexWhere((w) => w.id == id);
    if (i != -1) {
      _workouts[i] = _workouts[i].copyWith(deletedAt: DateTime.now());
      await _saveWorkouts();
    }
  }

  @override
  Future<void> hardDelete(int id) async {
    _workouts.removeWhere((w) => w.id == id);
    await _saveWorkouts();
  }

  @override
  Future<void> restore(int id) async {
    final i = _workouts.indexWhere((w) => w.id == id);
    if (i != -1) {
      _workouts[i] = _workouts[i].copyWith(clearDeletedAt: true);
      await _saveWorkouts();
    }
  }

  @override
  Future<int> deleteMany(List<int> ids) async {
    var count = 0;
    for (final id in ids) {
      final i = _workouts.indexWhere((w) => w.id == id && !w.isDeleted);
      if (i != -1) {
        _workouts[i] = _workouts[i].copyWith(deletedAt: DateTime.now());
        count++;
      }
    }
    await _saveWorkouts();
    return count;
  }

  Future<void> saveTrainer(Trainer trainer) async {
    final idx = _trainers.indexWhere((t) => t.id == trainer.id);
    if (idx != -1) {
      _trainers[idx] = trainer;
    } else {
      _trainers.add(trainer);
    }
    await _saveTrainers();
  }

  Future<void> deleteTrainer(int id) async {
    _trainers.removeWhere((t) => t.id == id);
    await _saveTrainers();
  }

  Trainer? findTrainerById(int id) {
    try {
      return _trainers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveHall(GymHall hall) async {
    final idx = _halls.indexWhere((h) => h.id == hall.id);
    if (idx != -1) {
      _halls[idx] = hall;
    } else {
      _halls.add(hall);
    }
    await _saveHalls();
  }

  Future<bool> deleteHall(int id) async {
    if (countWorkoutsInHall(id) > 0) return false;
    _halls.removeWhere((h) => h.id == id);
    await _saveHalls();
    return true;
  }

  Future<void> saveCategory(WorkoutCategory cat) async {
    final idx = _categories.indexWhere((c) => c.id == cat.id);
    if (idx != -1) {
      _categories[idx] = cat;
    } else {
      _categories.add(cat);
    }
    await _saveCategories();
  }

  Future<void> deleteCategory(int id) async {
    _categories.removeWhere((c) => c.id == id);
    await _saveCategories();
  }

  bool isClientEmailTaken(String email, [int? currentId]) => _clients.any(
    (c) => c.email.toLowerCase() == email.toLowerCase() && c.id != currentId,
  );

  Future<void> saveClient(Client client) async {
    final idx = _clients.indexWhere((c) => c.id == client.id);
    if (idx != -1) {
      _clients[idx] = client;
    } else {
      _clients.add(client);
    }
    await _saveClients();
  }

  Future<void> deleteClient(int id) async {
    _clients.removeWhere((c) => c.id == id);
    await _saveClients();
  }
}
