import 'package:equatable/equatable.dart';

class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationDays;
  final List<String> features;
  final String productId; // For in-app purchase
  
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.durationDays,
    required this.features,
    required this.productId,
  });
  
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      durationDays: json['duration_days'] ?? 30,
      features: List<String>.from(json['features'] ?? []),
      productId: json['product_id'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'duration_days': durationDays,
      'features': features,
      'product_id': productId,
    };
  }
  
  @override
  List<Object?> get props => [id, name, description, price, currency, durationDays, features, productId];
}

class SubscriptionStatus extends Equatable {
  final bool isActive;
  final String? planId;
  final DateTime? expiryDate;
  final bool autoRenew;
  
  const SubscriptionStatus({
    required this.isActive,
    this.planId,
    this.expiryDate,
    this.autoRenew = false,
  });
  
  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      isActive: json['is_active'] ?? false,
      planId: json['plan_id'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      autoRenew: json['auto_renew'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'plan_id': planId,
      'expiry_date': expiryDate?.toIso8601String(),
      'auto_renew': autoRenew,
    };
  }
  
  @override
  List<Object?> get props => [isActive, planId, expiryDate, autoRenew];
}