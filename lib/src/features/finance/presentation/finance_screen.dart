import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chantier_manager/src/features/finance/data/finance_repository.dart';
import 'package:chantier_manager/src/features/finance/presentation/dialogs/add_transaction_dialog.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Finance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              // TODO: Navigate to reports
            },
            tooltip: 'Rapports',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _FinanceSummaryCard(),
          SizedBox(height: 16),
          _CashBoxesSection(),
          SizedBox(height: 16),
          _RecentTransactionsSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Get actual cashbox ID (use first cashbox for now)
          showDialog(
            context: context,
            builder: (context) => const AddTransactionDialog(
              cashboxId: '1', // Replace with actual cashboxId
            ),
          ).then((success) {
            if (success == true) {
              setState(() {}); // Refresh screen
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Transaction'),
      ),
    );
  }
}

// ========== SUMMARY CARD ==========
class _FinanceSummaryCard extends ConsumerWidget {
  const _FinanceSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Vue d\'Ensemble',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    title: 'Revenus',
                    amount: '45,000 TND',
                    color: Colors.green,
                    trend: '+12%',
                    icon: Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryItem(
                    title: 'Dépenses',
                    amount: '32,000 TND',
                    color: Colors.red,
                    trend: '-5%',
                    icon: Icons.arrow_downward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Solde Net: 13,000 TND',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final String trend;
  final IconData icon;

  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.color,
    required this.trend,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(trend, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ],
    );
  }
}

// ========== CASH BOXES SECTION ==========
class _CashBoxesSection extends ConsumerWidget {
  const _CashBoxesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏦 Caisses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.account_balance, color: Colors.white),
            ),
            title: const Text('Caisse Chantier Principal'),
            subtitle: const Text('Solde: 8,500 TND'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Détails'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Transactions'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.credit_card, color: Colors.white),
            ),
            title: const Text('Compte Banque BNA'),
            subtitle: const Text('Solde: 4,500 TND'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Détails'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Transactions'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ========== RECENT TRANSACTIONS SECTION ==========
class _RecentTransactionsSection extends ConsumerWidget {
  const _RecentTransactionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📜 Transactions Récentes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _TransactionTile(
                type: 'income',
                title: 'Alimentation Caisse',
                amount: '+5,000 TND',
                date: '01/02',
                icon: Icons.arrow_upward,
                color: Colors.green,
              ),
              const Divider(height: 1),
              _TransactionTile(
                type: 'expense',
                title: 'Achat Matériaux',
                amount: '-2,500 TND',
                date: '31/01',
                icon: Icons.arrow_downward,
                color: Colors.red,
              ),
              const Divider(height: 1),
              _TransactionTile(
                type: 'expense',
                title: 'Salaires',
                amount: '-8,000 TND',
                date: '28/01',
                icon: Icons.arrow_downward,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String type;
  final String title;
  final String amount;
  final String date;
  final IconData icon;
  final Color color;

  const _TransactionTile({
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
