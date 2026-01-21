import '../models/subscription_model.dart';
import 'firebase_service.dart' as firebase;

class SubscriptionService {
  Future<SubscriptionStatus> checkSubscriptionStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const SubscriptionStatus(
      isActive: false,
      planId: null,
      expiryDate: null,
      autoRenew: false,
    );
  }
  
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      const SubscriptionPlan(
        id: 'monthly',
        name: 'Monthly Plan',
        description: 'Access all content for 30 days',
        price: 9.99,
        currency: 'USD',
        durationDays: 30,
        features: ['HD Streaming', 'Offline Downloads', 'Multi-device'],
        productId: 'com.ott.monthly',
      ),
      const SubscriptionPlan(
        id: 'yearly',
        name: 'Yearly Plan',
        description: 'Access all content for 365 days',
        price: 99.99,
        currency: 'USD',
        durationDays: 365,
        features: ['HD Streaming', 'Offline Downloads', 'Multi-device', 'Save 17%'],
        productId: 'com.ott.yearly',
      ),
    ];
  }
  
  Future<bool> purchaseSubscription(String planId) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      await firebase.FirebaseService.logSubscription(
        planId,
        planId == 'monthly' ? 9.99 : 99.99,
      );
      
      return true;
    } catch (e) {
      throw Exception('Purchase failed: $e');
    }
  }
}