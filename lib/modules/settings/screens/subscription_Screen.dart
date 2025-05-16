// lib/modules/settings/screens/subscription_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

// Provider to track subscription status (mock for demo)
final subscriptionActiveProvider = StateProvider<bool>((ref) => false);
final subscriptionTierProvider = StateProvider<String>((ref) => 'free');

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final isSubscribed = ref.watch(subscriptionActiveProvider);
    final currentTier = ref.watch(subscriptionTierProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Current subscription status card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('current_plan'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Current subscription info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSubscribed
                              ? Color.fromRGBO(
                                  AppColors.success.red,
                                  AppColors.success.green,
                                  AppColors.success.blue,
                                  0.2)
                              : Color.fromRGBO(
                                  AppColors.secondary.red,
                                  AppColors.secondary.green,
                                  AppColors.secondary.blue,
                                  0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSubscribed
                              ? Icons.verified
                              : Icons.verified_outlined,
                          color: isSubscribed
                              ? AppColors.success
                              : AppColors.secondary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSubscribed ? 'Volt Premium' : 'Volt Free',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              isSubscribed
                                  ? localizations
                                          .translate('premium_active_until') +
                                      ' May 16, 2026'
                                  : localizations
                                      .translate('free_plan_description'),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Only show manage button if subscribed
                  if (isSubscribed) ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Open subscription management
                      },
                      child:
                          Text(localizations.translate('manage_subscription')),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Subscription tiers
          if (!isSubscribed) ...[
            Text(
              localizations.translate('upgrade_to_premium'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Premium tier card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Volt Premium',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Feature list
                    _buildFeatureItem(context, 'Advanced analytics', true),
                    _buildFeatureItem(
                        context, 'Unlimited workout history', true),
                    _buildFeatureItem(
                        context, 'Training plan generation', true),
                    _buildFeatureItem(context, 'Performance forecasting', true),
                    _buildFeatureItem(
                        context, 'Export data in all formats', true),

                    const SizedBox(height: 16),

                    // Price and subscribe button
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                '\$9.99/month',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'or \$99.99/year',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Show upgrade dialog
                            _showUpgradeDialog(context, ref);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(localizations.translate('subscribe')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Free tier card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.watch_later_outlined, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'Free',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Feature list
                    _buildFeatureItem(context, 'Basic tracking', true),
                    _buildFeatureItem(context, 'Limited workout history', true),
                    _buildFeatureItem(context, 'Basic stats', true),
                    _buildFeatureItem(context, 'Advanced analytics', false),
                    _buildFeatureItem(context, 'Training plans', false),

                    const SizedBox(height: 16),
                    const Text(
                      'Free',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // For subscribed users
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('subscription_benefits'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 16),

                    // Unlocked premium features
                    _buildFeatureItem(context, 'Advanced analytics', true),
                    _buildFeatureItem(
                        context, 'Unlimited workout history', true),
                    _buildFeatureItem(
                        context, 'Training plan generation', true),
                    _buildFeatureItem(context, 'Performance forecasting', true),
                    _buildFeatureItem(
                        context, 'Export data in all formats', true),

                    const SizedBox(height: 16),

                    // Cancel button
                    OutlinedButton(
                      onPressed: () {
                        // Show cancel confirmation
                        _showCancelDialog(context, ref);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child:
                          Text(localizations.translate('cancel_subscription')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, String feature, bool included) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_circle : Icons.remove_circle_outline,
            color: included ? AppColors.success : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                color: included ? null : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Upgrade to Volt Premium'),
          content: const Text(
              'This is a demo. In a real app, this would connect to a payment processor. Would you like to simulate upgrading to Premium?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Simulate subscribing
                ref.read(subscriptionActiveProvider.notifier).state = true;
                ref.read(subscriptionTierProvider.notifier).state = 'premium';

                Navigator.of(context).pop();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully upgraded to Premium!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Upgrade (Demo)'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Subscription?'),
          content: const Text(
              'Are you sure you want to cancel your Premium subscription? You will lose access to premium features when your current billing period ends.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Keep Subscription'),
            ),
            TextButton(
              onPressed: () {
                // Simulate cancelling (but not immediately removing access)
                ref.read(subscriptionActiveProvider.notifier).state = false;
                ref.read(subscriptionTierProvider.notifier).state = 'free';

                Navigator.of(context).pop();

                // Show cancellation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Subscription cancelled. Access will end at the end of your billing period.'),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Cancel Subscription'),
            ),
          ],
        );
      },
    );
  }
}
