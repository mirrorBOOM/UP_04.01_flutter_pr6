import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/auth_models.dart';
import '../models/workout_category.dart';
import '../repositories/persistent_workout_repository.dart';
import '../state/auth_notifier.dart';
import '../widgets/entity_table.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void _showCategoryDialog([WorkoutCategory? category]) {
    final isEditing = category != null;
    final nameCtrl = TextEditingController(text: category?.name ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isEditing ? 'Редактировать категорию' : 'Новая категория фитнеса',
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Название категории',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final repo = context.read<FitnessClubRepository>();
              await repo.saveCategory(
                WorkoutCategory(
                  id: isEditing
                      ? category.id
                      : (DateTime.now().millisecondsSinceEpoch ~/ 1000),
                  name: nameCtrl.text.trim(),
                ),
              );
              if (ctx.mounted) Navigator.pop(ctx);
              setState(() {});
            },
            child: Text(isEditing ? 'Сохранить' : 'Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FitnessClubRepository>();
    final auth = context.watch<AuthNotifier>();
    final categories = repo.allCategories;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final canManage = auth.hasRole(Role.trainer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории фитнеса'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => _showCategoryDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Добавить категорию'),
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: isMobile
              ? ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    final c = categories[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${c.id}')),
                        title: Text(
                          c.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
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
                                    onPressed: () => _showCategoryDialog(c),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await repo.deleteCategory(c.id);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                )
              : EntityTable<WorkoutCategory>(
                  items: categories,
                  idOf: (c) => c.id,
                  columns: [
                    TableColumnSpec(
                      label: 'ID',
                      numeric: true,
                      build: (c) => Text('${c.id}'),
                    ),
                    TableColumnSpec(
                      label: 'Название категории',
                      build: (c) => Text(
                        c.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  actions: canManage
                      ? (c) => [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Редактировать',
                            onPressed: () => _showCategoryDialog(c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Удалить',
                            onPressed: () async {
                              await repo.deleteCategory(c.id);
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
