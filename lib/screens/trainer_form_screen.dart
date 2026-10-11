import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/trainer.dart';
import '../repositories/persistent_workout_repository.dart';
import '../utils/validators.dart';

class TrainerFormScreen extends StatefulWidget {
  final int? id;
  const TrainerFormScreen({super.key, this.id});

  @override
  State<TrainerFormScreen> createState() => _TrainerFormScreenState();
}

class _TrainerFormScreenState extends State<TrainerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _specController;
  late final TextEditingController _expController;
  String _category = 'PRO';

  bool get isEditing => widget.id != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _specController = TextEditingController();
    _expController = TextEditingController();

    if (isEditing) {
      final repo = context.read<FitnessClubRepository>();
      final item = repo.findTrainerById(widget.id!);
      if (item != null) {
        _nameController.text = item.fullName;
        _specController.text = item.specialization;
        _expController.text = item.experienceYears.toString();
        _category = item.category;
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<FitnessClubRepository>();

    final trainer = Trainer(
      id: isEditing
          ? widget.id!
          : DateTime.now().millisecondsSinceEpoch ~/ 1000,
      fullName: _nameController.text.trim(),
      specialization: _specController.text.trim(),
      experienceYears: int.parse(_expController.text.trim()),
      category: _category,
    );

    await repo.saveTrainer(trainer);
    if (mounted) context.go('/trainers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать тренера' : 'Новый тренер'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/trainers'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'ФИО тренера *',
                      border: OutlineInputBorder(),
                    ),
                    validator: AppValidators.requiredField,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specController,
                    decoration: const InputDecoration(
                      labelText: 'Специализация *',
                      border: OutlineInputBorder(),
                    ),
                    validator: AppValidators.requiredField,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _expController,
                    decoration: const InputDecoration(
                      labelText: 'Опыт работы (лет) *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: AppValidators.positiveInt,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Квалификация',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'PRO',
                        child: Text('PRO Инструктор'),
                      ),
                      DropdownMenuItem(
                        value: 'MASTER',
                        child: Text('MASTER Тренер'),
                      ),
                      DropdownMenuItem(
                        value: 'VIP',
                        child: Text('VIP Эксперт'),
                      ),
                    ],
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submit,
                    child: Text(
                      isEditing ? 'Сохранить изменения' : 'Добавить тренера',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
