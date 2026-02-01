import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chantier_manager/src/features/core/data/local/app_database.dart';

part 'finance_repository.g.dart';

@Riverpod(keepAlive: true)
FinanceRepository financeRepository(FinanceRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return FinanceRepository(db);
}

class FinanceRepository {
  final AppDatabase _db;

  FinanceRepository(this._db);

  // ========== CASH BOX ==========

  /// Get all active cash boxes
  Future<List<CashBoxData>> getAllCashBoxes() async {
    return (_db.select(_db.cashBox)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Get cash boxes for a specific project
  Future<List<CashBoxData>> getCashBoxesByProject(String projectId) async {
    return (_db.select(_db.cashBox)
          ..where((t) => t.projectId.equals(projectId) & t.isActive.equals(true)))
        .get();
  }

  /// Get a single cash box by ID
  Future<CashBoxData?> getCashBox(String id) async {
    return (_db.select(_db.cashBox)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Create a new cash box
  Future<void> createCashBox(CashBoxCompanion cashbox) async {
    await _db.into(_db.cashBox).insert(cashbox);
  }

  /// Update an existing cash box
  Future<void> updateCashBox(String id, CashBoxCompanion cashbox) async {
    await (_db.update(_db.cashBox)..where((t) => t.id.equals(id))).write(cashbox);
  }

  /// Archive (soft delete) a cash box
  Future<void> archiveCashBox(String id) async {
    await (_db.update(_db.cashBox)..where((t) => t.id.equals(id)))
        .write(const CashBoxCompanion(isActive: Value(false)));
  }

  // ========== TRANSACTION CATEGORIES ==========

  /// Get all transaction categories
  Future<List<TransactionCategory>> getAllTransactionCategories() async {
    return (_db.select(_db.transactionCategories)
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  /// Get categories by type (income/expense)
  Future<List<TransactionCategory>> getCategoriesByType(String type) async {
    return (_db.select(_db.transactionCategories)
          ..where((t) => t.type.equals(type) | t.type.equals('both'))
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  /// Get user-related categories (for salaries, advances, etc.)
  Future<List<TransactionCategory>> getUserRelatedCategories() async {
    return (_db.select(_db.transactionCategories)
          ..where((t) => t.isUserRelated.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.order)]))
        .get();
  }

  /// Create a new transaction category
  Future<void> createTransactionCategory(TransactionCategoriesCompanion category) async {
    await _db.into(_db.transactionCategories).insert(category);
  }

  /// Update a transaction category
  Future<void> updateTransactionCategory(
      String id, TransactionCategoriesCompanion category) async {
    await (_db.update(_db.transactionCategories)..where((t) => t.id.equals(id)))
        .write(category);
  }

  /// Delete a transaction category
  Future<void> deleteTransactionCategory(String id) async {
    await (_db.delete(_db.transactionCategories)..where((t) => t.id.equals(id))).go();
  }

  // ========== TRANSACTIONS ==========

  /// Get all transactions for a cash box
  Future<List<Transaction>> getTransactionsByCashBox(String cashboxId) async {
    return (_db.select(_db.transactions)
          ..where((t) => t.cashboxId.equals(cashboxId))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }

  /// Get transactions with category details
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory(
      String cashboxId) async {
    final query = _db.select(_db.transactions).join([
      leftOuterJoin(_db.transactionCategories,
          _db.transactionCategories.id.equalsExp(_db.transactions.categoryId)),
    ])
      ..where(_db.transactions.cashboxId.equals(cashboxId))
      ..orderBy([OrderingTerm(expression: _db.transactions.date, mode: OrderingMode.desc)]);

    final results = await query.get();

    return results.map((row) {
      return {
        'transaction': row.readTable(_db.transactions),
        'category': row.readTableOrNull(_db.transactionCategories),
      };
    }).toList();
  }

  /// Get all transactions for a specific user (worker advances, salaries, etc.)
  Future<List<Map<String, dynamic>>> getUserTransactions(String userId) async {
    final query = _db.select(_db.transactions).join([
      leftOuterJoin(_db.transactionCategories,
          _db.transactionCategories.id.equalsExp(_db.transactions.categoryId)),
      leftOuterJoin(_db.cashBox,
          _db.cashBox.id.equalsExp(_db.transactions.cashboxId)),
    ])
      ..where(_db.transactions.relatedUserId.equals(userId))
      ..orderBy([OrderingTerm(expression: _db.transactions.date, mode: OrderingMode.desc)]);

    final results = await query.get();

    return results.map((row) {
      return {
        'transaction': row.readTable(_db.transactions),
        'category': row.readTableOrNull(_db.transactionCategories),
        'cashbox': row.readTableOrNull(_db.cashBox),
      };
    }).toList();
  }

  /// Get transactions by date range
  Future<List<Map<String, dynamic>>> getTransactionsByDateRange({
    required String cashboxId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final query = _db.select(_db.transactions).join([
      leftOuterJoin(_db.transactionCategories,
          _db.transactionCategories.id.equalsExp(_db.transactions.categoryId)),
    ])
      ..where(_db.transactions.cashboxId.equals(cashboxId) &
          _db.transactions.date.isBiggerOrEqualValue(startDate) &
          _db.transactions.date.isSmallerOrEqualValue(endDate))
      ..orderBy([OrderingTerm(expression: _db.transactions.date, mode: OrderingMode.desc)]);

    final results = await query.get();

    return results.map((row) {
      return {
        'transaction': row.readTable(_db.transactions),
        'category': row.readTableOrNull(_db.transactionCategories),
      };
    }).toList();
  }

  /// Create a new transaction
  Future<void> createTransaction(TransactionsCompanion transaction) async {
    await _db.transaction(() async {
      // Insert transaction
      await _db.into(_db.transactions).insert(transaction);

      // Update cash box balance
      final amount = transaction.amount.value;
      final type = transaction.type.value;
      final cashboxId = transaction.cashboxId.value;

      final cashbox = await getCashBox(cashboxId);
      if (cashbox != null) {
        final newBalance = type == 'income'
            ? cashbox.currentBalance + amount
            : cashbox.currentBalance - amount;

        await updateCashBox(
          cashboxId,
          CashBoxCompanion(currentBalance: Value(newBalance)),
        );
      }
    });
  }

  /// Delete a transaction and update balance
  Future<void> deleteTransaction(String id) async {
    await _db.transaction(() async {
      // Get transaction details before deleting
      final transaction = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

      if (transaction != null) {
        // Reverse the balance change
        final cashbox = await getCashBox(transaction.cashboxId);
        if (cashbox != null) {
          final newBalance = transaction.type == 'income'
              ? cashbox.currentBalance - transaction.amount
              : cashbox.currentBalance + transaction.amount;

          await updateCashBox(
            transaction.cashboxId,
            CashBoxCompanion(currentBalance: Value(newBalance)),
          );
        }

        // Delete transaction
        await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
      }
    });
  }

  // ========== STATISTICS ==========

  /// Get user balance (total advances - total salaries)
  Future<Map<String, dynamic>> getUserBalance(String userId) async {
    final transactions = await (_db.select(_db.transactions)
          ..where((t) => t.relatedUserId.equals(userId)))
        .get();

    double totalAdvances = 0;
    double totalSalaries = 0;
    double totalAcomptes = 0;

    for (final transaction in transactions) {
      final category = await (_db.select(_db.transactionCategories)
            ..where((t) => t.id.equals(transaction.categoryId)))
          .getSingleOrNull();

      if (category != null) {
        if (category.name == 'Avances sur Salaire') {
          totalAdvances += transaction.amount;
        } else if (category.name == 'Salaires') {
          totalSalaries += transaction.amount;
        } else if (category.name == 'Acomptes') {
          totalAcomptes += transaction.amount;
        }
      }
    }

    final balance = totalSalaries - (totalAdvances + totalAcomptes);

    return <String, dynamic>{
      'user_id': userId,
      'total_advances': totalAdvances,
      'total_salaries': totalSalaries,
      'total_acomptes': totalAcomptes,
      'balance': balance,
      'transaction_count': transactions.length,
    };
  }

  /// Get cash box summary (income vs expense)
  Future<Map<String, dynamic>> getCashBoxSummary(String cashboxId) async {
    final transactions = await getTransactionsByCashBox(cashboxId);

    double totalIncome = 0;
    double totalExpense = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    return {
      'cashbox_id': cashboxId,
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'net_balance': totalIncome - totalExpense,
      'transaction_count': transactions.length,
    };
  }

  /// Get statistics by category for a period
  Future<Map<String, double>> getStatsByCategory({
    required String cashboxId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactionsWithCategories = await getTransactionsByDateRange(
      cashboxId: cashboxId,
      startDate: startDate,
      endDate: endDate,
    );

    final statsByCategory = <String, double>{};

    for (final item in transactionsWithCategories) {
      final transaction = item['transaction'] as Transaction;
      final category = item['category'] as TransactionCategory?;

      if (category != null) {
        final categoryName = category.name;
        statsByCategory[categoryName] =
            (statsByCategory[categoryName] ?? 0) + transaction.amount;
      }
    }

    return statsByCategory;
  }
}
