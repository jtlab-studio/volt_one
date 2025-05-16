// lib/modules/settings/screens/sensors_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/app_localizations.dart';

final gpsConnectedProvider = StateProvider<bool>((ref) => false);
final heartRateConnectedProvider = StateProvider<bool>((ref) => false);
final strydConnectedProvider = StateProvider<bool>((ref) => false);

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

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations.translate('sensors')),
            Tab(text: localizations.translate('gps')),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBluetoothTab(localizations),
              _buildGpsTab(localizations),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBluetoothTab(AppLocalizations localizations) {
    final isHrmConnected = ref.watch(heartRateConnectedProvider);
    final isStrydConnected = ref.watch(strydConnectedProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Connect All Saved" button at the top
          ElevatedButton.icon(
            icon: const Icon(Icons.bluetooth_connected),
            label: Text(localizations.translate('connect_all_saved')),
            onPressed: () {
              // Connect to all saved devices
              // For demo purposes, toggle the HRM connection
              ref.read(heartRateConnectedProvider.notifier).state = true;
              ref.read(strydConnectedProvider.notifier).state = true;

              // Show a success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('devices_connected')),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 32),

          // Connected devices section
          Text(
            localizations.translate('connected_devices'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          // Connected devices list
          if (isHrmConnected || isStrydConnected) ...[
            if (isHrmConnected)
              _buildConnectedDeviceCard(
                'Polar H10',
                'Heart Rate Monitor',
                '58:7A:62:12:35:42',
                Icons.favorite,
                Colors.red,
                onDisconnect: () {
                  ref.read(heartRateConnectedProvider.notifier).state = false;
                },
              ),
            if (isStrydConnected)
              _buildConnectedDeviceCard(
                'Stryd',
                'Power Meter',
                '00:11:22:33:44:55',
                Icons.flash_on,
                Colors.orange,
                onDisconnect: () {
                  ref.read(strydConnectedProvider.notifier).state = false;
                },
              ),
          ] else ...[
            // No devices connected message
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black26
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bluetooth_disabled,
                      size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    localizations.translate('no_devices_connected'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.translate('tap_scan_to_connect'),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Saved devices section
          Text(
            localizations.translate('saved_devices'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 16),

          // Saved devices list
          _buildSavedDeviceCard(
            'Polar H10',
            'Heart Rate Monitor',
            isHrmConnected,
            Icons.favorite,
            Colors.red,
            onConnect: () {
              ref.read(heartRateConnectedProvider.notifier).state = true;
            },
          ),

          _buildSavedDeviceCard(
            'Stryd',
            'Power Meter',
            isStrydConnected,
            Icons.flash_on,
            Colors.orange,
            onConnect: () {
              ref.read(strydConnectedProvider.notifier).state = true;
            },
          ),

          _buildSavedDeviceCard(
            'Wahoo TICKR',
            'Heart Rate Monitor',
            false,
            Icons.favorite,
            Colors.red,
            onConnect: () {
              // Show connecting dialog
              _showConnectingDialog(context, 'Wahoo TICKR');
            },
          ),

          const SizedBox(height: 32),

          // Scan button
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth_searching),
              label: Text(localizations.translate('scan_for_devices')),
              onPressed: () {
                // Show scanning dialog
                _showScanningDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGpsTab(AppLocalizations localizations) {
    final isGpsConnected = ref.watch(gpsConnectedProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // GPS Status Card
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('gps_status'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isGpsConnected
                            ? Colors.green.withOpacity(0.2)
                            : Colors.orange.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isGpsConnected ? Icons.gps_fixed : Icons.gps_not_fixed,
                        color: isGpsConnected ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isGpsConnected
                                ? localizations.translate('gps_connected')
                                : localizations.translate('gps_connecting'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (isGpsConnected)
                            Text(
                              'Accuracy: ±3m',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            )
                          else
                            Text(
                              localizations.translate('searching_for_signal'),
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isGpsConnected ? Icons.refresh : Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        // Toggle GPS status for demo
                        ref.read(gpsConnectedProvider.notifier).state =
                            !isGpsConnected;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

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
              RadioListTile(
                title: const Text('Power-Saver'),
                subtitle: const Text('≈ 50 mW, ~10 m CEP'),
                value: 'power_saver',
                groupValue: 'balanced',
                onChanged: (value) {
                  // Handle mode change
                },
              ),
              RadioListTile(
                title: const Text('Balanced'),
                subtitle: const Text('≈ 410 mW, ~3 m CEP'),
                value: 'balanced',
                groupValue: 'balanced',
                onChanged: (value) {
                  // Handle mode change
                },
              ),
              RadioListTile(
                title: const Text('High-Accuracy'),
                subtitle: const Text('≈ 2.2 W, ~1-2 m CEP'),
                value: 'high_accuracy',
                groupValue: 'balanced',
                onChanged: (value) {
                  // Handle mode change
                },
              ),
              RadioListTile(
                title: const Text('RTK'),
                subtitle: const Text('> 3 W, < 0.5 m CEP'),
                value: 'rtk',
                groupValue: 'balanced',
                onChanged: (value) {
                  // Handle mode change
                },
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

  Widget _buildConnectedDeviceCard(
    String name,
    String type,
    String address,
    IconData icon,
    Color iconColor, {
    required VoidCallback onDisconnect,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(type),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.link_off),
              label: const Text('Disconnect'),
              onPressed: onDisconnect,
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedDeviceCard(
    String name,
    String type,
    bool isConnected,
    IconData icon,
    Color iconColor, {
    required VoidCallback onConnect,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(type),
                ],
              ),
            ),
            isConnected
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Connected',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : TextButton.icon(
                    icon: const Icon(Icons.bluetooth_connected),
                    label: const Text('Connect'),
                    onPressed: onConnect,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _showScanningDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scanning for Devices'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Looking for nearby Bluetooth devices...'),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );

    // Auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showConnectingDialog(BuildContext context, String deviceName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Connecting to $deviceName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Establishing connection to $deviceName...'),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context).pop();
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Connection Failed'),
              content: Text(
                  'Could not connect to $deviceName. Please ensure the device is powered on and in pairing mode.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
}
