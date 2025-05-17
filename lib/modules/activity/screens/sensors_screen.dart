import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../models/ble_device.dart';
import '../../../providers/ble_providers.dart' as ble;
import '../../../providers/gps_providers.dart' as gps;
import '../../../services/gps_service.dart';

class SensorsScreen extends ConsumerStatefulWidget {
  const SensorsScreen({super.key});

  @override
  ConsumerState<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends ConsumerState<SensorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitialized = false;
  bool _showConnectedOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize BLE and GPS services
    _initializeServices();
  }

  void _initializeServices() async {
    // Access BLE and GPS controller providers from Riverpod
    final bleController = ref.read(ble.bleControllerProvider);
    final gpsController = ref.read(gps.gpsControllerProvider);

    await bleController.initialize();
    await gpsController.initialize();

    setState(() {
      _isInitialized = true;
    });
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
              onPressed: _isInitialized ? () => _startOrStopScanning() : null,
              child: _buildScanButtonIcon(),
            )
          : null,
    );
  }

  Widget _buildScanButtonIcon() {
    final scanningState = ref.watch(ble.scanningStateProvider);

    return scanningState.when(
      data: (isScanning) => isScanning
          ? const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.bluetooth_searching),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            )
          : const Icon(Icons.bluetooth_searching),
      loading: () => const Icon(Icons.bluetooth_searching),
      error: (_, __) => const Icon(Icons.bluetooth_disabled),
    );
  }

  void _startOrStopScanning() {
    final bleController = ref.read(ble.bleControllerProvider);
    final scanningState = ref.watch(ble.scanningStateProvider);

    scanningState.whenData((isScanning) {
      if (isScanning) {
        bleController.stopScan();
      } else {
        bleController.startScan();
      }
    });
  }

  Widget _buildBluetoothTab(AppLocalizations localizations) {
    final discoveredDevicesAsync = ref.watch(ble.discoveredDevicesProvider);
    final savedDevices = ref.watch(ble.savedDevicesProvider);

    return Stack(
      children: [
        // Devices list or empty state
        Column(
          children: [
            if (savedDevices.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter toggle
                    Row(
                      children: [
                        Switch(
                          value: _showConnectedOnly,
                          onChanged: (value) {
                            setState(() {
                              _showConnectedOnly = value;
                            });
                          },
                        ),
                        Text(localizations.translate('connected_devices')),
                      ],
                    ),

                    // Connect all button
                    TextButton.icon(
                      icon: const Icon(Icons.bluetooth_connected),
                      label: Text(localizations.translate('connect_all_saved')),
                      onPressed: () {
                        final bleController = ref.read(ble.bleControllerProvider);
                        bleController.connectToAllSavedDevices();
                      },
                    ),
                  ],
                ),
              ),

            // Device list content
            Expanded(
              child: discoveredDevicesAsync.when(
                data: (devices) {
                  if (devices.isEmpty) {
                    return _buildEmptyDevicesState(localizations);
                  } else {
                    // Filter devices if needed
                    final filteredDevices = _showConnectedOnly
                        ? devices.where((d) => d.connected).toList()
                        : devices;

                    if (filteredDevices.isEmpty) {
                      return Center(
                        child:
                            Text(localizations.translate('no_devices_found')),
                      );
                    }

                    return _buildDevicesList(filteredDevices, localizations);
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyDevicesState(AppLocalizations localizations) {
    final scanningState = ref.watch(ble.scanningStateProvider);
    final isScanning = scanningState.valueOrNull ?? false;

    return Center(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              localizations.translate('scan_for_devices'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 32),
          if (!isScanning)
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth_searching),
              label: Text(localizations.translate('start_scan')),
              onPressed: () {
                final bleController = ref.read(ble.bleControllerProvider);
                bleController.startScan();
              },
            )
          else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildDevicesList(
      List<BleDevice> devices, AppLocalizations localizations) {
    // Sort devices: Connected first, then saved, then by RSSI
    final sortedDevices = [...devices];
    sortedDevices.sort((a, b) {
      // Connected devices first
      if (a.connected && !b.connected) return -1;
      if (!a.connected && b.connected) return 1;

      // Then saved devices
      if (a.isSaved && !b.isSaved) return -1;
      if (!a.isSaved && b.isSaved) return 1;

      // Then by RSSI (higher signal strength first)
      return b.rssi.compareTo(a.rssi);
    });

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Space for the FAB
      itemCount: sortedDevices.length,
      itemBuilder: (context, index) {
        final device = sortedDevices[index];
        return _buildDeviceListItem(device, localizations);
      },
    );
  }

  Widget _buildDeviceListItem(
      BleDevice device, AppLocalizations localizations) {
    final bleController = ref.read(ble.bleControllerProvider);
    final theme = Theme.of(context);

    // Get icon based on device type
    IconData typeIcon;
    switch (device.type) {
      case BleDevice.typeHeartRate:
        typeIcon = Icons.favorite;
        break;
      case BleDevice.typePower:
        typeIcon = Icons.flash_on;
        break;
      case BleDevice.typeCadence:
        typeIcon = Icons.speed;
        break;
      case BleDevice.typeCombined:
        typeIcon = Icons.sensors;
        break;
      default:
        typeIcon = Icons.bluetooth;
    }

    // Signal strength icon - using standard Material icons
    Widget signalIcon;
    if (device.rssi > -60) {
      signalIcon = Icon(Icons.signal_cellular_4_bar, size: 16);
    } else if (device.rssi > -70) {
      signalIcon = Icon(Icons.signal_cellular_alt_2_bar, size: 16);
    } else if (device.rssi > -80) {
      signalIcon = Icon(Icons.signal_cellular_alt_1_bar, size: 16);
    } else {
      signalIcon = Icon(Icons.signal_cellular_0_bar, size: 16);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(
          typeIcon,
          color: device.connected ? theme.primaryColor : theme.disabledColor,
          size: 28,
        ),
        title: Text(
          device.name.isNotEmpty ? device.name : 'Unknown Device',
          style: TextStyle(
            fontWeight: device.connected || device.isSaved
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        subtitle: Row(
          children: [
            signalIcon,
            const SizedBox(width: 4),
            Text('${device.rssi} dBm'),
            const SizedBox(width: 8),
            if (device.isSaved)
              Chip(
                label: Text(
                  localizations.translate('saved'),
                  style: const TextStyle(fontSize: 10),
                ),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Save/Unsave button
            IconButton(
              icon: Icon(
                device.isSaved ? Icons.star : Icons.star_border,
                color: device.isSaved ? Colors.amber : null,
              ),
              onPressed: () {
                if (device.isSaved) {
                  bleController.removeSavedDevice(device.id);
                } else {
                  bleController.saveDevice(device.id);
                }
              },
            ),

            // Connect/Disconnect button
            IconButton(
              icon: Icon(
                device.connected ? Icons.bluetooth_connected : Icons.bluetooth,
                color: device.connected ? theme.primaryColor : null,
              ),
              onPressed: () {
                if (device.connected) {
                  bleController.disconnectFromDevice(device.id);
                } else {
                  bleController.connectToDevice(device.id);
                }
              },
            ),
          ],
        ),
        onTap: () {
          _showDeviceDetails(device, localizations);
        },
      ),
    );
  }: Text(
                  localizations.translate('saved'),
                  style: const TextStyle(fontSize: 10),
                ),
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Save/Unsave button
            IconButton(
              icon: Icon(
                device.isSaved ? Icons.star : Icons.star_border,
                color: device.isSaved ? Colors.amber : null,
              ),
              onPressed: () {
                if (device.isSaved) {
                  bleController.removeSavedDevice(device.id);
                } else {
                  bleController.saveDevice(device.id);
                }
              },
            ),

            // Connect/Disconnect button
            IconButton(
              icon: Icon(
                device.connected ? Icons.bluetooth_connected : Icons.bluetooth,
                color: device.connected ? theme.primaryColor : null,
              ),
              onPressed: () {
                if (device.connected) {
                  bleController.disconnectFromDevice(device.id);
                } else {
                  bleController.connectToDevice(device.id);
                }
              },
            ),
          ],
        ),
        onTap: () {
          _showDeviceDetails(device, localizations);
        },
      ),
    );
  }

  void _showDeviceDetails(BleDevice device, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('ID: ${device.id}'),
              Text('Type: ${_getDeviceTypeString(device.type, localizations)}'),
              Text('RSSI: ${device.rssi} dBm'),
              Text(
                  'Status: ${device.connected ? localizations.translate('connected') : localizations.translate('disconnected')}'),
              if (device.lastConnected != null)
                Text(
                    'Last Connected: ${_formatDateTime(device.lastConnected!)}'),
              const SizedBox(height: 16),
              if (device.services.isNotEmpty) ...[
                Text(
                  'Services:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView(
                    children: device.services
                        .map((service) => Text('• $service'))
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(
                      device.isSaved ? Icons.star : Icons.star_border,
                    ),
                    label: Text(
                      device.isSaved
                          ? localizations.translate('remove_saved')
                          : localizations.translate('save_device'),
                    ),
                    onPressed: () {
                      final bleController = ref.read(ble.bleControllerProvider);
                      if (device.isSaved) {
                        bleController.removeSavedDevice(device.id);
                      } else {
                        bleController.saveDevice(device.id);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      device.connected
                          ? Icons.bluetooth_disabled
                          : Icons.bluetooth_connected,
                    ),
                    label: Text(
                      device.connected
                          ? localizations.translate('disconnect')
                          : localizations.translate('connect'),
                    ),
                    onPressed: () {
                      final bleController = ref.read(ble.bleControllerProvider);
                      if (device.connected) {
                        bleController.disconnectFromDevice(device.id);
                      } else {
                        bleController.connectToDevice(device.id);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDeviceTypeString(String type, AppLocalizations localizations) {
    switch (type) {
      case BleDevice.typeHeartRate:
        return localizations.translate('heart_rate');
      case BleDevice.typePower:
        return localizations.translate('power');
      case BleDevice.typeCadence:
        return localizations.translate('cadence');
      case BleDevice.typeCombined:
        return "Combined";
      default:
        return "Unknown";
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildGpsTab(AppLocalizations localizations) {
    final gpsStatusAsync = ref.watch(gpsStatusProvider);
    final gpsController = ref.read(gpsControllerProvider);
    final currentSettings = gpsController.getCurrentSettings();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // GPS status card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.translate('gps_status'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                gpsStatusAsync.when(
                  data: (status) {
                    // Initialize these with default values
                    Color statusColor = Colors.grey;
                    String statusText = "Unknown";

                    switch (status) {
                      case GPSStatus.disabled:
                        statusColor = Colors.red;
                        statusText = "GPS Disabled";
                        break;
                      case GPSStatus.noPermission:
                        statusColor = Colors.red;
                        statusText = "No Permission";
                        break;
                      case GPSStatus.initializing:
                        statusColor = Colors.orange;
                        statusText = localizations.translate('initializing');
                        break;
                      case GPSStatus.enabled:
                        statusColor = Colors.green;
                        statusText = "GPS Ready";
                        break;
                      case GPSStatus.active:
                        statusColor = Colors.green;
                        statusText = "GPS Active";
                        break;
                    }

                    return Row(
                      children: [
                        Icon(Icons.gps_fixed, color: statusColor),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                        const Spacer(),
                        if (status == GPSStatus.disabled)
                          ElevatedButton(
                            onPressed: () {
                              Geolocator.openLocationSettings();
                            },
                            child: const Text("Enable GPS"),
                          )
                        else if (status == GPSStatus.noPermission)
                          ElevatedButton(
                            onPressed: () {
                              Geolocator.requestPermission();
                            },
                            child: const Text("Grant Permission"),
                          )
                        else if (status == GPSStatus.enabled)
                          ElevatedButton(
                            onPressed: () {
                              gpsController.startTracking();
                            },
                            child: const Text("Start Tracking"),
                          )
                        else if (status == GPSStatus.active)
                          ElevatedButton(
                            onPressed: () {
                              gpsController.stopTracking();
                            },
                            child: const Text("Stop Tracking"),
                          ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Preset Modes Card - FIXED: Made RadioListTile widgets working
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
              Consumer(
                builder: (context, ref, child) {
                  // Get the current settings from the GPS settings provider to update UI on changes
                  final settingsAsync = ref.watch(gpsSettingsProvider);
                  return settingsAsync.when(
                    data: (settings) {
                      return Column(
                        children: [
                          RadioListTile<GPSAccuracy>(
                            title: const Text('Power-Saver'),
                            subtitle: Text(
                                '${gpsController.getBatteryUsageString()}, ~10 m CEP'),
                            value: GPSAccuracy.powerSaver,
                            groupValue: settings.accuracy,
                            onChanged: (value) {
                              if (value != null) {
                                gpsController.updateSettings(
                                  settings.copyWith(accuracy: value),
                                );
                              }
                            },
                          ),
                          RadioListTile<GPSAccuracy>(
                            title: const Text('Balanced'),
                            subtitle: Text(
                                '${gpsController.getBatteryUsageString()}, ~3 m CEP'),
                            value: GPSAccuracy.balanced,
                            groupValue: settings.accuracy,
                            onChanged: (value) {
                              if (value != null) {
                                gpsController.updateSettings(
                                  settings.copyWith(accuracy: value),
                                );
                              }
                            },
                          ),
                          RadioListTile<GPSAccuracy>(
                            title: const Text('High-Accuracy'),
                            subtitle: Text(
                                '${gpsController.getBatteryUsageString()}, ~1-2 m CEP'),
                            value: GPSAccuracy.highAccuracy,
                            groupValue: settings.accuracy,
                            onChanged: (value) {
                              if (value != null) {
                                gpsController.updateSettings(
                                  settings.copyWith(accuracy: value),
                                );
                              }
                            },
                          ),
                          RadioListTile<GPSAccuracy>(
                            title: const Text('RTK'),
                            subtitle: Text(
                                '${gpsController.getBatteryUsageString()}, < 0.5 m CEP'),
                            value: GPSAccuracy.rtk,
                            groupValue: settings.accuracy,
                            onChanged: (value) {
                              if (value != null) {
                                gpsController.updateSettings(
                                  settings.copyWith(accuracy: value),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => const Text(
                      'Error loading GPS settings',
                    ),
                  );
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
              // FIXED: Wrap the settings switches in a Consumer to update UI when settings change
              Consumer(
                builder: (context, ref, child) {
                  final settingsAsync = ref.watch(gpsSettingsProvider);
                  return settingsAsync.when(
                    data: (settings) {
                      return Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Multi-frequency GNSS'),
                            subtitle: const Text('Uses both L1 and L5 bands'),
                            value: settings.multiFrequency,
                            onChanged: (value) {
                              gpsController.updateSettings(
                                settings.copyWith(multiFrequency: value),
                              );
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Raw GNSS Measurements'),
                            subtitle: const Text('For carrier-phase and RTK'),
                            value: settings.rawMeasurements,
                            onChanged: (value) {
                              gpsController.updateSettings(
                                settings.copyWith(rawMeasurements: value),
                              );
                            },
                          ),
                          SwitchListTile(
                            title: const Text('Sensor Fusion'),
                            subtitle: const Text('Combines GPS with IMU sensors'),
                            value: settings.sensorFusion,
                            onChanged: (value) {
                              gpsController.updateSettings(
                                settings.copyWith(sensorFusion: value),
                              );
                            },
                          ),
                          SwitchListTile(
                            title: const Text('RTK Corrections'),
                            subtitle: const Text('NTRIP correction streams'),
                            value: settings.rtkCorrections,
                            onChanged: (value) {
                              gpsController.updateSettings(
                                settings.copyWith(rtkCorrections: value),
                              );
                            },
                          ),
                          SwitchListTile(
                            title: const Text('External GNSS Receiver'),
                            subtitle: const Text('Connect via Bluetooth'),
                            value: settings.externalReceiver,
                            onChanged: (value) {
                              gpsController.updateSettings(
                                settings.copyWith(externalReceiver: value),
                              );
                            },
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => const Text(
                      'Error loading GPS settings',
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Custom Trade-off Slider Card
        Consumer(
          builder: (context, ref, child) {
            final gpsSettingsAsync = ref.watch(gpsSettingsProvider);
            
            return gpsSettingsAsync.when(
              data: (settings) {
                double sliderValue = 0.5;

                // Calculate slider value based on accuracy
                switch (settings.accuracy) {
                  case GPSAccuracy.powerSaver:
                    sliderValue = 0.0;
                    break;
                  case GPSAccuracy.balanced:
                    sliderValue = 0.33;
                    break;
                  case GPSAccuracy.highAccuracy:
                    sliderValue = 0.67;
                    break;
                  case GPSAccuracy.rtk:
                    sliderValue = 1.0;
                    break;
                }

                return Card(
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
                                value: sliderValue,
                                onChanged: (value) {
                                  GPSAccuracy accuracy;

                                  if (value < 0.25) {
                                    accuracy = GPSAccuracy.powerSaver;
                                  } else if (value < 0.5) {
                                    accuracy = GPSAccuracy.balanced;
                                  } else if (value < 0.75) {
                                    accuracy = GPSAccuracy.highAccuracy;
                                  } else {
                                    accuracy = GPSAccuracy.rtk;
                                  }

                                  gpsController.updateSettings(
                                    settings.copyWith(accuracy: accuracy),
                                  );
                                },
                              ),
                            ),
                            const Icon(Icons.gps_fixed),
                          ],
                        ),
                        Center(child: Text('${(sliderValue * 100).toInt()}%')),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $error'),
                ),
              ),
            );
          },
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
                      onPressed: () async {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const AlertDialog(
                            title: Text('Running GPS Test'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Testing for 30 seconds...'),
                              ],
                            ),
                          ),
                        );

                        // Run test
                        final results = await gpsController.runFieldTest();

                        // Close loading dialog
                        if (mounted) {
                          Navigator.pop(context);

                          // Show results
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('GPS Test Results'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (results['success'] == true) ...[
                                    Text(
                                        'Positions collected: ${results['positions']}'),
                                    Text(
                                        'Average accuracy: ${results['avgAccuracy'].toStringAsFixed(2)} m'),
                                    Text(
                                        'Best accuracy: ${results['minAccuracy'].toStringAsFixed(2)} m'),
                                    Text(
                                        'Worst accuracy: ${results['maxAccuracy'].toStringAsFixed(2)} m'),
                                    Text(
                                        'Test duration: ${results['time']} seconds'),
                                  ] else
                                    Text('Error: ${results['error']}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(localizations.translate('close')),
                                ),
                              ],
                            ),
                          );
                        }
                      },
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