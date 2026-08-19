import 'package:cloud_firestore/cloud_firestore.dart';
class ExpenseModel {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel(
      id: id,
      userId: (map['userId'] ?? '') as String,
      amount: ((map['amount'] ?? 0) as num).toDouble(),
      category: (map['category'] ?? 'Other') as String,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: map['note'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ExpenseModel copyWith({
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id,
      userId: userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
