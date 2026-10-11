import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/client.dart';
import '../repositories/persistent_workout_repository.dart';
import '../utils/validators.dart';

class ClientFormScreen extends StatefulWidget {
  final int? id;
  const ClientFormScreen({super.key, this.id});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isDirty = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _validUntilController;

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _cardNumberController = TextEditingController();
    _validUntilController = TextEditingController();

    if (isEditing) {
      final repo = context.read<FitnessClubRepository>();
      final item = repo.allClients.cast<Client?>().firstWhere(
        (c) => c?.id == widget.id,
        orElse: () => null,
      );
      if (item != null) {
        _nameController.text = item.fullName;
        _emailController.text = item.email;
        _phoneController.text = item.phone;
        _cardNumberController.text = item.card.cardNumber;
        _validUntilController.text = item.card.validUntil;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _validUntilController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<FitnessClubRepository>();

    final client = Client(
      id: isEditing
          ? widget.id!
          : DateTime.now().millisecondsSinceEpoch ~/ 1000,
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      card: MembershipCard(
        cardNumber: _cardNumberController.text.trim(),
        validUntil: _validUntilController.text.trim(),
        status: 'ACTIVE',
      ),
    );

    await repo.saveClient(client);
    _isDirty = false;
    if (mounted) context.go('/clients');
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FitnessClubRepository>();

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _showDiscardDialog();
        if (leave && context.mounted) context.go('/clients');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? 'Редактировать клиента' : 'Новый клиент (Карта 1:1)',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/clients'),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                onChanged: () {
                  if (!_isDirty) setState(() => _isDirty = true);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Данные клиента:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'ФИО клиента *',
                        border: OutlineInputBorder(),
                      ),
                      validator: AppValidators.requiredField,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        final err = AppValidators.email(val);
                        if (err != null) return err;
                        if (repo.isClientEmailTaken(val!.trim(), widget.id)) {
                          return 'Клиент с таким email уже зарегистрирован';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Телефон *',
                        border: OutlineInputBorder(),
                      ),
                      validator: AppValidators.requiredField,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Клубная карта:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Номер карты *',
                        border: OutlineInputBorder(),
                      ),
                      validator: AppValidators.requiredField,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _validUntilController,
                      decoration: const InputDecoration(
                        labelText: 'Действует до (ГГГГ-ММ-ДД) *',
                        border: OutlineInputBorder(),
                      ),
                      validator: AppValidators.requiredField,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _submit,
                      child: Text(
                        isEditing
                            ? 'Сохранить изменения'
                            : 'Создать клиента и карту',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDiscardDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Несохранённые изменения'),
            content: const Text('Уйти без сохранения данных клиента?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Остаться'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Уйти'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
