import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String text;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert NoteModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create NoteModel from Firestore document
  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create a copy of NoteModel with updated fields
  NoteModel copyWith({
    String? id,
    String? text,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 