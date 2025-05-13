import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'global_burger_menu.dart';
import 'global_app_bar.dart';

/// A debugging screen to test the global burger menu
class BurgerMenuDebugScreen extends ConsumerWidget {
  const BurgerMenuDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: GlobalAppBar(
        title: 'Burger Menu Debug',
        scaffoldKey: scaffoldKey,
      ),
      endDrawer: const GlobalBurgerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Burger Menu Debugging',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'If the burger menu is not appearing:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('1. Verify the scaffoldKey is passed to GlobalAppBar'),
                  Text('2. Ensure endDrawer (not drawer) is used'),
                  Text('3. Check that the menu icon is visible in the AppBar'),
                  Text('4. Try the button below as an alternative method'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
              child: const Text('Open Burger Menu'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Return to Previous Screen'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Drawer State Information:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (builderContext) {
                final scaffold = Scaffold.of(builderContext);
                final hasEndDrawer = scaffold.hasEndDrawer;

                return Column(
                  children: [
                    Text('Has End Drawer: $hasEndDrawer'),
                    const SizedBox(height: 10),
                    Text('Is Drawer Open: ${scaffold.isEndDrawerOpen}'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
