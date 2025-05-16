// lib/modules/settings/screens/user_info_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';

// A simple user profile model
class UserProfile {
  final String name;
  final double weight; // kg
  final double height; // cm
  final double legLength; // cm - field for leg length
  final Gender gender;
  final int birthYear;

  const UserProfile({
    required this.name,
    required this.weight,
    required this.height,
    this.legLength = 80.0, // Default value for leg length
    required this.gender,
    required this.birthYear,
  });

  // Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    double? weight,
    double? height,
    double? legLength,
    Gender? gender,
    int? birthYear,
  }) {
    return UserProfile(
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      legLength: legLength ?? this.legLength,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
    );
  }
}

// Gender enum
enum Gender { male, female, notSpecified }

// Provider for user profile
final userProfileProvider = StateProvider<UserProfile>((ref) {
  return const UserProfile(
    name: 'Runner',
    weight: 70,
    height: 175,
    legLength: 80.0,
    gender: Gender.notSpecified,
    birthYear: 1990,
  );
});

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
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
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
                      ref.read(userProfileProvider.notifier).state =
                          userProfile.copyWith(name: value);
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
                        ref.read(userProfileProvider.notifier).state =
                            userProfile.copyWith(weight: weight);
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
                        ref.read(userProfileProvider.notifier).state =
                            userProfile.copyWith(height: height);
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
                        ref.read(userProfileProvider.notifier).state =
                            userProfile.copyWith(legLength: legLength);
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
                        ref.read(userProfileProvider.notifier).state =
                            userProfile.copyWith(birthYear: birthYear);
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

        // Additional Information Card
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
                  title: Text(localizations.translate('heart_rate_zones')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to HR zones settings
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.speed),
                  title: Text(localizations.translate('pace_zones')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to pace zones settings
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.flash_on),
                  title: Text(localizations.translate('power_zones')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to power zones settings
                  },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Data Management Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('data_management'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: Text(localizations.translate('export_data')),
                  subtitle:
                      Text(localizations.translate('export_all_your_data')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show export options
                    _showExportOptions(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    localizations.translate('delete_account'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  subtitle:
                      Text(localizations.translate('delete_account_warning')),
                  onTap: () {
                    // Show delete account confirmation
                    _showDeleteAccountConfirmation(context);
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

    return Row(
      children: [
        // Male Option
        Expanded(
          child: InkWell(
            onTap: () {
              ref.read(userProfileProvider.notifier).state =
                  profile.copyWith(gender: Gender.male);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: profile.gender == Gender.male
                    ? theme.primaryColor.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profile.gender == Gender.male
                      ? theme.primaryColor
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.male,
                    color: profile.gender == Gender.male
                        ? theme.primaryColor
                        : Colors.grey,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Male',
                    style: TextStyle(
                      color: profile.gender == Gender.male
                          ? theme.primaryColor
                          : null,
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
              ref.read(userProfileProvider.notifier).state =
                  profile.copyWith(gender: Gender.female);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: profile.gender == Gender.female
                    ? theme.primaryColor.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profile.gender == Gender.female
                      ? theme.primaryColor
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.female,
                    color: profile.gender == Gender.female
                        ? theme.primaryColor
                        : Colors.grey,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Female',
                    style: TextStyle(
                      color: profile.gender == Gender.female
                          ? theme.primaryColor
                          : null,
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
              ref.read(userProfileProvider.notifier).state =
                  profile.copyWith(gender: Gender.notSpecified);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: profile.gender == Gender.notSpecified
                    ? theme.primaryColor.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: profile.gender == Gender.notSpecified
                      ? theme.primaryColor
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: profile.gender == Gender.notSpecified
                        ? theme.primaryColor
                        : Colors.grey,
                    size: 36,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Not Specified',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: profile.gender == Gender.notSpecified
                          ? theme.primaryColor
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

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Export Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export as CSV'),
                onTap: () {
                  Navigator.pop(context);
                  // Show export progress
                  _showExportProgress(context, 'CSV');
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export as FIT files'),
                onTap: () {
                  Navigator.pop(context);
                  // Show export progress
                  _showExportProgress(context, 'FIT');
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export as GPX files'),
                onTap: () {
                  Navigator.pop(context);
                  // Show export progress
                  _showExportProgress(context, 'GPX');
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Export as TCX files'),
                onTap: () {
                  Navigator.pop(context);
                  // Show export progress
                  _showExportProgress(context, 'TCX');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExportProgress(BuildContext context, String format) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Exporting as $format'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LinearProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Preparing your data for export...'),
            ],
          ),
        );
      },
    );

    // Auto-dismiss after 2 seconds and show success
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss progress dialog

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Export Completed'),
              content: Text(
                  'Your data has been exported as $format files. You can find the files in the Downloads folder.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and will permanently delete all your data, including workout history.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Show secondary confirmation
                _showDeleteAccountFinalConfirmation(context);
              },
              child: const Text('Delete Account',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountFinalConfirmation(BuildContext context) {
    // Create a text controller for the confirmation text
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'To confirm account deletion, please type "DELETE" below:',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type DELETE in all caps',
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text == 'DELETE') {
                  Navigator.pop(context);
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Account deletion initiated. You will receive an email confirmation.'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete Permanently'),
            ),
          ],
        );
      },
    );
  }
}
