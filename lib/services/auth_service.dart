import '../core/storage/auth_storage.dart';
import '../models/user_model.dart';
import 'firebase_service.dart' as firebase;

class AuthService {
  Future<String> sendOtp(String phoneNumber) async {
    try {
      final verificationId = 'mock_verification_${DateTime.now().millisecondsSinceEpoch}';
      await Future.delayed(const Duration(seconds: 1));
      return verificationId;
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }
  
  Future<UserModel?> verifyOtp(String verificationId, String otp) async {
    try {
      if (otp.length != 6) {
        throw Exception('Invalid OTP');
      }
      
      await Future.delayed(const Duration(seconds: 1));
      
      final mockUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phone: '+1234567890',
        displayName: 'Demo User',
        hasActiveSubscription: false,
      );
      
      await AuthStorage.saveAuthTokens(
        accessToken: 'mock_access_token_${mockUser.id}',
        refreshToken: 'mock_refresh_token_${mockUser.id}',
      );
      
      await AuthStorage.saveUserData(
        userId: mockUser.id,
        phone: mockUser.phone,
      );
      
      await firebase.FirebaseService.logLogin('phone');
      await firebase.FirebaseService.setUserId(mockUser.id);
      
      return mockUser;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }
  
  Future<UserModel?> signInWithGoogle() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final mockUser = UserModel(
        id: 'user_google_${DateTime.now().millisecondsSinceEpoch}',
        email: 'demo@example.com',
        displayName: 'Google Demo User',
        photoUrl: 'https://via.placeholder.com/150',
        hasActiveSubscription: false,
      );
      
      await AuthStorage.saveAuthTokens(
        accessToken: 'mock_google_token_${mockUser.id}',
        refreshToken: 'mock_google_refresh_${mockUser.id}',
      );
      
      await AuthStorage.saveUserData(
        userId: mockUser.id,
        email: mockUser.email,
      );
      
      await firebase.FirebaseService.logLogin('google');
      await firebase.FirebaseService.setUserId(mockUser.id);
      
      return mockUser;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
  
  Future<void> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}