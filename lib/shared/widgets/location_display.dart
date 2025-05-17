// lib/shared/widgets/location_display.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/gps_providers.dart' as gps;
import '../../services/gps_service.dart';

class LocationDisplay extends ConsumerWidget {
  final Position position;
  final bool isCurrentLocation;
  final bool showDetails;

  const LocationDisplay({
    super.key,
    required this.position,
    this.isCurrentLocation = true,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Location marker
        Icon(
          isCurrentLocation ? Icons.location_on : Icons.location_searching,
          size: 64,
          color: isCurrentLocation ? Colors.red : Colors.blue,
        ),

        // Location info
        if (showDetails) ...[
          const SizedBox(height: 8),
          Text(
            isCurrentLocation ? 'Current Location' : 'Selected Location',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lat: ${position.latitude.toStringAsFixed(6)}',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          Text(
            'Lng: ${position.longitude.toStringAsFixed(6)}',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          if (position.altitude != 0.0)
            Text(
              'Alt: ${position.altitude.toStringAsFixed(1)} m',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          if (position.speed != 0.0)
            Text(
              'Speed: ${(position.speed * 3.6).toStringAsFixed(1)} km/h',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
        ],
      ],
    );
  }
}

class LocationStatusDisplay extends ConsumerWidget {
  const LocationStatusDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gpsStatusAsync = ref.watch(gps.gpsStatusProvider);

    return gpsStatusAsync.when(
      data: (status) {
        IconData iconData;
        String statusText;
        Color iconColor;

        switch (status) {
          case GPSStatus.disabled:
            iconData = Icons.location_disabled;
            statusText = 'GPS is disabled';
            iconColor = Colors.red;
            break;
          case GPSStatus.noPermission:
            iconData = Icons.location_off;
            statusText = 'No location permission';
            iconColor = Colors.red;
            break;
          case GPSStatus.initializing:
            iconData = Icons.location_searching;
            statusText = 'Initializing GPS...';
            iconColor = Colors.orange;
            break;
          case GPSStatus.enabled:
            iconData = Icons.location_searching;
            statusText = 'GPS Ready - Waiting for location';
            iconColor = Colors.blue;
            break;
          case GPSStatus.active:
            iconData = Icons.location_searching;
            statusText = 'GPS Active - Waiting for location';
            iconColor = Colors.green;
            break;
          default:
            iconData = Icons.help_outline;
            statusText = 'Unknown GPS status';
            iconColor = Colors.grey;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 64,
              color: iconColor,
            ),
            const SizedBox(height: 16),
            Text(
              statusText,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (status == GPSStatus.disabled)
              ElevatedButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                },
                child: const Text('Enable GPS'),
              )
            else if (status == GPSStatus.noPermission)
              ElevatedButton(
                onPressed: () {
                  Geolocator.requestPermission();
                },
                child: const Text('Grant Permission'),
              )
            else if (status == GPSStatus.enabled)
              ElevatedButton(
                onPressed: () {
                  ref.read(gps.gpsControllerProvider).startTracking();
                },
                child: const Text('Start GPS Tracking'),
              ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error accessing GPS',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(gps.gpsControllerProvider).initialize();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
