import 'package:flutter/material.dart';

class AnimatedWaterEffect extends StatefulWidget {
  final double waterLevel;
  final double borderRadius;

  const AnimatedWaterEffect({
    required this.waterLevel,
    required this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedWaterEffectState createState() => _AnimatedWaterEffectState();
}

class _AnimatedWaterEffectState extends State<AnimatedWaterEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomBorderRadiusClipper(widget.borderRadius),
      child: CustomPaint(
        painter: WaterPainter(
          waterLevel: widget.waterLevel,
          animationValue: _animation.value,
        ),
      ),
    );
  }
}

class BottomBorderRadiusClipper extends CustomClipper<Path> {
  final double borderRadius;

  BottomBorderRadiusClipper(this.borderRadius);

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, size.height - borderRadius)
      ..quadraticBezierTo(0, size.height, borderRadius, size.height)
      ..lineTo(size.width - borderRadius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - borderRadius)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaterPainter extends CustomPainter {
  final double waterLevel;
  final double animationValue;

  WaterPainter({
    required this.waterLevel,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double waveHeight = 20 * animationValue;
    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * (1 - waterLevel))
      ..cubicTo(
        size.width * 0.1,
        size.height * (1 - waterLevel) - waveHeight,
        size.width * 0.3,
        size.height * (1 - waterLevel) + waveHeight * 0.5,
        size.width * 0.5,
        size.height * (1 - waterLevel),
      )
      ..cubicTo(
        size.width * 0.7,
        size.height * (1 - waterLevel) - waveHeight * 0.5,
        size.width * 0.9,
        size.height * (1 - waterLevel) + waveHeight,
        size.width,
        size.height * (1 - waterLevel),
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaterPainter oldDelegate) {
    return oldDelegate.waterLevel != waterLevel ||
        oldDelegate.animationValue != animationValue;
  }
}
