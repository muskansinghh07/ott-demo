import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/player/player_bloc.dart';
import 'blocs/subscription/subscription_bloc.dart';

void main() {
  runApp(const OTTApp());
}

class OTTApp extends StatelessWidget {
  const OTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => HomeBloc()..add(LoadHomeContentEvent())),
        BlocProvider(create: (_) => SearchBloc()),
        BlocProvider(create: (_) => PlayerBloc()),
        BlocProvider(create: (_) => SubscriptionBloc()..add(CheckSubscriptionEvent())),
      ],
      child: const App(),
    );
  }
}