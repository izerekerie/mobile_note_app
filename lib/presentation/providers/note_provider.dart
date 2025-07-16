import 'package:flutter/material.dart';
import '../../screens/data/models/note_model.dart';
import '../../screens/data/repositories/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository _noteRepository = NoteRepository();
  
  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasNotes => _notes.isNotEmpty;

  // Fetch all notes
  Future<void> fetchNotes() async {
    _setLoading(true);
    _clearError();
    
    try {
      _notes = await _noteRepository.fetchNotes();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Add a new note
  Future<bool> addNote(String text) async {
    if (text.trim().isEmpty) {
      _setError('Note text cannot be empty');
      return false;
    }

    _clearError();
    
    try {
      await _noteRepository.addNote(text);
      await fetchNotes(); // Refresh the list
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Update an existing note
  Future<bool> updateNote(String id, String text) async {
    if (text.trim().isEmpty) {
      _setError('Note text cannot be empty');
      return false;
    }

    _clearError();
    
    try {
      await _noteRepository.updateNote(id, text);
      await fetchNotes(); // Refresh the list
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Delete a note
  Future<bool> deleteNote(String id) async {
    _clearError();
    
    try {
      await _noteRepository.deleteNote(id);
      await fetchNotes(); // Refresh the list
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
} 