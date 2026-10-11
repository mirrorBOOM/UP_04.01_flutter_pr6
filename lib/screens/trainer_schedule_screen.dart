import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/auth_notifier.dart';

class TrainerScheduleScreen extends StatelessWidget {
  const TrainerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthNotifier>().user;

    final schedule = [
      {
        'time': '10:00 - 11:00',
        'title': 'CrossFit WOD Pro',
        'hall': 'Главный CrossFit зал',
        'count': '12/15 чел.',
      },
      {
        'time': '12:30 - 13:30',
        'title': 'Функциональный тренинг',
        'hall': 'Зал групповых программ',
        'count': '15/20 чел.',
      },
      {
        'time': '18:00 - 19:15',
        'title': 'Силовой бокс',
        'hall': 'Бойцовский ринг',
        'count': '8/12 чел.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Журнал тренера и расписание'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                color: Colors.deepOrange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.sports, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Инструктор: ${user?.fullName ?? ""}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Статус смены: На смене (3 тренировки сегодня)',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...schedule.map(
                (item) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Text(
                      item['time']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Text(item['title']!),
                    subtitle: Text('Локация: ${item['hall']}'),
                    trailing: Chip(
                      label: Text(item['count']!),
                      backgroundColor: Colors.green.shade50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
