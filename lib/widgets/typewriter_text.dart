import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration pauseDuration;

  const TypewriterText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayText = '';
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() async {
    while (mounted) {
      if (!_isDeleting) {
        // Typing
        if (_charIndex < widget.texts[_textIndex].length) {
          await Future.delayed(widget.typingSpeed);
          if (mounted) {
            setState(() {
              _displayText = widget.texts[_textIndex].substring(
                0,
                _charIndex + 1,
              );
              _charIndex++;
            });
          }
        } else {
          // Finished typing, pause then delete
          await Future.delayed(widget.pauseDuration);
          if (mounted) {
            setState(() {
              _isDeleting = true;
            });
          }
        }
      } else {
        // Deleting
        if (_charIndex > 0) {
          await Future.delayed(const Duration(milliseconds: 50));
          if (mounted) {
            setState(() {
              _charIndex--;
              _displayText = widget.texts[_textIndex].substring(0, _charIndex);
            });
          }
        } else {
          // Finished deleting, move to next text
          if (mounted) {
            setState(() {
              _isDeleting = false;
              _textIndex = (_textIndex + 1) % widget.texts.length;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_displayText, style: widget.style),
        _BlinkingCursor(style: widget.style),
      ],
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final TextStyle? style;

  const _BlinkingCursor({this.style});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        '|',
        style: widget.style?.copyWith(
          color: Colors.cyan,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
