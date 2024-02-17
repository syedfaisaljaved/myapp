import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget circleButton(BuildContext context, IconData icon, VoidCallback onPressed,
    [NeumorphicShape shape = NeumorphicShape.flat]) =>
    NeumorphicButton(
      padding: EdgeInsets.all(11.sp),
      style: NeumorphicStyle(
          color: baseColor(context),
          depth: 5,
          shape: shape,
          boxShape: const NeumorphicBoxShape.circle()),
      onPressed: onPressed,
      provideHapticFeedback: HiveProvider.vibrationEnabled,
      child: Icon(
        icon,
        size: 20.sp,
        color: teal800(context),
      ),
    );

Widget squareButton(BuildContext context, IconData icon,
    VoidCallback? onPressed,
    [NeumorphicShape shape = NeumorphicShape.flat]) =>
    NeumorphicButton(
      margin: const EdgeInsets.all(4),
      padding: EdgeInsets.all(9.sp),
      style: NeumorphicStyle(
          color: baseColor(context),
          depth: 5,
          shape: shape,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5))),
      onPressed: onPressed,
      provideHapticFeedback: HiveProvider.vibrationEnabled,
      child: Icon(
        icon,
        color: teal800(context),
        size: 20.sp,
      ),
    );

Widget disclaimerModalWidget(BuildContext context, bool dontShowAgain,
    {required String text1,
      required String text2,
      required String buttonText,
      required bool compassDialog}) =>
    StatefulBuilder(
      builder: (context, setState) =>
          ListView(
            physics: const ClampingScrollPhysics(),
            primary: true,
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            shrinkWrap: true,
            children: [
              NeumorphicIcon(
                Icons.warning_rounded,
                size: 50.sp,
                style: NeumorphicStyle(
                  depth: 10,
                  color: teal800(context),
                  lightSource: LightSource.topLeft,
                  shape: NeumorphicShape.concave,
                  boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: teal800(context),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                child: Text(
                  text2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: teal800(context),
                  ),
                ),
              ),
              NeumorphicButton(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                margin: const EdgeInsets.all(10),
                style: NeumorphicStyle(
                  color: teal800(context),
                  depth: 5,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      30,
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: baseColor(context),
                      fontSize: 16.sp),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: NeumorphicCheckbox(
                        padding: const EdgeInsets.all(4),
                        style: NeumorphicCheckboxStyle(
                          selectedColor: teal800(context),
                          disabledColor: baseColor(context),
                        ),
                        value: dontShowAgain,
                        onChanged: (value) {
                          setState(() {
                            dontShowAgain = value;
                            if (compassDialog) {
                              HiveProvider.dontShowCompassDialog = value;
                            } else {
                              HiveProvider.dontShowDialog = value;
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      translation(context).dont_show_again_tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          color: teal800(context),
                          fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
    );

Widget roundedButton({
  required BuildContext context,
  VoidCallback? onPressed,
  required String text,
  EdgeInsets? padding,
  EdgeInsets margin = const EdgeInsets.all(10),
}) =>
    NeumorphicButton(
      padding:
      padding ?? EdgeInsets.symmetric(horizontal: 22.sp, vertical: 11.sp),
      margin: margin,
      style: NeumorphicStyle(
        color: baseColor(context),
        depth: 5,
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(
            30.sp,
          ),
        ),
      ),
      onPressed: onPressed,
      provideHapticFeedback: HiveProvider.vibrationEnabled,
      child: Text(
        text,
        style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: teal800(context),
            fontSize: 16.sp),
      ),
    );

Widget disableListGlow({required Widget child}) =>
    NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return false;
        },
        child: child);

Widget bottomSheetSliderIcon(
    {required BuildContext context, required Widget child}) =>
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: teal800(context),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Flexible(child: child),
      ],
    );

/// rakaat counter body
Widget rakaatCounterBodyUI(BuildContext context,
    {required int rakaat,
      required int sujood,
      required bool hideButtons,
    bool start = false,
    VoidCallback? onStartButtonPressed}) =>
    Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(
            flex: 1,
          ),
          Text(
            rakaat.toString(),
            style: GoogleFonts.lato(
              fontSize: 60.sp,
              fontWeight: FontWeight.bold,
              color: teal800(context)
                  .withOpacity(
                  NeumorphicTheme.isUsingDark(context) ? 0.5 : 1.0),
            ),
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: !hideButtons,
            child: Neumorphic(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 11.sp),
              margin: const EdgeInsets.all(10),
              style: NeumorphicStyle(
                color: baseColor(context),
                depth: 5,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(
                    30.sp,
                  ),
                ),
              ),
              child: Text(
                translation(context).rakaat_tr,
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    color: teal800(context),
                    fontSize: 16.sp),
              ),
            ),
          ),
          if (!HiveProvider.hideSujoodCounter && sujood != -1)
            Text(
              sujood.toString(),
              style: GoogleFonts.lato(
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                color: teal800(context).withOpacity(
                    NeumorphicTheme.isUsingDark(context) ? 0.5 : 1.0),
              ),
            ),
          if (!HiveProvider.hideSujoodCounter && sujood != -1)
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: !hideButtons,
              child: Neumorphic(
                padding: EdgeInsets.symmetric(
                    horizontal: 22.sp, vertical: 11.sp),
                margin: const EdgeInsets.all(10),
                style: NeumorphicStyle(
                  color: baseColor(context),
                  depth: 5,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(
                      30.sp,
                    ),
                  ),
                ),
                child: Text(
                  translation(context).sujood_tr,
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: teal800(context),
                      fontSize: 16.sp),
                ),
              ),
            ),
          if(sujood == -1)
            const Spacer(flex:3),
          if(sujood == -1)
            NeumorphicButton(
              onPressed: onStartButtonPressed,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              style: NeumorphicStyle(
                depth: 5,
                color: tealWhite(context),
                boxShape: const NeumorphicBoxShape.stadium()
              ),
              child: Text(start ? translation(context).keep_device_pockets : translation(context).start,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD7D7CC),
                ),
              ),
            ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );


Widget sizedActionWidget({Widget? child}) =>
    Center(
      child: SizedBox(
        height: 30.sp,
        width: 30.sp,
        child: child,
      ),
    );

EdgeInsets buttonPadding() => EdgeInsets.all(16.sp);