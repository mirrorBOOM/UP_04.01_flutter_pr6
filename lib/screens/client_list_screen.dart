import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/auth_models.dart';
import '../models/client.dart';
import '../repositories/persistent_workout_repository.dart';
import '../state/auth_notifier.dart';
import '../widgets/entity_table.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FitnessClubRepository>();
    final auth = context.watch<AuthNotifier>();
    final clients = repo.allClients;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final canManage = auth.hasRole(Role.trainer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Клиенты клуба'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.go('/clients/new'),
              icon: const Icon(Icons.person_add),
              label: const Text('Добавить клиента'),
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: clients.isEmpty
              ? const Center(child: Text('Список клиентов пуст'))
              : isMobile
              ? ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: clients.length,
                  itemBuilder: (ctx, i) {
                    final c = clients[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    c.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (canManage) ...[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () =>
                                        context.go('/clients/${c.id}/edit'),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await repo.deleteClient(c.id);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              '${c.email} • ${c.phone}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Chip(
                              label: Text(
                                'Карта: ${c.card.cardNumber} (до ${c.card.validUntil})',
                              ),
                              backgroundColor: Colors.orange.shade50,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : EntityTable<Client>(
                  items: clients,
                  idOf: (c) => c.id,
                  columns: [
                    TableColumnSpec(
                      label: 'ФИО клиента',
                      build: (c) => Text(
                        c.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TableColumnSpec(
                      label: 'Email',
                      build: (c) =>
                          Text(c.email, overflow: TextOverflow.ellipsis),
                    ),
                    TableColumnSpec(
                      label: 'Телефон',
                      build: (c) => Text(c.phone),
                    ),
                    TableColumnSpec(
                      label: 'Клубная карта (1:1)',
                      build: (c) => Chip(
                        label: Text(
                          '${c.card.cardNumber} (до ${c.card.validUntil})',
                        ),
                        backgroundColor: Colors.orange.shade50,
                      ),
                    ),
                  ],
                  actions: canManage
                      ? (c) => [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Редактировать',
                            onPressed: () =>
                                context.go('/clients/${c.id}/edit'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Удалить',
                            onPressed: () async {
                              await repo.deleteClient(c.id);
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
