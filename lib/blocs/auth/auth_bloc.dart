import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/auth_service.dart';
import '../../core/storage/auth_storage.dart';
import '../../core/storage/hive_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginWithPhoneEvent extends AuthEvent {
  final String phoneNumber;
  LoginWithPhoneEvent(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  final String verificationId;
  VerifyOtpEvent(this.otp, this.verificationId);
  @override
  List<Object?> get props => [otp, verificationId];
}

class LoginWithGoogleEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String verificationId;
  final String phoneNumber;
  AuthOtpSent(this.verificationId, this.phoneNumber);
  @override
  List<Object?> get props => [verificationId, phoneNumber];
}

class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginWithPhoneEvent>(_onLoginWithPhone);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LogoutEvent>(_onLogout);
  }
  
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final isLoggedIn = await AuthStorage.isLoggedIn();
      if (isLoggedIn) {
        final userId = await AuthStorage.getUserId();
        emit(AuthAuthenticated(userId ?? 'unknown'));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Check auth error: $e');
      emit(AuthUnauthenticated());
    }
  }
  
  Future<void> _onLoginWithPhone(
    LoginWithPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final verificationId = await _authService.sendOtp(event.phoneNumber);
      emit(AuthOtpSent(verificationId, event.phoneNumber));
    } catch (e) {
      print('Login error: $e');
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }
  
  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await _authService.verifyOtp(
        event.verificationId,
        event.otp,
      );
      
      if (user != null) {
        print('User authenticated: ${user.id}');
        emit(AuthAuthenticated(user.id));
      } else {
        emit(AuthError('Invalid OTP'));
        await Future.delayed(const Duration(seconds: 1));
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Verify OTP error: $e');
      emit(AuthError(e.toString()));
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    }
  }
  
  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      final user = await _authService.signInWithGoogle();
      
      if (user != null) {
        emit(AuthAuthenticated(user.id));
      } else {
        emit(AuthError('Google sign-in failed'));
        await Future.delayed(const Duration(seconds: 1));
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Google login error: $e');
      emit(AuthError(e.toString()));
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    }
  }
  
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      
      await _authService.logout();
      await AuthStorage.clearAuthData();
      await HiveService.clearAllData();
      
      emit(AuthUnauthenticated());
    } catch (e) {
      print('Logout error: $e');
      emit(AuthError(e.toString()));
    }
  }
}