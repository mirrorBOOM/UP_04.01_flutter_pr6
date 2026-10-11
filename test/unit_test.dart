import 'package:flutter_test/flutter_test.dart';
import 'package:up_4001_pr2/models/auth_models.dart';
import 'package:up_4001_pr2/models/workout.dart';
import 'package:up_4001_pr2/utils/validators.dart';

void main() {
  group('1. Тестирование валидаторов (AppValidators):', () {
    test('1.1. Пустая строка отклоняется валидатором обязательного поля', () {
      expect(AppValidators.requiredField(''), isNotNull);
      expect(AppValidators.requiredField('   '), isNotNull);
      expect(AppValidators.requiredField(null), isNotNull);
    });

    test('1.2. Непустая строка принимается валидатором', () {
      expect(AppValidators.requiredField('CrossFit'), isNull);
    });

    test('1.3. Проверка минимальной длины строки', () {
      expect(AppValidators.minLength('ab', 3), isNotNull);
      expect(AppValidators.minLength('abc', 3), isNull);
    });

    test('1.4. Проверка положительного числа', () {
      expect(AppValidators.positiveInt('0'), isNotNull);
      expect(AppValidators.positiveInt('-5'), isNotNull);
      expect(AppValidators.positiveInt('abc'), isNotNull);
      expect(AppValidators.positiveInt('45'), isNull);
    });

    test('1.5. Проверка формата электронной почты', () {
      expect(AppValidators.email('invalid-email'), isNotNull);
      expect(AppValidators.email('test@fitness.ru'), isNull);
    });
  });

  group('2. Тестирование парсинга моделей (Workout):', () {
    test('2.1. fromJson корректно обрабатывает пустые и null значения', () {
      final w = Workout.fromJson(const {});
      expect(w.id, 0);
      expect(w.title, '');
      expect(w.code, '');
      expect(w.durationMinutes, 0);
      expect(w.categoryIds, isEmpty);
      expect(w.isDeleted, false);
    });

    test('2.2. copyWith корректно обновляет поля без мутации объекта', () {
      const w = Workout(
        id: 1,
        title: 'Йога',
        code: 'YOG-1',
        durationMinutes: 60,
        caloriesBurned: 300,
        intensity: 2,
        hallId: 1,
        trainerId: 1,
        categoryIds: [1],
        capacityTotal: 10,
        capacityAvailable: 5,
      );

      final updated = w.copyWith(title: 'Хатха-йога', durationMinutes: 75);
      expect(updated.title, 'Хатха-йога');
      expect(updated.durationMinutes, 75);
      expect(updated.code, 'YOG-1');
    });
  });

  group('3. Тестирование логики прав и ролей (Role Hierarchy):', () {
    test('3.1. Иерархия уровней доступа ролей (Client < Trainer < Admin)', () {
      expect(Role.client.level < Role.trainer.level, isTrue);
      expect(Role.trainer.level < Role.admin.level, isTrue);
      expect(Role.admin.level >= Role.client.level, isTrue);
    });
  });
}
