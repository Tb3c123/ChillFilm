import 'package:flutter/material.dart';

class TvFocusableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const TvFocusableButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) : super(key: key);

  @override
  State<TvFocusableButton> createState() => _TvFocusableButtonState();
}

class _TvFocusableButtonState extends State<TvFocusableButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_isFocused ? 1.08 : 1.0),
          transformAlignment: Alignment.center,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _isFocused ? const Color(0xFFE50914) : const Color(0xFF19202E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isFocused ? const Color(0xFF00E5FF) : Colors.transparent,
              width: 3.5,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.95),
                      blurRadius: 30,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
