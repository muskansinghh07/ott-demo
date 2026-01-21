import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/subscription_model.dart';
import '../../services/subscription_service.dart';

// Events
abstract class SubscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckSubscriptionEvent extends SubscriptionEvent {}

class LoadSubscriptionPlansEvent extends SubscriptionEvent {}

class PurchaseSubscriptionEvent extends SubscriptionEvent {
  final String planId;
  PurchaseSubscriptionEvent(this.planId);
  @override
  List<Object?> get props => [planId];
}

// States
abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionStatusState extends SubscriptionState {
  final bool isActive;
  final SubscriptionStatus? subscription;
  
  SubscriptionStatusState({required this.isActive, this.subscription});
  
  @override
  List<Object?> get props => [isActive, subscription];
}

class SubscriptionPlansLoaded extends SubscriptionState {
  final List<SubscriptionPlan> plans;
  SubscriptionPlansLoaded(this.plans);
  @override
  List<Object?> get props => [plans];
}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<CheckSubscriptionEvent>(_onCheckSubscription);
    on<LoadSubscriptionPlansEvent>(_onLoadPlans);
    on<PurchaseSubscriptionEvent>(_onPurchaseSubscription);
  }
  
  Future<void> _onCheckSubscription(
    CheckSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final status = await _subscriptionService.checkSubscriptionStatus();
      emit(SubscriptionStatusState(isActive: status.isActive, subscription: status));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
  
  Future<void> _onLoadPlans(
    LoadSubscriptionPlansEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      final plans = await _subscriptionService.getSubscriptionPlans();
      emit(SubscriptionPlansLoaded(plans));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
  
  Future<void> _onPurchaseSubscription(
    PurchaseSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionLoading());
    try {
      await _subscriptionService.purchaseSubscription(event.planId);
      add(CheckSubscriptionEvent());
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}