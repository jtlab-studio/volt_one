import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../shared/widgets/theme_toggle_button.dart';

class SensorsScreen extends ConsumerStatefulWidget {
  const SensorsScreen({super.key});

  @override
  ConsumerState<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends ConsumerState<SensorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations.translate('sensors')),
            Tab(text: localizations.translate('gps')),
          ],
        ),
        actions: const [
          // Add the theme toggle button here
          ThemeToggleButton(),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBluetoothTab(localizations),
          _buildGpsTab(localizations),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                // Scan for devices
              },
              child: const Icon(Icons.bluetooth_searching),
            )
          : null,
    );
  }

  Widget _buildBluetoothTab(AppLocalizations localizations) {
    return Stack(
      children: [
        // Empty state
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bluetooth, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                localizations.translate('no_devices_found'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.translate('scan_for_devices'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // "Connect All Saved" button at the top
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.bluetooth_connected),
            label: Text(localizations.translate('connect_all_saved')),
            onPressed: () {
              // Connect to all saved devices
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromRGBO(76, 175, 80, 1.0), // AppColors.success
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGpsTab(AppLocalizations localizations) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Preset Modes Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preset Mode',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Quick select energy vs. accuracy',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const RadioListTile(
                title: Text('Power-Saver'),
                subtitle: Text('≈ 50 mW, ~10 m CEP'),
                value: 'power_saver',
                groupValue: 'balanced',
                onChanged: null,
              ),
              const RadioListTile(
                title: Text('Balanced'),
                subtitle: Text('≈ 410 mW, ~3 m CEP'),
                value: 'balanced',
                groupValue: 'balanced',
                onChanged: null,
              ),
              const RadioListTile(
                title: Text('High-Accuracy'),
                subtitle: Text('≈ 2.2 W, ~1-2 m CEP'),
                value: 'high_accuracy',
                groupValue: 'balanced',
                onChanged: null,
              ),
              const RadioListTile(
                title: Text('RTK'),
                subtitle: Text('> 3 W, < 0.5 m CEP'),
                value: 'rtk',
                groupValue: 'balanced',
                onChanged: null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Custom Features Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Features',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Enable individually',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                title: const Text('Multi-frequency GNSS'),
                subtitle: const Text('Uses both L1 and L5 bands'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Raw GNSS Measurements'),
                subtitle: const Text('For carrier-phase and RTK'),
                value: false,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Sensor Fusion'),
                subtitle: const Text('Combines GPS with IMU sensors'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('RTK Corrections'),
                subtitle: const Text('NTRIP correction streams'),
                value: false,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('External GNSS Receiver'),
                subtitle: const Text('Connect via Bluetooth'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Custom Trade-off Slider Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Trade-off',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Battery vs. Accuracy',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.battery_full),
                    Expanded(
                      child: Slider(
                        value: 0.5,
                        onChanged: (value) {},
                      ),
                    ),
                    const Icon(Icons.gps_fixed),
                  ],
                ),
                const Center(child: Text('50%')),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // GPS Field Test Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GPS Field Test',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Run Test'),
                    ),
                  ],
                ),
                Text(
                  'Validate actual accuracy & battery impact',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
