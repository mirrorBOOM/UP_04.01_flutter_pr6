import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/auth_models.dart';
import '../repositories/persistent_workout_repository.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final List<Map<String, dynamic>> _systemUsers = [
    {
      'id': 1,
      'username': 'admin',
      'name': 'Главный Администратор',
      'role': Role.admin,
    },
    {
      'id': 2,
      'username': 'trainer_alex',
      'name': 'Александр Ковалёв',
      'role': Role.trainer,
    },
    {
      'id': 3,
      'username': 'trainer_elena',
      'name': 'Елена Миронова',
      'role': Role.trainer,
    },
    {
      'id': 4,
      'username': 'client_ivan',
      'name': 'Иван Иванов',
      'role': Role.client,
    },
    {
      'id': 5,
      'username': 'client_anna',
      'name': 'Анна Смирнова',
      'role': Role.client,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FitnessClubRepository>();
    final hallsCount = repo.allHalls.length;
    final clientsCount = repo.allClients.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель администратора клуба'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _stat(
                        'Пользователей',
                        '${_systemUsers.length}',
                        Icons.people,
                      ),
                      _stat(
                        'Клиентских карт',
                        '$clientsCount',
                        Icons.credit_card,
                      ),
                      _stat('Залов клуба', '$hallsCount', Icons.meeting_room),
                      _stat(
                        'Статус системы',
                        'АКТИВНА',
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Сотрудники и роли',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Новый сотрудник успешно зарегистрирован',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Добавить'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _systemUsers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final u = _systemUsers[index];
                    final Role currentRole = u['role'] as Role;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _roleColor(
                          currentRole,
                        ).withValues(alpha: 0.15),
                        child: Icon(
                          _roleIcon(currentRole),
                          color: _roleColor(currentRole),
                        ),
                      ),
                      title: Text(
                        u['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${u['username']} • Уровень ${currentRole.level}',
                      ),
                      trailing: DropdownButton<Role>(
                        value: currentRole,
                        underline: const SizedBox(),
                        items: Role.values
                            .map(
                              (r) => DropdownMenuItem(
                                value: r,
                                child: Text(r.label),
                              ),
                            )
                            .toList(),
                        onChanged: (newRole) {
                          if (newRole != null) {
                            setState(() => u['role'] = newRole);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, [Color? iconColor]) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Icon(icon, color: iconColor ?? Colors.deepPurple, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _roleColor(Role r) => switch (r) {
    Role.admin => Colors.deepPurple,
    Role.trainer => Colors.blue,
    Role.client => Colors.green,
  };

  IconData _roleIcon(Role r) => switch (r) {
    Role.admin => Icons.admin_panel_settings,
    Role.trainer => Icons.sports,
    Role.client => Icons.person,
  };
}
