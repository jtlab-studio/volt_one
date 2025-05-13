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
    final darkColor = const Color(0xFF212121);

    return Card(
      elevation: 2,
      color: darkColor,
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
                      color: backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, size: 14, color: backgroundColor),
              ],
            ),

            // Divider using color with adjusted alpha
            Divider(
              height: 4,
              thickness: 1,
              color: Color.fromARGB(
                76,
                backgroundColor.r.toInt(),
                backgroundColor.g.toInt(),
                backgroundColor.b.toInt(),
              ),
            ),

            // Value and optional subtitle or custom content
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
                                  fontSize: 26,
                                  color: Colors.white,
                                ),
                              ),
                              if (unit != null)
                                TextSpan(
                                  text: ' $unit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[400],
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
                                fontSize: 9,
                                color: Colors.grey[400],
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
