import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AdaptiveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = Platform.isIOS;

    if (isCupertino) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: backgroundColor ?? CupertinoTheme.of(context).primaryColor,
        onPressed: onPressed,
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: foregroundColor ?? CupertinoColors.white),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                        color: foregroundColor ?? CupertinoColors.white),
                  ),
                ],
              )
            : Text(
                text,
                style:
                    TextStyle(color: foregroundColor ?? CupertinoColors.white),
              ),
      );
    } else {
      return icon != null
          ? ElevatedButton.icon(
              icon: Icon(icon),
              label: Text(text),
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              ),
              child: Text(text),
            );
    }
  }
}

class AdaptiveIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const AdaptiveIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = Platform.isIOS;

    if (isCupertino) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Icon(
          icon,
          color: color ?? CupertinoTheme.of(context).primaryColor,
        ),
      );
    } else {
      return IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: color,
      );
    }
  }
}

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = Platform.isIOS;

    if (isCupertino) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
      );
    }
  }
}

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const AdaptiveTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = Platform.isIOS;

    if (isCupertino) {
      return CupertinoTextField(
        controller: controller,
        placeholder: placeholder ?? labelText,
        keyboardType: keyboardType,
        obscureText: obscureText,
        prefix: prefix,
        suffix: suffix,
        onChanged: onChanged,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.systemGrey4,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: placeholder,
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
      );
    }
  }
}
