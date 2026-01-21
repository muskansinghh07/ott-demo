import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String? displayName;
  final String? photoUrl;
  final bool hasActiveSubscription;
  final String? subscriptionPlan;
  final DateTime? subscriptionExpiryDate;
  
  const UserModel({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
    this.photoUrl,
    this.hasActiveSubscription = false,
    this.subscriptionPlan,
    this.subscriptionExpiryDate,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'],
      phone: json['phone'],
      displayName: json['display_name'],
      photoUrl: json['photo_url'],
      hasActiveSubscription: json['has_active_subscription'] ?? false,
      subscriptionPlan: json['subscription_plan'],
      subscriptionExpiryDate: json['subscription_expiry_date'] != null
          ? DateTime.parse(json['subscription_expiry_date'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'display_name': displayName,
      'photo_url': photoUrl,
      'has_active_subscription': hasActiveSubscription,
      'subscription_plan': subscriptionPlan,
      'subscription_expiry_date': subscriptionExpiryDate?.toIso8601String(),
    };
  }
  
  @override
  List<Object?> get props => [
    id, email, phone, displayName, photoUrl,
    hasActiveSubscription, subscriptionPlan, subscriptionExpiryDate
  ];
}