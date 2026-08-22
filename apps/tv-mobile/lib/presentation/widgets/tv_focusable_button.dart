import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/device_util.dart';

class TvFocusableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final bool autoFocus;

  const TvFocusableButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.autoFocus = false,
  });

  @override
  State<TvFocusableButton> createState() => _TvFocusableButtonState();
}

class _TvFocusableButtonState extends State<TvFocusableButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isTv = DeviceUtil.isTv(context);

    return Focus(
      autofocus: widget.autoFocus,
      canRequestFocus: isTv,
      onFocusChange: (focused) {
        if (mounted) {
          setState(() {
            _isFocused = focused;
          });
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
             event.logicalKey == LogicalKeyboardKey.enter ||
             event.logicalKey == LogicalKeyboardKey.gameButtonA ||
             event.logicalKey == LogicalKeyboardKey.space)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(16),
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
