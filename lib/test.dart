import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakaat_tracker/widgets/icon_path.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.path(IconProvider()),
              ),
              child: Container(
                height: 61.w,
                width: 61.w,
                padding: const EdgeInsets.all(1),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  NeumorphicTheme.isUsingDark(context)
                      ? "assets/salat_icon_new.svg"
                      : "assets/salat_icon_new.svg",
                  height: 60.w,
                  width: 60.w,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
