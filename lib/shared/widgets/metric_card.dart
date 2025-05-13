import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? customContent;
  final Color backgroundColor;
  final IconData icon;
  final double height;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.customContent,
    required this.backgroundColor,
    required this.icon,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11, // Reduced from 12
                  ),
                ),
                Icon(icon, size: 16),
              ],
            ),

            const Divider(height: 8, thickness: 1),

            // Either custom content or standard value display
            Expanded(
              child: customContent ??
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Reduced from 24
                          ),
                          textAlign:
                              TextAlign.center, // Added to prevent overflow
                          overflow: TextOverflow
                              .ellipsis, // Handle potential overflow
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: const TextStyle(
                                fontSize: 11), // Reduced from 12
                          ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
