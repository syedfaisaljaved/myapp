import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/model/remote_config.dart';
import 'package:rakaat_tracker/screens/base_screen.dart';
import 'package:rakaat_tracker/screens/choose_mode_screen.dart';
import 'package:rakaat_tracker/screens/update_app_screen.dart';
import 'package:rakaat_tracker/widgets/icon_path.dart';
import 'package:rakaat_tracker/screens/intro_screens.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool run = true;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () async {
        HiveProvider.rakaatScreenAnimCompleted = false;

        try {
          HiveProvider.compassAvailable =
              await SensorManager().isSensorAvailable(Sensors.MAGNETIC_FIELD);
          HiveProvider.proximityAvailable =
              await SensorManager().isSensorAvailable(8);
        } catch (e) {}

        RemoteConfigModel remoteConfig = await checkForAppUpdate();

        if (mounted) {
          if (remoteConfig.updateRequired) {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        UpdateApp(
                          remoteConfig: remoteConfig,
                        )));
            return;
          }

          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HiveProvider.onBoardingCompleted
                        ? const BaseScreen()
                        : HiveProvider.proximityAvailable
                            ? const ChooseModeScreen()
                            : const OnboardingScreens(
                                mode: "PocketSense",
                              ),
              ));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor(context),
      body: SafeArea(
        child: logo(context),
      ),
    );
  }

  Widget logo(BuildContext context) {
    return Center(
      child: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.1),
        endOffset: const Offset(0, 0),
        slideDuration: const Duration(milliseconds: 500),
        child: Column(
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(
            //   flex: 3,
            // ),
            Hero(
              tag: "icon",
              child: Neumorphic(
                style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.path(IconProvider()),
                ),
                child: SvgPicture.asset(
                  NeumorphicTheme.isUsingDark(context)
                      ? "assets/salat_icon_new_night.svg"
                      : "assets/salat_icon_new.svg",
                  height: 80.w,
                  width: 80.w,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              translation(context).app_name_tr,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w900,
                fontSize: 24.sp,
                color: teal800(context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                translation(context).app_slogan_tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.normal,
                  fontSize: 16.sp,
                  color: teal800(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
