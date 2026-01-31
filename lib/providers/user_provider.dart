import 'package:flutter/material.dart';
import 'package:reachnova/models/user.dart';
import 'package:reachnova/repositories/auth_repository.dart';

class UserProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authRepository.getCurrentUser();
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authRepository.updateUser(updatedUser);
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
