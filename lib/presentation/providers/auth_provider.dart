import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authRepository.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authRepository.signUp(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _authRepository.signIn(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
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