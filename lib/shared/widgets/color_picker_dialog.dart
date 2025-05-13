// lib/shared/widgets/color_picker_dialog.dart

import 'package:flutter/material.dart';

/// A dialog that allows selecting a color from a grid of predefined colors
/// or entering a custom hex color code.
class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final Function(Color) onColorSelected;
  final String title;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
    required this.title,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color selectedColor;
  late TextEditingController hexController;

  // Predefined material colors for the grid
  final List<Color> materialColors = [
    // Red colors
    Colors.red,
    Colors.red[700]!,
    Colors.red[300]!,

    // Pink colors
    Colors.pink,
    Colors.pink[700]!,
    Colors.pink[300]!,

    // Purple colors
    Colors.purple,
    Colors.purple[700]!,
    Colors.purple[300]!,

    // Deep Purple colors
    Colors.deepPurple,
    Colors.deepPurple[700]!,
    Colors.deepPurple[300]!,

    // Indigo colors
    Colors.indigo,
    Colors.indigo[700]!,
    Colors.indigo[300]!,

    // Blue colors
    Colors.blue,
    Colors.blue[700]!,
    Colors.blue[300]!,

    // Light Blue colors
    Colors.lightBlue,
    Colors.lightBlue[700]!,
    Colors.lightBlue[300]!,

    // Cyan colors
    Colors.cyan,
    Colors.cyan[700]!,
    Colors.cyan[300]!,

    // Teal colors
    Colors.teal,
    Colors.teal[700]!,
    Colors.teal[300]!,

    // Green colors
    Colors.green,
    Colors.green[700]!,
    Colors.green[300]!,

    // Light Green colors
    Colors.lightGreen,
    Colors.lightGreen[700]!,
    Colors.lightGreen[300]!,

    // Lime colors
    Colors.lime,
    Colors.lime[700]!,
    Colors.lime[300]!,

    // Yellow colors
    Colors.yellow,
    Colors.yellow[700]!,
    Colors.yellow[300]!,

    // Amber colors
    Colors.amber,
    Colors.amber[700]!,
    Colors.amber[300]!,

    // Orange colors
    Colors.orange,
    Colors.orange[700]!,
    Colors.orange[300]!,

    // Deep Orange colors
    Colors.deepOrange,
    Colors.deepOrange[700]!,
    Colors.deepOrange[300]!,

    // Brown colors
    Colors.brown,
    Colors.brown[700]!,
    Colors.brown[300]!,

    // Grey colors
    Colors.grey,
    Colors.grey[700]!,
    Colors.grey[300]!,

    // Blue Grey colors
    Colors.blueGrey,
    Colors.blueGrey[700]!,
    Colors.blueGrey[300]!,
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
    hexController =
        TextEditingController(text: colorToHex(widget.initialColor));
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }

  // Convert color to hex string
  String colorToHex(Color color, {bool includeHashSign = true}) {
    // Get individual RGB components as integers
    String hexR = color.red.toRadixString(16).padLeft(2, '0');
    String hexG = color.green.toRadixString(16).padLeft(2, '0');
    String hexB = color.blue.toRadixString(16).padLeft(2, '0');

    // Combine and return formatted hex string
    return (includeHashSign ? '#' : '') + '$hexR$hexG$hexB'.toUpperCase();
  }

  // Convert hex string to color
  Color hexToColor(String hexString) {
    try {
      final hexCode = hexString.replaceAll('#', '');
      return Color.fromARGB(
        255, // Full opacity
        int.parse(hexCode.substring(0, 2), radix: 16), // R
        int.parse(hexCode.substring(2, 4), radix: 16), // G
        int.parse(hexCode.substring(4, 6), radix: 16), // B
      );
    } catch (e) {
      // Return the selected color if parsing fails
      return selectedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color preview
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),

            // Hex color input
            TextField(
              controller: hexController,
              decoration: const InputDecoration(
                labelText: 'Hex Color',
                hintText: 'e.g. FF5722',
                prefixText: '#',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                try {
                  // Only update if valid hex color
                  if (value.length == 6) {
                    final newColor = hexToColor(value);
                    setState(() {
                      selectedColor = newColor;
                    });
                  }
                } catch (e) {
                  // Ignore invalid inputs
                }
              },
            ),
            const SizedBox(height: 16),

            // Color grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: materialColors.length,
                itemBuilder: (context, index) {
                  final color = materialColors[index];
                  // Compare individual RGB components
                  final isSelected = selectedColor.red == color.red &&
                      selectedColor.green == color.green &&
                      selectedColor.blue == color.blue;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                        hexController.text =
                            colorToHex(color, includeHashSign: false);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onColorSelected(selectedColor);
            Navigator.of(context).pop();
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
