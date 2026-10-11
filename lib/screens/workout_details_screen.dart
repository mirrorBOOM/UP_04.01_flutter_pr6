import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../repositories/workout_repository.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final int workoutId;

  const WorkoutDetailsScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<WorkoutRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Карточка тренировки #$workoutId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: FutureBuilder<Workout?>(
        future: repo.findById(workoutId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final item = snapshot.data;
          if (item == null) {
            return const Center(child: Text('Тренировка не найдена'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Text('Артикул программы: ${item.code}'),
                      Text('Продолжительность: ${item.durationMinutes} минут'),
                      Text('Сжигание калорий: ~${item.caloriesBurned} ккал'),
                      Text('Уровень нагрузки: ${item.intensity} из 5'),
                      Text(
                        'Свободно мест в группе: ${item.capacityAvailable} из ${item.capacityTotal}',
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Назад к расписанию'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
