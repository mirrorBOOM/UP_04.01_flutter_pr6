import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/auth_models.dart';
import '../models/workout.dart';
import '../models/workout_query.dart';
import '../state/auth_notifier.dart';
import '../state/workout_list_notifier.dart';
import '../widgets/entity_table.dart';

class WorkoutListScreen extends StatefulWidget {
  final WorkoutQuery initialQuery;

  const WorkoutListScreen({super.key, required this.initialQuery});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery.search);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutListNotifier>().applyQuery(widget.initialQuery);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _syncUrl(WorkoutQuery q) {
    final params = <String, String>{
      if (q.search.isNotEmpty) 'search': q.search,
      if (q.trainerId != null) 'trainerId': q.trainerId.toString(),
      'page': q.page.toString(),
      'size': q.size.toString(),
    };
    context.go(Uri(path: '/', queryParameters: params).toString());
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<WorkoutListNotifier>();
    final auth = context.watch<AuthNotifier>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    final canManage = auth.hasRole(Role.trainer);

    return Scaffold(
      appBar: AppBar(
        title: Text('Фитнес-клуб (${auth.user?.fullName ?? ""})'),
        actions: [
          if (auth.user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Chip(
                label: Text(auth.user!.role.label),
                backgroundColor: Colors.white,
              ),
            ),
          if (auth.hasRole(Role.admin))
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Панель администратора',
              onPressed: () => context.go('/admin/users'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти из системы',
            onPressed: () => context.read<AuthNotifier>().logout(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepOrange),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Панель управления',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${auth.user?.fullName ?? ""} (${auth.user?.role.label ?? ""})',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('1. Каталог тренировок'),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            if (auth.user?.role == Role.client)
              ListTile(
                leading: const Icon(
                  Icons.credit_card,
                  color: Colors.deepOrange,
                ),
                title: const Text('Мой абонемент и кабинет'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/my-card');
                },
              ),
            if (auth.hasRole(Role.trainer))
              ListTile(
                leading: const Icon(Icons.event_note, color: Colors.blue),
                title: const Text('Журнал тренера и смены'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/trainer/schedule');
                },
              ),
            ListTile(
              leading: const Icon(Icons.sports),
              title: const Text('2. Тренеры клуба'),
              onTap: () {
                Navigator.pop(context);
                context.go('/trainers');
              },
            ),
            ListTile(
              leading: const Icon(Icons.meeting_room),
              title: const Text('3. Залы клуба'),
              onTap: () {
                Navigator.pop(context);
                context.go('/halls');
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('4. Категории фитнеса'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('5. Клиенты и карты'),
              onTap: () {
                Navigator.pop(context);
                context.go('/clients');
              },
            ),
            if (auth.hasRole(Role.admin))
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.deepPurple,
                ),
                title: const Text('6. Панель админа и статистика'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/users');
                },
              ),
          ],
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/workouts/new'),
              icon: const Icon(Icons.add),
              label: const Text('Добавить тренировку'),
            )
          : null,
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: 0,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.fitness_center),
                  label: 'Каталог',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.sports),
                  label: 'Тренеры',
                ),
                if (auth.user?.role == Role.client)
                  const NavigationDestination(
                    icon: Icon(Icons.credit_card),
                    label: 'Кабинет',
                  )
                else if (auth.hasRole(Role.admin))
                  const NavigationDestination(
                    icon: Icon(Icons.admin_panel_settings),
                    label: 'Админ',
                  )
                else
                  const NavigationDestination(
                    icon: Icon(Icons.event_note),
                    label: 'Смены',
                  ),
              ],
              onDestinationSelected: (idx) {
                if (idx == 1) context.go('/trainers');
                if (idx == 2) {
                  if (auth.user?.role == Role.client) {
                    context.go('/my-card');
                  } else if (auth.hasRole(Role.admin)) {
                    context.go('/admin/users');
                  } else {
                    context.go('/trainer/schedule');
                  }
                }
              },
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Поиск по названию или артикулу...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (text) {
                    notifier.setSearchDebounced(text);
                    _syncUrl(notifier.query.copyWith(search: text));
                  },
                ),
              ),
              Expanded(
                child: switch (notifier.status) {
                  LoadStatus.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  LoadStatus.error => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        Text(notifier.error ?? 'Ошибка'),
                        ElevatedButton(
                          onPressed: () => notifier.load(),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                  _ =>
                    notifier.result.items.isEmpty
                        ? const Center(child: Text('Пусто'))
                        : isMobile
                        ? ListView.builder(
                            itemCount: notifier.result.items.length,
                            itemBuilder: (ctx, i) {
                              final w = notifier.result.items[i];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  title: Text(
                                    w.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${w.code} | Зал #${w.hallId} | ${w.durationMinutes} мин',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (canManage)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () => context.go(
                                            '/workouts/${w.id}/edit',
                                          ),
                                        ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  onTap: () => context.go('/workouts/${w.id}'),
                                ),
                              );
                            },
                          )
                        : EntityTable<Workout>(
                            items: notifier.result.items,
                            idOf: (w) => w.id,
                            columns: [
                              TableColumnSpec(
                                label: 'Название (Карточка)',
                                build: (w) => InkWell(
                                  onTap: () => context.go('/workouts/${w.id}'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      w.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableColumnSpec(
                                label: 'Артикул',
                                build: (w) => Text(w.code),
                              ),
                              TableColumnSpec(
                                label: 'Зал ID',
                                numeric: true,
                                build: (w) => Text('${w.hallId}'),
                              ),
                              TableColumnSpec(
                                label: 'Категорий',
                                numeric: true,
                                build: (w) => Text('${w.categoryIds.length}'),
                              ),
                            ],
                            actions: (w) => [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.teal,
                                ),
                                tooltip: 'Посмотреть карточку',
                                onPressed: () =>
                                    context.go('/workouts/${w.id}'),
                              ),
                              if (canManage) ...[
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  tooltip: 'Редактировать',
                                  onPressed: () =>
                                      context.go('/workouts/${w.id}/edit'),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.orange,
                                  ),
                                  tooltip: 'Удалить',
                                  onPressed: () => notifier.softDelete(w.id),
                                ),
                              ],
                            ],
                          ),
                },
              ),
              _buildPagination(notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(WorkoutListNotifier notifier) {
    final res = notifier.result;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Всего: ${res.total} | Стр. ${res.page} из ${res.totalPages}'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: res.hasPrevious
                    ? () {
                        final next = notifier.query.copyWith(page: 1);
                        notifier.applyQuery(next);
                        _syncUrl(next);
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: res.hasPrevious
                    ? () {
                        final next = notifier.query.copyWith(
                          page: res.page - 1,
                        );
                        notifier.applyQuery(next);
                        _syncUrl(next);
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: res.hasNext
                    ? () {
                        final next = notifier.query.copyWith(
                          page: res.page + 1,
                        );
                        notifier.applyQuery(next);
                        _syncUrl(next);
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: res.hasNext
                    ? () {
                        final next = notifier.query.copyWith(
                          page: res.totalPages,
                        );
                        notifier.applyQuery(next);
                        _syncUrl(next);
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
