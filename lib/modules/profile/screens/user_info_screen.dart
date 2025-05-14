// lib/modules/profile/screens/user_info_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';

class UserInfoScreen extends ConsumerWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('user_info'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  _buildTextField(
                    context: context,
                    label: localizations.translate('name'),
                    value: userProfile.name,
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        ref.read(userProfileProvider.notifier).update(
                              (state) => state.copyWith(name: value),
                            );
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Weight Field
                  _buildTextField(
                    context: context,
                    label: localizations.translate('weight'),
                    value: userProfile.weight.toString(),
                    suffix: 'kg',
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        final weight = double.tryParse(value);
                        if (weight != null) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) => state.copyWith(weight: weight),
                              );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Height Field
                  _buildTextField(
                    context: context,
                    label: localizations.translate('height'),
                    value: userProfile.height.toString(),
                    suffix: 'cm',
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        final height = double.tryParse(value);
                        if (height != null) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) => state.copyWith(height: height),
                              );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Leg Length Field
                  _buildTextField(
                    context: context,
                    label: localizations.translate('leg_length'),
                    value: userProfile.legLength.toString(),
                    suffix: 'cm',
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        final legLength = double.tryParse(value);
                        if (legLength != null) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) => state.copyWith(legLength: legLength),
                              );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Personal Information Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Biological Sex Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Biological Sex'),
                      const SizedBox(height: 8),
                      _buildGenderSelector(context, ref, userProfile),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Birth Year Field
                  _buildTextField(
                    context: context,
                    label: localizations.translate('birth_year'),
                    value: userProfile.birthYear.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty) {
                        final birthYear = int.tryParse(value);
                        if (birthYear != null) {
                          ref.read(userProfileProvider.notifier).update(
                                (state) => state.copyWith(birthYear: birthYear),
                              );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String value,
    String? suffix,
    TextInputType? keyboardType,
    required Function(String?) onSaved,
  }) {
    final controller = TextEditingController(text: value);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixText: suffix,
              border: const OutlineInputBorder(),
            ),
            keyboardType: keyboardType,
            onSubmitted: onSaved,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => onSaved(controller.text),
        ),
      ],
    );
  }

  // Simplified Gender Selector with just male and female icons
  Widget _buildGenderSelector(
      BuildContext context, WidgetRef ref, UserProfile profile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Male Option
        IconButton(
          icon: Icon(
            Icons.male,
            color: profile.gender == Gender.male
                ? Theme.of(context).primaryColor
                : Colors.grey,
            size: 32,
          ),
          onPressed: () {
            ref.read(userProfileProvider.notifier).update(
                  (state) => state.copyWith(gender: Gender.male),
                );
          },
        ),

        // Female Option
        IconButton(
          icon: Icon(
            Icons.female,
            color: profile.gender == Gender.female
                ? Theme.of(context).primaryColor
                : Colors.grey,
            size: 32,
          ),
          onPressed: () {
            ref.read(userProfileProvider.notifier).update(
                  (state) => state.copyWith(gender: Gender.female),
                );
          },
        ),
      ],
    );
  }
}
