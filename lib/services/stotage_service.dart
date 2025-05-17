// lib/services/storage_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/ble_device.dart';
import 'gps_service.dart';

/// A service for persisting app data
class StorageService {
  // Singleton instance
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Storage keys for SharedPreferences
  static const String _bleDevicesKey = 'ble_devices';
  static const String _gpsSettingsKey = 'gps_settings';

  // Database instance
  Database? _database;

  /// Initialize the storage service
  Future<void> initialize() async {
    try {
      await _initDatabase();
    } catch (e) {
      debugPrint('Error initializing database: $e');
    }
  }

  /// Initialize database
  Future<void> _initDatabase() async {
    if (_database != null) return;

    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'volt_running.db');

      // Open the database
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          // Create BLE devices table
          await db.execute('CREATE TABLE ble_devices ('
              'id TEXT PRIMARY KEY, '
              'name TEXT, '
              'type TEXT, '
              'services TEXT, '
              'last_connected TEXT, '
              'metadata TEXT'
              ')');

          // Create GPS settings table
          await db.execute('CREATE TABLE gps_settings ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'accuracy INTEGER, '
              'multi_frequency INTEGER, '
              'raw_measurements INTEGER, '
              'sensor_fusion INTEGER, '
              'rtk_corrections INTEGER, '
              'external_receiver INTEGER'
              ')');
        },
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      // Fallback to shared preferences only
    }
  }

  /// Save a list of BLE devices using SharedPreferences
  Future<void> saveBleDevicesWithPrefs(List<BleDevice> devices) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert devices to JSON
      final List<Map<String, dynamic>> deviceMaps =
          devices.map((d) => d.toJson()).toList();

      // Save as JSON string
      await prefs.setString(_bleDevicesKey, jsonEncode(deviceMaps));
    } catch (e) {
      debugPrint('Error saving BLE devices with SharedPreferences: $e');
      throw Exception('Failed to save BLE devices');
    }
  }

  /// Get saved BLE devices from SharedPreferences
  Future<List<BleDevice>> getSavedDevicesWithPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get JSON string
      final jsonString = prefs.getString(_bleDevicesKey);
      if (jsonString == null) {
        return [];
      }

      // Decode JSON
      final List<dynamic> deviceMaps = jsonDecode(jsonString);

      // Convert to BleDevice objects
      return deviceMaps
          .map((map) => BleDevice.fromJson(Map<String, dynamic>.from(map)))
          .toList();
    } catch (e) {
      debugPrint('Error getting saved BLE devices from SharedPreferences: $e');
      return [];
    }
  }

  /// Save a list of BLE devices using SQLite
  Future<void> saveBleDevicesWithDb(List<BleDevice> devices) async {
    try {
      await _initDatabase();

      if (_database == null) {
        throw Exception('Database not initialized');
      }

      // Use a batch for better performance
      final batch = _database!.batch();

      // Clear existing devices
      batch.delete('ble_devices');

      // Insert all devices
      for (final device in devices) {
        batch.insert('ble_devices', {
          'id': device.id,
          'name': device.name,
          'type': device.type,
          'services': jsonEncode(device.services),
          'last_connected': device.lastConnected?.toIso8601String(),
          'metadata': jsonEncode(device.metadata),
        });
      }

      // Execute batch
      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint('Error saving BLE devices with SQLite: $e');
      // Fall back to SharedPreferences
      await saveBleDevicesWithPrefs(devices);
    }
  }

  /// Get saved BLE devices from SQLite
  Future<List<BleDevice>> getSavedDevicesWithDb() async {
    try {
      await _initDatabase();

      if (_database == null) {
        throw Exception('Database not initialized');
      }

      // Query all devices
      final deviceMaps = await _database!.query('ble_devices');

      // Convert to BleDevice objects
      return deviceMaps.map((map) {
        return BleDevice(
          id: map['id'] as String,
          name: map['name'] as String,
          type: map['type'] as String,
          services: List<String>.from(jsonDecode(map['services'] as String)),
          lastConnected: map['last_connected'] != null
              ? DateTime.parse(map['last_connected'] as String)
              : null,
          isSaved: true,
          metadata:
              Map<String, dynamic>.from(jsonDecode(map['metadata'] as String)),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting saved BLE devices from SQLite: $e');
      // Fall back to SharedPreferences
      return getSavedDevicesWithPrefs();
    }
  }

  /// Save a list of BLE devices
  Future<void> saveBleDevices(List<BleDevice> devices) async {
    try {
      // Try to save with SQLite first
      await saveBleDevicesWithDb(devices);
    } catch (e) {
      // Fall back to SharedPreferences
      await saveBleDevicesWithPrefs(devices);
    }
  }

  /// Get saved BLE devices
  Future<List<BleDevice>> getSavedDevices() async {
    try {
      // Try to get from SQLite first
      return await getSavedDevicesWithDb();
    } catch (e) {
      // Fall back to SharedPreferences
      return getSavedDevicesWithPrefs();
    }
  }

  /// Save GPS settings using SharedPreferences
  Future<void> saveGpsSettingsWithPrefs(GPSSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert settings to JSON
      final settingsMap = settings.toJson();

      // Save as JSON string
      await prefs.setString(_gpsSettingsKey, jsonEncode(settingsMap));
    } catch (e) {
      debugPrint('Error saving GPS settings with SharedPreferences: $e');
      throw Exception('Failed to save GPS settings');
    }
  }

  /// Get GPS settings from SharedPreferences
  Future<GPSSettings?> getGpsSettingsWithPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get JSON string
      final jsonString = prefs.getString(_gpsSettingsKey);
      if (jsonString == null) {
        return null;
      }

      // Decode JSON
      final Map<String, dynamic> settingsMap = jsonDecode(jsonString);

      // Convert to GPSSettings object
      return GPSSettings.fromJson(settingsMap);
    } catch (e) {
      debugPrint('Error getting GPS settings from SharedPreferences: $e');
      return null;
    }
  }

  /// Save GPS settings using SQLite
  Future<void> saveGpsSettingsWithDb(GPSSettings settings) async {
    try {
      await _initDatabase();

      if (_database == null) {
        throw Exception('Database not initialized');
      }

      // Clear existing settings
      await _database!.delete('gps_settings');

      // Insert new settings
      await _database!.insert('gps_settings', {
        'accuracy': settings.accuracy.index,
        'multi_frequency': settings.multiFrequency ? 1 : 0,
        'raw_measurements': settings.rawMeasurements ? 1 : 0,
        'sensor_fusion': settings.sensorFusion ? 1 : 0,
        'rtk_corrections': settings.rtkCorrections ? 1 : 0,
        'external_receiver': settings.externalReceiver ? 1 : 0,
      });
    } catch (e) {
      debugPrint('Error saving GPS settings with SQLite: $e');
      // Fall back to SharedPreferences
      await saveGpsSettingsWithPrefs(settings);
    }
  }

  /// Get GPS settings from SQLite
  Future<GPSSettings?> getGpsSettingsWithDb() async {
    try {
      await _initDatabase();

      if (_database == null) {
        throw Exception('Database not initialized');
      }

      // Query settings
      final settingsMaps = await _database!.query('gps_settings');
      if (settingsMaps.isEmpty) {
        return null;
      }

      // Get first settings record
      final map = settingsMaps.first;

      // Convert to GPSSettings
      return GPSSettings(
        accuracy: GPSAccuracy.values[map['accuracy'] as int],
        multiFrequency: (map['multi_frequency'] as int) == 1,
        rawMeasurements: (map['raw_measurements'] as int) == 1,
        sensorFusion: (map['sensor_fusion'] as int) == 1,
        rtkCorrections: (map['rtk_corrections'] as int) == 1,
        externalReceiver: (map['external_receiver'] as int) == 1,
      );
    } catch (e) {
      debugPrint('Error getting GPS settings from SQLite: $e');
      // Fall back to SharedPreferences
      return getGpsSettingsWithPrefs();
    }
  }

  /// Save GPS settings
  Future<void> saveGpsSettings(GPSSettings settings) async {
    try {
      // Try to save with SQLite first
      await saveGpsSettingsWithDb(settings);
    } catch (e) {
      // Fall back to SharedPreferences
      await saveGpsSettingsWithPrefs(settings);
    }
  }

  /// Get GPS settings
  Future<GPSSettings?> getGpsSettings() async {
    try {
      // Try to get from SQLite first
      return await getGpsSettingsWithDb();
    } catch (e) {
      // Fall back to SharedPreferences
      return getGpsSettingsWithPrefs();
    }
  }

  /// Clear all saved data
  Future<void> clearAllData() async {
    try {
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear SQLite database
      await _initDatabase();
      if (_database != null) {
        await _database!.delete('ble_devices');
        await _database!.delete('gps_settings');
      }
    } catch (e) {
      debugPrint('Error clearing all data: $e');
      throw Exception('Failed to clear all data');
    }
  }
}
