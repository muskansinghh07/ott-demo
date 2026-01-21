import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/content_model.dart';
import '../../services/content_service.dart';

// Events
abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;
  SearchQueryChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class LoadMoreSearchResultsEvent extends SearchEvent {}

// States
abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ContentModel> results;
  final bool hasMore;
  final int page;
  
  SearchLoaded({required this.results, this.hasMore = true, this.page = 1});
  
  @override
  List<Object?> get props => [results, hasMore, page];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ContentService _contentService = ContentService();
  String _lastQuery = '';
  Timer? _debounceTimer;
  
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<LoadMoreSearchResultsEvent>(_onLoadMoreResults);
  }
  
  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    
    // Debounce for 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      emit(SearchLoading());
      _lastQuery = event.query;
      
      try {
        final results = await _contentService.searchContent(event.query, page: 1);
        emit(SearchLoaded(results: results, hasMore: results.length >= 20));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
  
  Future<void> _onLoadMoreResults(
    LoadMoreSearchResultsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      if (!currentState.hasMore) return;
      
      try {
        final newResults = await _contentService.searchContent(
          _lastQuery,
          page: currentState.page + 1,
        );
        
        emit(SearchLoaded(
          results: [...currentState.results, ...newResults],
          hasMore: newResults.length >= 20,
          page: currentState.page + 1,
        ));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    }
  }
  
  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}