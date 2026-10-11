import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/auth_models.dart';
import '../models/trainer.dart';
import '../repositories/persistent_workout_repository.dart';
import '../state/auth_notifier.dart';
import '../widgets/entity_table.dart';

class TrainerListScreen extends StatefulWidget {
  const TrainerListScreen({super.key});

  @override
  State<TrainerListScreen> createState() => _TrainerListScreenState();
}

class _TrainerListScreenState extends State<TrainerListScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FitnessClubRepository>();
    final auth = context.watch<AuthNotifier>();
    final trainers = repo.allTrainers;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final canManage = auth.hasRole(Role.admin);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренерский состав клуба'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/trainers/new'),
              icon: const Icon(Icons.person_add),
              label: const Text('Добавить тренера'),
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: trainers.isEmpty
              ? const Center(child: Text('Список тренеров пуст'))
              : isMobile
              ? ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: trainers.length,
                  itemBuilder: (ctx, i) {
                    final t = trainers[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrange.shade50,
                          child: Text(
                            t.fullName.isNotEmpty ? t.fullName[0] : 'T',
                          ),
                        ),
                        title: Text(
                          t.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${t.specialization} • ${t.experienceYears} лет опыта',
                        ),
                        trailing: canManage
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () =>
                                        context.go('/trainers/${t.id}/edit'),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await repo.deleteTrainer(t.id);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            : Chip(label: Text(t.category)),
                      ),
                    );
                  },
                )
              : EntityTable<Trainer>(
                  items: trainers,
                  idOf: (t) => t.id,
                  columns: [
                    TableColumnSpec(
                      label: 'ФИО',
                      build: (t) => Text(
                        t.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TableColumnSpec(
                      label: 'Специализация',
                      build: (t) => Text(
                        t.specialization,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TableColumnSpec(
                      label: 'Категория',
                      build: (t) => Text(t.category),
                    ),
                    TableColumnSpec(
                      label: 'Опыт',
                      numeric: true,
                      build: (t) => Text('${t.experienceYears} лет'),
                    ),
                  ],
                  actions: canManage
                      ? (t) => [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Редактировать',
                            onPressed: () =>
                                context.go('/trainers/${t.id}/edit'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Удалить',
                            onPressed: () async {
                              await repo.deleteTrainer(t.id);
                              setState(() {});
                            },
                          ),
                        ]
                      : null,
                ),
        ),
      ),
    );
  }
}
