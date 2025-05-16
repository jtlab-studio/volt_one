// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app.dart';
import 'core/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Wrap the entire app with the ThemeManagerProvider
  runApp(
    ProviderScope(
      child: ThemeManagerProvider(
        child: const VoltApp(),
      ),
    ),
  );
}
