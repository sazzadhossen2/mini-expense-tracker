import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/expense_model.dart';

/// Handles all CRUD operations against the top-level `expenses`
/// collection in Firestore. Every document carries a `userId` field so
/// each user only ever sees their own data (also enforced by
/// firestore.rules on the server side).
class ExpenseRepository extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('expenses');

  /// Real-time stream of the current user's expenses, newest first.
  /// Sorting is done client-side after the `where` filter so this works
  /// out of the box without requiring a Firestore composite index.
  Stream<List<ExpenseModel>> streamExpenses(String userId) {
    return _collection.where('userId', isEqualTo: userId).snapshots().map(
      (snapshot) {
        final list = snapshot.docs
            .map((doc) => ExpenseModel.fromMap(doc.data(), doc.id))
            .toList();
        list.sort((a, b) => b.date.compareTo(a.date));
        return list;
      },
    );
  }

  Future<void> addExpense(ExpenseModel expense) {
    return _collection.add(expense.toMap());
  }

  Future<void> updateExpense(ExpenseModel expense) {
    return _collection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) {
    return _collection.doc(id).delete();
  }
}
