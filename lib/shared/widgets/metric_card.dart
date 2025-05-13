import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit; // Added separate unit parameter
  final String? subtitle;
  final Widget? customContent;
  final Color backgroundColor;
  final IconData icon;
  final double height;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.unit, // Optional unit text that will be displayed smaller
    this.subtitle,
    this.customContent,
    required this.backgroundColor,
    required this.icon,
    this.height = 70, // Reduced from 140 by 50%
  });

  @override
  Widget build(BuildContext context) {
    // Using a uniform background color for all cards
    final uniformColor = Colors.white;

    return Card(
      elevation: 2,
      color: uniformColor,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4), // Reduced vertical padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(), // Explicit uppercase for the title
                    maxLines: 1,
                    style: TextStyle(
                      color:
                          backgroundColor, // Use the background color for the title too
                      fontWeight: FontWeight.bold,
                      fontSize: 10, // Keep small for compact display
                      letterSpacing:
                          0.5, // Added letter spacing for better readability
                    ),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                ),
                Icon(icon, size: 14, color: backgroundColor), // Colored icon
              ],
            ),

            Divider(
                height: 4,
                thickness: 1,
                color: backgroundColor.withOpacity(0.3)), // Colored divider

            // Either custom content or standard value display
            Expanded(
              child: customContent ??
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: value,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26, // Further increased (was 22)
                                  color: backgroundColor, // Colored text
                                ),
                              ),
                              if (unit != null)
                                TextSpan(
                                  text: ' $unit',
                                  style: TextStyle(
                                    fontSize: 13, // 50% of value text
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 9, // Keep small for subtitle
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
