import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import 'models/user_profile.dart';
import 'providers/user_profile_provider.dart';
import 'screens/training_zones_screen.dart';
import 'screens/app_settings_screen.dart';

// Provider to track the current profile section
final profileSectionProvider = StateProvider<String>((ref) => 'user_info');

// User Info Screen implementation with actual content - focused only on user information
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
          // User avatar and basic info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Theme.of(context).primaryColor.withAlpha(25),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User name
                  Text(
                    userProfile.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Basic stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                          context,
                          Icons.monitor_weight,
                          '${userProfile.weight} kg',
                          localizations.translate('weight')),
                      _buildStatCard(
                          context,
                          Icons.height,
                          '${userProfile.height} cm',
                          localizations.translate('height')),
                      _buildStatCard(
                          context,
                          Icons.calendar_today,
                          '${DateTime.now().year - userProfile.birthYear}',
                          localizations.translate('age')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Detailed user information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('user_info'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // User details list
                  _buildInfoField(
                    context,
                    localizations.translate('name'),
                    userProfile.name,
                    Icons.person,
                    () => _editName(context, ref, userProfile),
                  ),
                  const Divider(),

                  _buildInfoField(
                    context,
                    localizations.translate('weight'),
                    '${userProfile.weight} kg',
                    Icons.monitor_weight,
                    () => _editWeight(context, ref, userProfile),
                  ),
                  const Divider(),

                  _buildInfoField(
                    context,
                    localizations.translate('height'),
                    '${userProfile.height} cm',
                    Icons.height,
                    () => _editHeight(context, ref, userProfile),
                  ),
                  const Divider(),

                  // Add leg length field
                  _buildInfoField(
                    context,
                    localizations.translate('leg_length'),
                    '${userProfile.legLength} cm',
                    Icons.accessibility_new,
                    () => _editLegLength(context, ref, userProfile),
                    'Distance from hip joint (greater trochanter) to floor',
                  ),
                  const Divider(),

                  _buildInfoField(
                    context,
                    localizations.translate('gender'),
                    _getGenderText(userProfile.gender, localizations),
                    Icons.people,
                    () => _editGender(context, ref, userProfile),
                  ),
                  const Divider(),

                  _buildInfoField(
                    context,
                    localizations.translate('birth_year'),
                    userProfile.birthYear.toString(),
                    Icons.cake,
                    () => _editBirthYear(context, ref, userProfile),
                  ),
                  const Divider(),

                  // LTHR field (relevant to user's physiological data)
                  _buildInfoField(
                    context,
                    localizations.translate('lthr'),
                    '${userProfile.lthr} bpm',
                    Icons.favorite,
                    () => _editLthr(context, ref, userProfile),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build stat card
  Widget _buildStatCard(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Helper method to build info field
  Widget _buildInfoField(BuildContext context, String label, String value,
      IconData icon, VoidCallback onTap,
      [String? description]) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.edit, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Convert Gender enum to readable text
  String _getGenderText(Gender gender, AppLocalizations localizations) {
    switch (gender) {
      case Gender.male:
        return localizations.translate('male');
      case Gender.female:
        return localizations.translate('female');
      case Gender.notSpecified:
        return localizations.translate('not_specified');
    }
  }

  // Edit name dialog
  void _editName(BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller = TextEditingController(text: profile.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('name')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('name'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(name: controller.text),
                    );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Edit weight dialog
  void _editWeight(BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller = TextEditingController(text: profile.weight.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('weight')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('weight'),
            suffixText: 'kg',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(controller.text);
              if (weight != null && weight > 0) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(weight: weight),
                    );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Edit height dialog
  void _editHeight(BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller = TextEditingController(text: profile.height.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('height')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('height'),
            suffixText: 'cm',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              final height = double.tryParse(controller.text);
              if (height != null && height > 0) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(height: height),
                    );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Edit leg length dialog
  void _editLegLength(
      BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller =
        TextEditingController(text: profile.legLength.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('leg_length')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distance from hip joint (greater trochanter) to floor',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate('leg_length'),
                suffixText: 'cm',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              final legLength = double.tryParse(controller.text);
              if (legLength != null && legLength > 0) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(legLength: legLength),
                    );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Edit gender dialog
  void _editGender(BuildContext context, WidgetRef ref, UserProfile profile) {
    Gender selectedGender = profile.gender;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('gender')),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<Gender>(
                  title: Text(AppLocalizations.of(context).translate('male')),
                  value: Gender.male,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                RadioListTile<Gender>(
                  title: Text(AppLocalizations.of(context).translate('female')),
                  value: Gender.female,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
                RadioListTile<Gender>(
                  title: Text(
                      AppLocalizations.of(context).translate('not_specified')),
                  value: Gender.notSpecified,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value!);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              ref.read(userProfileProvider.notifier).update(
                    (state) => state.copyWith(gender: selectedGender),
                  );
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Edit birth year dialog
  void _editBirthYear(
      BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller =
        TextEditingController(text: profile.birthYear.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('birth_year')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('birth_year'),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              final year = int.tryParse(controller.text);
              if (year != null && year > 1900 && year < DateTime.now().year) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(birthYear: year),
                    );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  // Edit LTHR dialog
  void _editLthr(BuildContext context, WidgetRef ref, UserProfile profile) {
    final controller = TextEditingController(text: profile.lthr.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('lthr')),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('lthr'),
            suffixText: 'bpm',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              final lthr = int.tryParse(controller.text);
              if (lthr != null && lthr > 0) {
                ref.read(userProfileProvider.notifier).update(
                      (state) => state.copyWith(lthr: lthr),
                    );
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSection = ref.watch(profileSectionProvider);
    final localizations = AppLocalizations.of(context);

    // Map section IDs to screen widgets
    // Use the actual screens
    final sectionWidgets = {
      'user_info': const UserInfoScreen(),
      'training_zones': const TrainingZonesScreen(),
      'app_settings': const AppSettingsScreen(),
    };

    // Get the current section's screen - default to user_info if not found
    final currentScreen =
        sectionWidgets[selectedSection] ?? const UserInfoScreen();

    return Column(
      children: [
        // Section selector tabs
        _buildProfileSectionTabs(context, ref, selectedSection, localizations),

        // Current section content
        Expanded(child: currentScreen),
      ],
    );
  }

  Widget _buildProfileSectionTabs(BuildContext context, WidgetRef ref,
      String currentSection, AppLocalizations localizations) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSectionTab(
              context,
              ref,
              'user_info',
              localizations.translate('user_info'),
              Icons.person,
              currentSection == 'user_info',
            ),
            _buildSectionTab(
              context,
              ref,
              'training_zones',
              localizations.translate('training_zones'),
              Icons.favorite,
              currentSection == 'training_zones',
            ),
            _buildSectionTab(
              context,
              ref,
              'app_settings',
              localizations.translate('app_settings'),
              Icons.settings,
              currentSection == 'app_settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTab(BuildContext context, WidgetRef ref, String sectionId,
      String label, IconData icon, bool isSelected) {
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return InkWell(
      onTap: () {
        ref.read(profileSectionProvider.notifier).state = sectionId;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
