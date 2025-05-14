// lib/shared/widgets/metric_card.dart

import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String? subtitle;
  final Widget? customContent;
  final Color backgroundColor;
  final IconData icon;
  final double height;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    this.customContent,
    required this.backgroundColor,
    required this.icon,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Use theme-appropriate card color
    final cardColor =
        isDarkMode ? const Color.fromRGBO(42, 42, 42, 1.0) : Colors.white;

    // Set appropriate text colors based on theme
    final titleColor = backgroundColor; // Keep title the accent color
    final valueColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode
        ? const Color.fromRGBO(200, 200, 200, 1.0)
        : const Color.fromRGBO(100, 100, 100, 1.0);

    return Card(
      elevation: 2,
      color: cardColor,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    maxLines: 1,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, size: 14, color: titleColor),
              ],
            ),

            // Divider using color with RGBA
            Divider(
              height: 4,
              thickness: 1,
              color: Color.fromRGBO(
                backgroundColor.red,
                backgroundColor.green,
                backgroundColor.blue,
                0.3, // Using RGBA for opacity
              ),
            ),

            // Value and optional subtitle or custom content
            Expanded(
              child: customContent ??
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Adjust font size based on available height
                        final bool isSmallCard = height < 60;
                        final double valueFontSize = isSmallCard ? 20 : 26;
                        final double unitFontSize = isSmallCard ? 10 : 13;
                        final double subtitleFontSize = isSmallCard ? 8 : 9;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize:
                              MainAxisSize.min, // Use min to avoid overflow
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: value,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: valueFontSize,
                                      color: valueColor,
                                    ),
                                  ),
                                  if (unit != null)
                                    TextSpan(
                                      text: ' $unit',
                                      style: TextStyle(
                                        fontSize: unitFontSize,
                                        color: subtitleColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (subtitle != null && constraints.maxHeight > 30)
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text(
                                  subtitle!,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: subtitleColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
