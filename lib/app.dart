import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'blocs/auth/auth_bloc.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTT Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Debug prints
          print('Auth State Changed: ${state.runtimeType}');
          
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          print('Building UI for state: ${state.runtimeType}');
          
          if (state is AuthAuthenticated) {
            return const HomeScreen();
          } else if (state is AuthUnauthenticated || state is AuthError) {
            return const LoginScreen();
          } else if (state is AuthLoading) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            );
          }
          
          // Initial or unknown state
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}