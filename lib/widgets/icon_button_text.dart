import 'package:flutter/material.dart';

class IconButtonText extends StatelessWidget {
  const IconButtonText({
    super.key,
    required this.onClick,
    required this.iconData,
    required this.text,
    required this.selected,
  });

  final VoidCallback onClick;
  final IconData iconData;
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xff283593) : Colors.black;

    return InkWell(
      onTap: onClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, color: color),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
