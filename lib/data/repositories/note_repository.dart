import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Fetch all notes for the current user
  Future<List<NoteModel>> fetchNotes() async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      print('Fetching notes for user: $userId'); // Debug log

      final querySnapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      print('Found ${querySnapshot.docs.length} notes'); // Debug log

      return querySnapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching notes: $e'); // Debug log
      if (e.toString().contains('FAILED_PRECONDITION')) {
        throw Exception('Missing Firestore index. Please create an index for "notes" collection with fields: userId (Ascending), updatedAt (Descending)');
      } else if (e.toString().contains('PERMISSION_DENIED')) {
        throw Exception('Permission denied. Please check Firestore security rules.');
      } else {
        throw Exception('Failed to fetch notes: $e');
      }
    }
  }

  // Add a new note
  Future<void> addNote(String text) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      print('Adding note for user: $userId'); // Debug log

      final now = DateTime.now();
      final note = NoteModel(
        id: '', // Firestore will generate this
        text: text.trim(),
        userId: userId,
        createdAt: now,
        updatedAt: now,
      );

      final docRef = await _firestore.collection('notes').add(note.toMap());
      print('Note added successfully with ID: ${docRef.id}'); // Debug log
    } catch (e) {
      print('Error adding note: $e'); // Debug log
      if (e.toString().contains('PERMISSION_DENIED')) {
        throw Exception('Permission denied. Please check Firestore security rules.');
      } else {
        throw Exception('Failed to add note: $e');
      }
    }
  }

  // Update an existing note
  Future<void> updateNote(String id, String text) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore.collection('notes').doc(id).update({
        'text': text.trim(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore.collection('notes').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
} 