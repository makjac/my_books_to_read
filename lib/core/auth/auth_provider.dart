import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_books_to_read/core/utils/logger.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _init();
  }

  final FirebaseAuth _auth;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  void _init() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
            Logger.showLog('User signed in: $value', 'AuthProvider');
          });
      return true;
    } on FirebaseAuthException catch (e) {
      Logger.showLog('Error signing in: $e', 'AuthProvider');
      _errorMessage = _handleAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
            Logger.showLog('User signed up: $value', 'AuthProvider');
          });
      return true;
    } on FirebaseAuthException catch (e) {
      Logger.showLog('Error signing up: $e', 'AuthProvider');
      _errorMessage = _handleAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut().then((_) {
        Logger.showLog('User signed out', 'AuthProvider');
      });
      return true;
    } catch (e) {
      Logger.showLog('Error signing out: $e', 'AuthProvider');
      _errorMessage = 'Error signing out';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkUser() async {
    _user = _auth.currentUser;
    notifyListeners();
    return _user != null;
  }

  String _handleAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return 'Not found user with this email';
      case 'invalid-credential':
        return 'Invalid credential';
      case 'wrong-password':
        return 'Nieprawidłowe hasło';
      case 'email-already-in-use':
        return 'Email is already in use';
      case 'weak-password':
        return 'Provided password is too weak';
      case 'invalid-email':
        return 'Provided email is invalid';
      case 'operation-not-allowed':
        return 'Operation is not allowed';
      case 'too-many-requests':
        return 'Too many requests. Try again later';
      default:
        return 'Something went wrong';
    }
  }
}
