import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =  const Color.fromARGB(255, 147,144,133)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // Điểm bắt đầu của tam giác
    path.lineTo(size.width, 0); // Điểm kết thúc 1 của tam giác
    path.lineTo(0, size.height); // Điểm kết thúc 2 của tam giác
    path.close(); // Kết thúc tam giác

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TriangleInCorner extends StatelessWidget {
  const TriangleInCorner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      color: Colors.white,
      child: CustomPaint(
        painter: TrianglePainter(),
        child: Container(), // Thay thế widget con tại đây nếu cần
      ),
    );
  }
}
