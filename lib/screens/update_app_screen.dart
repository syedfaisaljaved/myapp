import 'dart:io';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/model/remote_config.dart';
import 'package:rakaat_tracker/screens/base_screen.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:rakaat_tracker/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateApp extends StatelessWidget {
  final RemoteConfigModel remoteConfig;

  const UpdateApp({Key? key, required this.remoteConfig}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicIcon(
              Icons.update_rounded,
              size: 50.w,
              style: NeumorphicStyle(
                depth: 10,
                color: teal800(context),
                lightSource: LightSource.topLeft,
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                translation(context).update_app_tr,
                style: GoogleFonts.cairo(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  color: teal800(context),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
              child: Text(
                translation(context).msg_update_app_tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: teal800(context),
                ),
              ),
            ),
            roundedButton(
              context: context,
              text: translation(context).update_tr,
              onPressed: () {
                final appId = Platform.isAndroid ? 'com.fj.salah.rakaat.tracker' : 'YOUR_IOS_APP_ID';
                final url = Uri.parse(
                  Platform.isAndroid
                      ? "market://details?id=$appId"
                      : "https://apps.apple.com/app/id$appId",
                );
                launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              },
              margin: EdgeInsets.only(top: 10.w, bottom: 12),
            ),
            if (Platform.isIOS
                ? remoteConfig.optionalIos
                : remoteConfig.optional)
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: NeumorphicButton(
                    style: NeumorphicStyle(
                        color: baseColor(context),
                        shape: NeumorphicShape.flat,
                        depth: 0),
                    child: Text(
                      translation(context).skip_update_app_tr,
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.normal,
                          color: teal800(context),
                          fontSize: 15.sp),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const BaseScreen()));
                    },
                  )),
          ],
        ),
      ),
    );
  }
}
