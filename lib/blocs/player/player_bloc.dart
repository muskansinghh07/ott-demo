import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/storage/hive_service.dart';
import '../../services/firebase_service.dart' as firebase;

abstract class PlayerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializePlayerEvent extends PlayerEvent {
  final String contentId;
  final String title;
  InitializePlayerEvent(this.contentId, this.title);
  @override
  List<Object?> get props => [contentId, title];
}

class UpdatePlaybackPositionEvent extends PlayerEvent {
  final String contentId;
  final Duration position;
  UpdatePlaybackPositionEvent(this.contentId, this.position);
  @override
  List<Object?> get props => [contentId, position];
}

class DisposePlayerEvent extends PlayerEvent {
  final String contentId;
  final Duration position;
  final Duration totalDuration;
  DisposePlayerEvent(this.contentId, this.position, this.totalDuration);
  @override
  List<Object?> get props => [contentId, position, totalDuration];
}

abstract class PlayerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerReady extends PlayerState {
  final String contentId;
  final Duration? resumePosition;
  PlayerReady(this.contentId, {this.resumePosition});
  @override
  List<Object?> get props => [contentId, resumePosition];
}

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial()) {
    on<InitializePlayerEvent>(_onInitializePlayer);
    on<UpdatePlaybackPositionEvent>(_onUpdatePosition);
    on<DisposePlayerEvent>(_onDisposePlayer);
  }
  
  Future<void> _onInitializePlayer(
    InitializePlayerEvent event,
    Emitter<PlayerState> emit,
  ) async {
    final resumePosition = HiveService.getWatchProgress(event.contentId);
    await firebase.FirebaseService.logVideoPlay(event.contentId, event.title);
    emit(PlayerReady(event.contentId, resumePosition: resumePosition));
  }
  
  Future<void> _onUpdatePosition(
    UpdatePlaybackPositionEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await HiveService.saveWatchProgress(event.contentId, event.position);
  }
  
  Future<void> _onDisposePlayer(
    DisposePlayerEvent event,
    Emitter<PlayerState> emit,
  ) async {
    await HiveService.saveWatchProgress(event.contentId, event.position);
    
    if (event.totalDuration.inSeconds > 0) {
      final percentage = (event.position.inSeconds / event.totalDuration.inSeconds) * 100;
      if (percentage > 90) {
        await firebase.FirebaseService.logVideoComplete(event.contentId, event.position);
      }
    }
    
    emit(PlayerInitial());
  }
}