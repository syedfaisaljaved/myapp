import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/screens/base_screen.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/concentric_pageview.dart';

class OnboardingScreens extends StatefulWidget {
  final bool openOnClick;
  final String mode;

  const OnboardingScreens({Key? key, this.openOnClick = false, this.mode = "0"})
      : super(key: key);

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  int _currentPage = 0;
  late List<PageData> pages;

  @override
  Widget build(BuildContext context) {
    if(widget.mode == "0") {
      pages = [
      PageData(
        icon: "assets/prayer_mat.svg",
        title: translation(context).mode_0_title_1_tr,
        bgColor: baseColor(context),
        textColor: teal800(context),
      ),
      PageData(
        icon: "assets/phone_below_chin.svg",
        title: translation(context).mode_0_title_2_tr,
        bgColor: teal800(context),
        textColor: baseColor(context),
      ),
    ];
    } else {
      pages = [
        PageData(
          icon: "assets/pocket mode.svg",
          title: translation(context).mode_1_title_1_tr,
          bgColor: baseColor(context),
          textColor: teal800(context),
        ),
        PageData(
          icon: "assets/phone_speaker.svg",
          title: translation(context).mode_1_title_2_tr,
          bgColor: teal800(context),
          textColor: baseColor(context),
        ),
      ];
    }

    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: 10.w,
        onChange: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        nextButtonBuilder: (context) => _currentPage == 1
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  widget.openOnClick ? translation(context).end_tr : translation(context).go_tr,
                  style: GoogleFonts.poppins(
                    color: teal800(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 3), // visual center
                child: Icon(
                  Icons.navigate_next,
                  size: 8.w,
                ),
              ),
        opacityFactor: 1,
        itemCount: pages.length,
        verticalPosition: 0.85,
        onFinish: () {
          HiveProvider.onBoardingCompleted = true;
          if (widget.openOnClick) {
            Navigator.pop(context);
          } else {

            if(!HiveProvider.proximityAvailable){
              HiveProvider.mode = "1";
            }

            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const BaseScreen(),
              ),
            );
          }
        },
        // physics: const NeverScrollableScrollPhysics(),
        duration: const Duration(milliseconds: 500),
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(
              page: page,
            ),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final String icon;
  Color bgColor;
  Color textColor;

  PageData({
    this.title,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8.h,
        ),
        Neumorphic(
          padding: const EdgeInsets.all(50),
          style: NeumorphicStyle(
            depth: 15,
            color: page.bgColor,
            shape: NeumorphicShape.concave,
            shadowLightColor: page.bgColor,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          ),
          child: SizedBox(
            width: 60.w,
            height: 60.w,
            child: Center(
              child: SvgPicture.asset(
                page.icon,
                width: 60.w,
                color: page.textColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            page.title ?? '',
            style: GoogleFonts.poppins(
              color: page.textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
