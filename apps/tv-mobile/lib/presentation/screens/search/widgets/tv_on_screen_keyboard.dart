import 'package:flutter/material.dart';

class TvOnScreenKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyPress;

  const TvOnScreenKeyboard({Key? key, required this.onKeyPress}) : super(key: key);

  static const keys = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N',
    'O', 'P', 'Q', 'R', 'S', 'T', 'U',
    'V', 'W', 'X', 'Y', 'Z', '1', '2',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: keys.map((k) {
        return ElevatedButton(
          onPressed: () => onKeyPress(k),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF121722)),
          child: Text(k, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }
}
