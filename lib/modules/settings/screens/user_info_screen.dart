import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../settings_module.dart'; // Added import for settingsSectionProvider

class UserInfoScreen extends ConsumerWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final userProfile = ref.watch(userProfileProvider);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // User Avatar and Name Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(20),
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Name field
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

                const SizedBox(height: 24),

                // Upload photo button
                OutlinedButton.icon(
                  icon: const Icon(Icons.photo_camera),
                  label: Text(localizations.translate('upload_photo')),
                  onPressed: () {
                    // Show photo upload options
                    _showPhotoOptions(context);
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Physical Measurements Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('physical_measurements'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                  localizations.translate('personal_information'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Biological Sex Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('biological_sex'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

                const SizedBox(height: 8),

                // Age calculation
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${localizations.translate('age')}: ${DateTime.now().year - userProfile.birthYear}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Additional Information Card - Now links to Training Zones
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('additional_information'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: Text(localizations.translate('training_zones')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to Training Zones setting
                    ref.read(settingsSectionProvider.notifier).state =
                        'training_zones';
                  },
                ),
              ],
            ),
          ),
        ),
      ],
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

  // Gender Selector with icons
  Widget _buildGenderSelector(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Row(
      children: [
        // Male Option
        Expanded(
          child: InkWell(
            onTap: () {
              ref.read(userProfileProvider.notifier).update(
                    (state) => state.copyWith(gender: Gender.male),
                  );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: profile.gender == Gender.male
                    ? Color.fromRGBO(primaryColor.red, primaryColor.green,
                        primaryColor.blue, 0.15)
                    : Colors.grey.withAlpha(5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profile.gender == Gender.male
                      ? primaryColor
                      : Colors.grey.withAlpha(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.male,
                    color: profile.gender == Gender.male
                        ? primaryColor
                        : Colors.grey,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Male',
                    style: TextStyle(
                      color:
                          profile.gender == Gender.male ? primaryColor : null,
                      fontWeight: profile.gender == Gender.male
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Female Option
        Expanded(
          child: InkWell(
            onTap: () {
              ref.read(userProfileProvider.notifier).update(
                    (state) => state.copyWith(gender: Gender.female),
                  );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: profile.gender == Gender.female
                    ? Color.fromRGBO(primaryColor.red, primaryColor.green,
                        primaryColor.blue, 0.15)
                    : Colors.grey.withAlpha(5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profile.gender == Gender.female
                      ? primaryColor
                      : Colors.grey.withAlpha(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.female,
                    color: profile.gender == Gender.female
                        ? primaryColor
                        : Colors.grey,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Female',
                    style: TextStyle(
                      color:
                          profile.gender == Gender.female ? primaryColor : null,
                      fontWeight: profile.gender == Gender.female
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Not Specified Option
        Expanded(
          child: InkWell(
            onTap: () {
              ref.read(userProfileProvider.notifier).update(
                    (state) => state.copyWith(gender: Gender.notSpecified),
                  );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: profile.gender == Gender.notSpecified
                    ? Color.fromRGBO(primaryColor.red, primaryColor.green,
                        primaryColor.blue, 0.15)
                    : Colors.grey.withAlpha(5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profile.gender == Gender.notSpecified
                      ? primaryColor
                      : Colors.grey.withAlpha(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: profile.gender == Gender.notSpecified
                        ? primaryColor
                        : Colors.grey,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Not Specified',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: profile.gender == Gender.notSpecified
                          ? primaryColor
                          : null,
                      fontWeight: profile.gender == Gender.notSpecified
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Open camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Open gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  // Remove photo
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
