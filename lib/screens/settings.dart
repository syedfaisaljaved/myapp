import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/screens/instructions_screen.dart';
import 'package:rakaat_tracker/screens/intro_screens.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:rakaat_tracker/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(HiveProvider.box_auth).listenable(),
      builder: (context, value, child) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text(
              translation(context).night_mode_tr,
              style: GoogleFonts.cairo(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context),
              ),
            ),
            trailing: NeumorphicSwitch(
              height: 24.sp,
              style: NeumorphicSwitchStyle(
                inactiveThumbColor: baseColor(context),
                inactiveTrackColor: baseColor(context),
                activeThumbColor: baseColor(context),
                activeTrackColor: teal800(context),
              ),
              value: NeumorphicTheme.isUsingDark(context),
              onChanged: (value) async {
                // await getLightVibration();

                if (context.mounted) {
                  HiveProvider.nightModeEnabled =
                      !NeumorphicTheme.isUsingDark(context);
                  NeumorphicTheme.of(context)?.themeMode =
                      NeumorphicTheme.isUsingDark(context)
                          ? ThemeMode.light
                          : ThemeMode.dark;
                }
              },
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text(
              translation(context).vibration_tr,
              style: GoogleFonts.cairo(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context),
              ),
            ),
            trailing: NeumorphicSwitch(
              height: 24.sp,
              style: NeumorphicSwitchStyle(
                inactiveThumbColor: baseColor(context),
                inactiveTrackColor: baseColor(context),
                activeThumbColor: baseColor(context),
                activeTrackColor: teal800(context),
              ),
              value: HiveProvider.vibrationEnabled,
              onChanged: (value) async {
                HiveProvider.vibrationEnabled = !HiveProvider.vibrationEnabled;
                // await getLightVibration();
              },
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text(
              translation(context).hide_sajda_tr,
              style: GoogleFonts.cairo(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context),
              ),
            ),
            trailing: NeumorphicSwitch(
              height: 24.sp,
              style: NeumorphicSwitchStyle(
                inactiveThumbColor: baseColor(context),
                inactiveTrackColor: baseColor(context),
                activeThumbColor: baseColor(context),
                activeTrackColor: teal800(context),
              ),
              value: HiveProvider.hideSujoodCounter,
              onChanged: (value) async {
                // await getLightVibration();

                HiveProvider.hideSujoodCounter =
                    !HiveProvider.hideSujoodCounter;
              },
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text(
              translation(context).sajda_interval_tr,
              style: GoogleFonts.cairo(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                squareButton(
                  context,
                  Icons.remove_rounded,
                  () async {
                    // await getLightVibration();

                    if (HiveProvider.intervalSujood < 1) {
                      return;
                    }
                    HiveProvider.intervalSujood =
                        HiveProvider.intervalSujood - 1;
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    "${HiveProvider.intervalSujood}s",
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 19.sp,
                      color: teal800(context),
                    ),
                  ),
                ),
                squareButton(
                  context,
                  Icons.add_rounded,
                  () async {
                    // await getLightVibration();

                    if (HiveProvider.intervalSujood > 9) {
                      return;
                    }
                    HiveProvider.intervalSujood =
                        HiveProvider.intervalSujood + 1;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Divider(
            height: 10,
            thickness: 1,
            color: teal800(context),
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              translation(context).instructions_tr,
              style: GoogleFonts.cairo(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context),
              ),
            ),
          ),
          ListTile(
              onTap: () async {
                // await getLightVibration();

                if (context.mounted) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const InstructionsScreen(
                          proxiSense: true,
                        ),
                      ));
                }
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                translation(context).proxi_tr,
                style: GoogleFonts.cairo(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: teal800(context),
                ),
              ),
              trailing: Neumorphic(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                style: NeumorphicStyle(
                    color: baseColor(context),
                    depth: 5,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(5))),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: teal800(context),
                ),
              )),
          ListTile(
              onTap: () async {
                // await getLightVibration();

                if (context.mounted) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const InstructionsScreen(
                          proxiSense: false,
                        ),
                      ));
                }
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                translation(context).pocket_tr,
                style: GoogleFonts.cairo(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: teal800(context),
                ),
              ),
              trailing: Neumorphic(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                style: NeumorphicStyle(
                    color: baseColor(context),
                    depth: 5,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(5))),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: teal800(context),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
          Divider(
            height: 10,
            thickness: 1,
            color: teal800(context),
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Help Us Improve",
              style: GoogleFonts.cairo(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            alignment: Alignment.centerLeft,
            child: NeumorphicButton(
              onPressed: () {
                openEmailApp();
              },
              provideHapticFeedback: HiveProvider.vibrationEnabled,
              style: NeumorphicStyle(
                color: tealWhite(context),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.feedback_rounded,
                    color: Color(0xFFD7D7CC),
                  ),
                  const SizedBox(width: 8,),
                  Text(
                    "Give Feedback",
                    style: GoogleFonts.cairo(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD7D7CC),
                      height: 1.5
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
