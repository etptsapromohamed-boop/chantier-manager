import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/finance/data/finance_repository.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';
import 'package:drift/drift.dart' as drift;

/// Dialog for adding a new transaction (Income or Expense)
class AddTransactionDialog extends ConsumerStatefulWidget {
  final String cashboxId;

  const AddTransactionDialog({
    super.key,
    required this.cashboxId,
  });

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceController = TextEditingController();

  String _transactionType = 'expense'; // 'income' or 'expense'
  TransactionCategory? _selectedCategory;
  User? _selectedWorker;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _transactionType == 'income' ? Colors.green : Colors.red,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _transactionType == 'income'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _transactionType == 'income'
                        ? 'Nouvelle Entrée'
                        : 'Nouvelle Dépense',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transaction Type Toggle
                      Row(
                        children: [
                          Expanded(
                            child: _TypeButton(
                              label: '📥 Entrée',
                              isSelected: _transactionType == 'income',
                              color: Colors.green,
                              onTap: () {
                                setState(() {
                                  _transactionType = 'income';
                                  _selectedCategory = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TypeButton(
                              label: '📤 Dépense',
                              isSelected: _transactionType == 'expense',
                              color: Colors.red,
                              onTap: () {
                                setState(() {
                                  _transactionType = 'expense';
                                  _selectedCategory = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Category Selector
                      const Text(
                        'Catégorie *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildCategorySelector(),

                      const SizedBox(height: 20),

                      // Amount
                      TextFormField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: 'Montant (TND) *',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un montant';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Montant invalide';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir une description';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Reference (optional)
                      TextFormField(
                        controller: _referenceController,
                        decoration: const InputDecoration(
                          labelText: 'Référence (N° facture, reçu)',
                          prefixIcon: Icon(Icons.receipt),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date Picker
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Date'),
                        subtitle: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: _selectDate,
                      ),

                      // Worker Selector (if category is user-related)
                      if (_selectedCategory?.isUserRelated == true) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Worker concerné *',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildWorkerSelector(),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: const Text('Enregistrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _transactionType == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final repository = ref.watch(financeRepositoryProvider);

    return FutureBuilder<List<TransactionCategory>>(
      future: repository.getCategoriesByType(_transactionType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final categories = snapshot.data!;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = _selectedCategory?.id == category.id;
            final color = Color(
              int.parse(category.color.replaceFirst('#', '0xFF')),
            );

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (category.icon != null)
                    Icon(
                      _getIconData(category.icon!),
                      size: 16,
                      color: isSelected ? Colors.white : color,
                    ),
                  const SizedBox(width: 4),
                  Text(category.name),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                  _selectedWorker = null; // Reset worker when category changes
                });
              },
              selectedColor: color,
              backgroundColor: color.withOpacity(0.1),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildWorkerSelector() {
    final db = ref.watch(appDatabaseProvider);

    return FutureBuilder<List<User>>(
      future: (db.select(db.users)..where((t) => t.role.equals('worker'))).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final workers = snapshot.data!;

        return DropdownButtonFormField<User>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          hint: const Text('Sélectionner un worker'),
          value: _selectedWorker,
          items: workers.map((worker) {
            return DropdownMenuItem(
              value: worker,
              child: Text('${worker.firstName} ${worker.lastName}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedWorker = value;
            });
          },
          validator: (value) {
            if (_selectedCategory?.isUserRelated == true && value == null) {
              return 'Veuillez sélectionner un worker';
            }
            return null;
          },
        );
      },
    );
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une catégorie')),
      );
      return;
    }

    final repository = ref.read(financeRepositoryProvider);
    final db = ref.read(appDatabaseProvider);

    // Get current user ID
    // TODO: Replace with actual auth user ID
    final users = await db.select(db.users).get();
    final currentUserId = users.isNotEmpty ? users.first.id : '';

    try {
      await repository.createTransaction(
        TransactionsCompanion.insert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          cashboxId: widget.cashboxId,
          type: _transactionType,
          amount: double.parse(_amountController.text),
          categoryId: _selectedCategory!.id,
          description: _descriptionController.text,
          reference: drift.Value(_referenceController.text.isEmpty
              ? null
              : _referenceController.text),
          date: _selectedDate,
          createdBy: currentUserId,
          relatedUserId: drift.Value(_selectedWorker?.id),
        ),
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Transaction enregistrée'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getIconData(String iconName) {
    // Map icon names to IconData
    final iconMap = {
      'person': Icons.person,
      'payments': Icons.payments,
      'account_balance_wallet': Icons.account_balance_wallet,
      'construction': Icons.construction,
      'local_shipping': Icons.local_shipping,
      'bolt': Icons.bolt,
      'build': Icons.build,
      'description': Icons.description,
      'restaurant': Icons.restaurant,
      'account_balance': Icons.account_balance,
      'attach_money': Icons.attach_money,
      'receipt': Icons.receipt,
    };

    return iconMap[iconName] ?? Icons.circle;
  }
}

// Helper widget for transaction type selection
class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
