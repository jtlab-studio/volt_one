// lib/modules/profile/screens/theme_preview_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/color_palettes.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/app_theme_extensions.dart';

class ThemePreviewScreen extends ConsumerWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final palette = ref.watch(colorPaletteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Preview: ${palette.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color Palette Section
            _buildSectionTitle(context, 'Color Palette'),
            _buildColorSwatch(context, 'Primary', palette.primaryColor),
            _buildColorSwatch(context, 'Secondary', palette.secondaryColor),
            _buildColorSwatch(context, 'Accent', palette.accentColor),
            _buildColorSwatch(context, 'Error', palette.errorColor),
            _buildColorSwatch(context, 'Success', palette.successColor),
            _buildColorSwatch(context, 'Warning', palette.warningColor),

            const SizedBox(height: 24),

            // UI Elements Section
            _buildSectionTitle(context, 'UI Elements'),

            // Typography
            _buildSubsectionTitle(context, 'Typography'),
            Text('Display Large', style: context.textTheme.displayLarge),
            Text('Display Medium', style: context.textTheme.displayMedium),
            Text('Display Small', style: context.textTheme.displaySmall),
            Text('Headline Large', style: context.textTheme.headlineLarge),
            Text('Headline Medium', style: context.textTheme.headlineMedium),
            Text('Headline Small', style: context.textTheme.headlineSmall),
            Text('Title Large', style: context.textTheme.titleLarge),
            Text('Title Medium', style: context.textTheme.titleMedium),
            Text('Title Small', style: context.textTheme.titleSmall),
            Text('Body Large', style: context.textTheme.bodyLarge),
            Text('Body Medium', style: context.textTheme.bodyMedium),
            Text('Body Small', style: context.textTheme.bodySmall),
            Text('Label Large', style: context.textTheme.labelLarge),

            const SizedBox(height: 16),

            // Buttons
            _buildSubsectionTitle(context, 'Buttons'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Filled'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Cards
            _buildSubsectionTitle(context, 'Cards'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Card Title', style: context.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'This is a card with content that demonstrates how cards look with the selected theme.',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {},
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Form Elements
            _buildSubsectionTitle(context, 'Form Elements'),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Text Field',
                hintText: 'Enter text',
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Disabled Field',
                hintText: 'Cannot be edited',
              ),
              enabled: false,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Dropdown',
              ),
              items: ['Option 1', 'Option 2', 'Option 3']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Checkbox Item'),
              value: true,
              onChanged: (_) {},
            ),
            SwitchListTile(
              title: const Text('Switch Item'),
              value: true,
              onChanged: (_) {},
            ),
            RadioListTile(
              title: const Text('Radio Item'),
              value: 'selected',
              groupValue: 'selected',
              onChanged: (_) {},
            ),

            const SizedBox(height: 24),

            // Theme Consistency Demo
            _buildSectionTitle(context, 'Navigation Example'),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: context.bottomNavBarColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: context.unselectedTabColor),
                      Text('Home',
                          style: TextStyle(
                              color: context.unselectedTabColor, fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_run,
                          color: context.selectedTabColor),
                      Text('Activity',
                          style: TextStyle(
                              color: context.selectedTabColor, fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map, color: context.unselectedTabColor),
                      Text('Routes',
                          style: TextStyle(
                              color: context.unselectedTabColor, fontSize: 12)),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: context.unselectedTabColor),
                      Text('Profile',
                          style: TextStyle(
                              color: context.unselectedTabColor, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSubsectionTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildColorSwatch(BuildContext context, String name, Color color) {
    final textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            color: color,
            child: Center(
              child: Text(
                '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(name, style: context.textTheme.titleMedium),
        ],
      ),
    );
  }
}
