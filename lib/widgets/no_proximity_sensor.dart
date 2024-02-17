import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoProximitySensor extends StatelessWidget {
  const NoProximitySensor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NeumorphicIcon(
          Icons.warning_rounded,
          size: 50.w,
          style: NeumorphicStyle(
            depth: 10,
            color: teal800(context),
            lightSource: LightSource.topLeft,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            translation(context).no_proximity_sensor_tr,
            style: GoogleFonts.cairo(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: teal800(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            translation(context).msg_no_proximity_sensor_tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: teal800(context),
            ),
          ),
        ),
      ],
    );
  }
}

class NoCompassFound extends StatelessWidget {
  const NoCompassFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NeumorphicIcon(
          Icons.warning_rounded,
          size: 50.w,
          style: NeumorphicStyle(
            depth: 10,
            color: teal800(context),
            lightSource: LightSource.topLeft,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            translation(context).no_compass_sensor_tr,
            style: GoogleFonts.cairo(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: teal800(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            translation(context).msg_no_compass_sensor_tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: teal800(context),
            ),
          ),
        ),
      ],
    );
  }
}