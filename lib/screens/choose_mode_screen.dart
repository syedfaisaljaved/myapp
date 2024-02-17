import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/screens/intro_screens.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:type_text/type_text.dart';

class ChooseModeScreen extends StatefulWidget {
  const ChooseModeScreen({Key? key}) : super(key: key);

  @override
  State<ChooseModeScreen> createState() => _ChooseModeScreenState();
}

class _ChooseModeScreenState extends State<ChooseModeScreen> {
  int _currentIndex = 0;
  bool _selected = false;
  bool _showContinueButton = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {

      if (timer.tick < 3) {
        _selected = !_selected;
        if (_selected) {
          _currentIndex = 1;
        } else {
          _currentIndex = 0;
        }
      } else {
        timer.cancel();
        _showContinueButton = true;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Mode> modes = [
      Mode(
        name: "Proxi",
        color: _selected ? teal800(context) : Colors.orange,
        image: "assets/proxi_sense.svg"
      ),
      Mode(
        name: "Pocket",
        color: teal800(context),
        image: "assets/pocket mode.svg"
      )
    ];
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TypeText(
                  modes[_currentIndex].name,
                  style: GoogleFonts.poppins(
                    color: modes[_currentIndex].color,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
                Text(
                  "Sense",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 3,
                      color: modes[_currentIndex].color,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Mode",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 3,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NeumorphicSwitch(
                      style: NeumorphicSwitchStyle(
                        activeThumbColor: teal800(context),
                        activeTrackColor: teal800(context).withOpacity(0.3),
                      ),
                      height: 8.h,
                      duration: const Duration(milliseconds: 100),
                      isEnabled: true,
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            _currentIndex = 1;
                          } else {
                            _currentIndex = 0;
                          }
                          _selected = value;
                        });
                      },
                      value: _selected,
                    ),
                    if (_showContinueButton)
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        height: 8.h,
                        width: 8.h,
                        child: NeumorphicFloatingActionButton(
                          style: const NeumorphicStyle(
                            color: Colors.black87,
                            shadowDarkColor: Colors.black87,
                          ),
                          mini: false,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            HiveProvider.mode = _currentIndex.toString();
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      OnboardingScreens(
                                    mode: _currentIndex.toString(),
                                  ),
                                ));
                          },
                        ),
                      )
                  ],
                ),
                SizedBox(height: 1.h,),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(_currentIndex == 1? 30.w : 10.w, 30.h),
            child: FadeAnimation(
              key: ObjectKey(_currentIndex),
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                modes[_currentIndex].image,
                height: 100.w,
                width: 100.w,
                color: modes[_currentIndex].color.withOpacity(0.3),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class Mode {
  final String name;
  final Color color;
  final String image;

  Mode({required this.name, required this.color, required this.image});
}
