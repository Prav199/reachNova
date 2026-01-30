import 'package:reachnova/models/user.dart';
import 'package:reachnova/services/mock_service.dart';

class AuthRepository {
  final MockService _mockService;

  AuthRepository({MockService? mockService})
    : _mockService = mockService ?? MockService();

  Future<User> getCurrentUser() async {
    return await _mockService.getCurrentUser();
  }

  Future<User> updateUser(User user) async {
    return await _mockService.updateUser(user);
  }

  // Placeholder for login implementation
  Future<User> login(String email, String otp) async {
    // Simulating login validation
    if (otp == '123456') {
      return await _mockService.getCurrentUser();
    } else {
      throw Exception('Invalid OTP');
    }
  }
}
