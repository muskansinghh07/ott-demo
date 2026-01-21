import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/content_model.dart';
import '../../services/content_service.dart';

// Events
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHomeContentEvent extends HomeEvent {}

class RefreshHomeContentEvent extends HomeEvent {}

// States
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ContentModel> featuredContent;
  final Map<String, List<ContentModel>> categorizedContent;
  
  HomeLoaded({
    required this.featuredContent,
    required this.categorizedContent,
  });
  
  @override
  List<Object?> get props => [featuredContent, categorizedContent];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContentService _contentService = ContentService();
  
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeContentEvent>(_onLoadHomeContent);
    on<RefreshHomeContentEvent>(_onRefreshHomeContent);
  }
  
  Future<void> _onLoadHomeContent(
    LoadHomeContentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    try {
      final homeData = await _contentService.getHomeContent();
      emit(HomeLoaded(
        featuredContent: homeData['featured'] ?? [],
        categorizedContent: homeData['categories'] ?? {},
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
  
  Future<void> _onRefreshHomeContent(
    RefreshHomeContentEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final homeData = await _contentService.getHomeContent(forceRefresh: true);
      emit(HomeLoaded(
        featuredContent: homeData['featured'] ?? [],
        categorizedContent: homeData['categories'] ?? {},
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}