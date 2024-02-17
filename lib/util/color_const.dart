import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Color baseColor(BuildContext context) => NeumorphicTheme.of(context)!.current!.baseColor;
Color teal800(BuildContext context) => NeumorphicTheme.currentTheme(context).accentColor;
Color whiteBlack(BuildContext context) => NeumorphicTheme.isUsingDark(context) ? NeumorphicTheme.of(context)!.current!.baseColor : Colors.black87;
Color blackWhite(BuildContext context) => NeumorphicTheme.isUsingDark(context) ? NeumorphicTheme.of(context)!.current!.accentColor : Colors.black87;
Color tealWhite(BuildContext context) => NeumorphicTheme.isUsingDark(context) ? Colors.teal : teal800(context);
