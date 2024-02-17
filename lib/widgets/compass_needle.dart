import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CompassNeedle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 700;
    final double _yScaling = size.height / 700;
    path.lineTo(563.6 * _xScaling,498.6 * _yScaling);
    path.cubicTo(563.6 * _xScaling,498.6 * _yScaling,369.6 * _xScaling,33.900000000000034 * _yScaling,369.6 * _xScaling,33.900000000000034 * _yScaling,);
    path.cubicTo(365.40000000000003 * _xScaling,23.900000000000034 * _yScaling,355.6 * _xScaling,17.400000000000034 * _yScaling,344.8 * _xScaling,17.500000000000036 * _yScaling,);
    path.cubicTo(334 * _xScaling,17.600000000000037 * _yScaling,324.3 * _xScaling,24.300000000000036 * _yScaling,320.3 * _xScaling,34.30000000000004 * _yScaling,);
    path.cubicTo(320.3 * _xScaling,34.30000000000004 * _yScaling,136.2 * _xScaling,499.7 * _yScaling,136.2 * _xScaling,499.7 * _yScaling,);
    path.cubicTo(132.2 * _xScaling,509.9 * _yScaling,134.79999999999998 * _xScaling,521.5 * _yScaling,142.79999999999998 * _xScaling,529 * _yScaling,);
    path.cubicTo(147.79999999999998 * _xScaling,533.7 * _yScaling,154.29999999999998 * _xScaling,536.1 * _yScaling,160.89999999999998 * _xScaling,536.1 * _yScaling,);
    path.cubicTo(164.79999999999998 * _xScaling,536.1 * _yScaling,168.79999999999998 * _xScaling,535.2 * _yScaling,172.49999999999997 * _xScaling,533.4 * _yScaling,);
    path.cubicTo(172.49999999999997 * _xScaling,533.4 * _yScaling,201.69999999999996 * _xScaling,519.3 * _yScaling,201.69999999999996 * _xScaling,519.3 * _yScaling,);
    path.cubicTo(201.69999999999996 * _xScaling,519.3 * _yScaling,201.59999999999997 * _xScaling,619.1999999999999 * _yScaling,201.59999999999997 * _xScaling,619.1999999999999 * _yScaling,);
    path.cubicTo(201.59999999999997 * _xScaling,619.1999999999999 * _yScaling,350 * _xScaling,682.4 * _yScaling,350 * _xScaling,682.4 * _yScaling,);
    path.cubicTo(350 * _xScaling,682.4 * _yScaling,474.4 * _xScaling,625.6 * _yScaling,474.4 * _xScaling,625.6 * _yScaling,);
    path.cubicTo(474.4 * _xScaling,625.6 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,);
    path.cubicTo(474.59999999999997 * _xScaling,625.5 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,);
    path.cubicTo(474.59999999999997 * _xScaling,625.5 * _yScaling,498.2 * _xScaling,614.7 * _yScaling,498.2 * _xScaling,614.7 * _yScaling,);
    path.cubicTo(498.2 * _xScaling,614.7 * _yScaling,498.2 * _xScaling,518.8000000000001 * _yScaling,498.2 * _xScaling,518.8000000000001 * _yScaling,);
    path.cubicTo(498.2 * _xScaling,518.8000000000001 * _yScaling,527.5 * _xScaling,532.8000000000001 * _yScaling,527.5 * _xScaling,532.8000000000001 * _yScaling,);
    path.cubicTo(537.5 * _xScaling,537.6 * _yScaling,549.3 * _xScaling,535.7 * _yScaling,557.3 * _xScaling,528.1 * _yScaling,);
    path.cubicTo(565.4 * _xScaling,520.6 * _yScaling,567.9 * _xScaling,508.8 * _yScaling,563.6 * _xScaling,498.6 * _yScaling,);
    path.cubicTo(563.6 * _xScaling,498.6 * _yScaling,563.6 * _xScaling,498.6 * _yScaling,563.6 * _xScaling,498.6 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

}

class CompassNeedlePathProvider extends NeumorphicPathProvider {
  @override
  bool shouldReclip(NeumorphicPathProvider oldClipper) {
    return true;
  }

  @override
  Path getPath(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 700;
    final double _yScaling = size.height / 700;
    path.lineTo(563.6 * _xScaling,498.6 * _yScaling);
    path.cubicTo(563.6 * _xScaling,498.6 * _yScaling,369.6 * _xScaling,33.900000000000034 * _yScaling,369.6 * _xScaling,33.900000000000034 * _yScaling,);
    path.cubicTo(365.40000000000003 * _xScaling,23.900000000000034 * _yScaling,355.6 * _xScaling,17.400000000000034 * _yScaling,344.8 * _xScaling,17.500000000000036 * _yScaling,);
    path.cubicTo(334 * _xScaling,17.600000000000037 * _yScaling,324.3 * _xScaling,24.300000000000036 * _yScaling,320.3 * _xScaling,34.30000000000004 * _yScaling,);
    path.cubicTo(320.3 * _xScaling,34.30000000000004 * _yScaling,136.2 * _xScaling,499.7 * _yScaling,136.2 * _xScaling,499.7 * _yScaling,);
    path.cubicTo(132.2 * _xScaling,509.9 * _yScaling,134.79999999999998 * _xScaling,521.5 * _yScaling,142.79999999999998 * _xScaling,529 * _yScaling,);
    path.cubicTo(147.79999999999998 * _xScaling,533.7 * _yScaling,154.29999999999998 * _xScaling,536.1 * _yScaling,160.89999999999998 * _xScaling,536.1 * _yScaling,);
    path.cubicTo(164.79999999999998 * _xScaling,536.1 * _yScaling,168.79999999999998 * _xScaling,535.2 * _yScaling,172.49999999999997 * _xScaling,533.4 * _yScaling,);
    path.cubicTo(172.49999999999997 * _xScaling,533.4 * _yScaling,201.69999999999996 * _xScaling,519.3 * _yScaling,201.69999999999996 * _xScaling,519.3 * _yScaling,);
    path.cubicTo(201.69999999999996 * _xScaling,519.3 * _yScaling,201.59999999999997 * _xScaling,619.1999999999999 * _yScaling,201.59999999999997 * _xScaling,619.1999999999999 * _yScaling,);
    path.cubicTo(201.59999999999997 * _xScaling,619.1999999999999 * _yScaling,350 * _xScaling,682.4 * _yScaling,350 * _xScaling,682.4 * _yScaling,);
    path.cubicTo(350 * _xScaling,682.4 * _yScaling,474.4 * _xScaling,625.6 * _yScaling,474.4 * _xScaling,625.6 * _yScaling,);
    path.cubicTo(474.4 * _xScaling,625.6 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,);
    path.cubicTo(474.59999999999997 * _xScaling,625.5 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,474.59999999999997 * _xScaling,625.5 * _yScaling,);
    path.cubicTo(474.59999999999997 * _xScaling,625.5 * _yScaling,498.2 * _xScaling,614.7 * _yScaling,498.2 * _xScaling,614.7 * _yScaling,);
    path.cubicTo(498.2 * _xScaling,614.7 * _yScaling,498.2 * _xScaling,518.8000000000001 * _yScaling,498.2 * _xScaling,518.8000000000001 * _yScaling,);
    path.cubicTo(498.2 * _xScaling,518.8000000000001 * _yScaling,527.5 * _xScaling,532.8000000000001 * _yScaling,527.5 * _xScaling,532.8000000000001 * _yScaling,);
    path.cubicTo(537.5 * _xScaling,537.6 * _yScaling,549.3 * _xScaling,535.7 * _yScaling,557.3 * _xScaling,528.1 * _yScaling,);
    path.cubicTo(565.4 * _xScaling,520.6 * _yScaling,567.9 * _xScaling,508.8 * _yScaling,563.6 * _xScaling,498.6 * _yScaling,);
    path.cubicTo(563.6 * _xScaling,498.6 * _yScaling,563.6 * _xScaling,498.6 * _yScaling,563.6 * _xScaling,498.6 * _yScaling,);
    return path..close();
  }

  @override
  bool get oneGradientPerPath => true;
}
