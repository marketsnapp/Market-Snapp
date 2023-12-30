import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketsnapp/config.dart';

class CryptoPriceText extends StatefulWidget {
  final String priceText;
  final bool isLastPriceUp;
  final bool isHeader;

  CryptoPriceText({
    Key? key,
    required this.priceText,
    required this.isLastPriceUp,
    this.isHeader = false,
  }) : super(key: key);

  @override
  _CryptoPriceTextState createState() => _CryptoPriceTextState();
}

class _CryptoPriceTextState extends State<CryptoPriceText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Color _currentColor = whiteColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controller.addListener(() {
      if (_controller.isCompleted) {
        setState(() {
          _currentColor = whiteColor;
        });
      }
    });

    initAnimation(widget.isLastPriceUp);
  }

  void initAnimation(bool isUp) {
    _colorAnimation = ColorTween(
      begin: isUp ? greenColor : redColor,
      end: whiteColor,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(CryptoPriceText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLastPriceUp != oldWidget.isLastPriceUp ||
        widget.priceText != oldWidget.priceText) {
      setState(() {
        _currentColor = widget.isLastPriceUp ? greenColor : redColor;
      });
      initAnimation(widget.isLastPriceUp);
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Text(
          widget.priceText,
          style: widget.isHeader
              ? GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _controller.isAnimating
                      ? _colorAnimation.value
                      : _currentColor,
                )
              : GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _controller.isAnimating
                      ? _colorAnimation.value
                      : _currentColor,
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }
}
