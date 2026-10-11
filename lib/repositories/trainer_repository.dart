import '../models/page_result.dart';
import '../models/trainer.dart';

abstract interface class TrainerRepository {
  Future<PageResult<Trainer>> find({
    String search = '',
    int page = 1,
    int size = 10,
  });
  Future<Trainer?> findById(int id);
}

class InMemoryTrainerRepository implements TrainerRepository {
  final List<Trainer> _trainers = const [
    Trainer(
      id: 1,
      fullName: 'Александр Ковалёв',
      specialization: 'CrossFit & TRX',
      experienceYears: 8,
      category: 'VIP',
    ),
    Trainer(
      id: 2,
      fullName: 'Елена Миронова',
      specialization: 'Йога, Пилатес, МФР',
      experienceYears: 10,
      category: 'MASTER',
    ),
    Trainer(
      id: 3,
      fullName: 'Руслан Багиров',
      specialization: 'Бокс & Кикбоксинг',
      experienceYears: 12,
      category: 'VIP',
    ),
    Trainer(
      id: 4,
      fullName: 'Денис Васильев',
      specialization: 'Сайклинг & HIIT',
      experienceYears: 5,
      category: 'PRO',
    ),
    Trainer(
      id: 5,
      fullName: 'Игорь Воронов',
      specialization: 'Body Pump & Табата',
      experienceYears: 6,
      category: 'PRO',
    ),
    Trainer(
      id: 6,
      fullName: 'Мария Соколова',
      specialization: 'Плавание & Аквааэробика',
      experienceYears: 7,
      category: 'MASTER',
    ),
    Trainer(
      id: 7,
      fullName: 'Анна Кузнецова',
      specialization: 'Zumba & Step',
      experienceYears: 4,
      category: 'PRO',
    ),
    Trainer(
      id: 8,
      fullName: 'Сергей Морозов',
      specialization: 'Пауэрлифтинг & Тяж. атлетика',
      experienceYears: 15,
      category: 'VIP',
    ),
  ];

  @override
  Future<PageResult<Trainer>> find({
    String search = '',
    int page = 1,
    int size = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var res = _trainers;
    if (search.isNotEmpty) {
      final needle = search.toLowerCase();
      res = res
          .where(
            (t) =>
                t.fullName.toLowerCase().contains(needle) ||
                t.specialization.toLowerCase().contains(needle),
          )
          .toList();
    }
    return PageResult(items: res, page: page, size: size, total: res.length);
  }

  @override
  Future<Trainer?> findById(int id) async {
    try {
      return _trainers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
