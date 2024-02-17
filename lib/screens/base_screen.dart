import 'dart:async';
import 'dart:io';

import 'package:advanced_in_app_review/advanced_in_app_review.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/ads/applovin.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/main.dart';
import 'package:rakaat_tracker/util/constants.dart';
import 'package:rakaat_tracker/widgets/no_proximity_sensor.dart';
import 'package:rakaat_tracker/screens/qibla_direction.dart';
import 'package:rakaat_tracker/screens/rakaat_tracker_screen.dart';
import 'package:rakaat_tracker/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:rakaat_tracker/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int pressedButton = 1;
  bool hideEverything = false;
  late StreamController<int> _buttonController;
  late StreamController<bool> _translationController;
  late PageController _pageController;
  late PageController _screenController;
  String _selectedLang = HiveProvider.locale;
  String _selectedMode = HiveProvider.mode;

  @override
  void initState() {
    /// in app review
    try{
      AdvancedInAppReview()
          .setMinDaysBeforeRemind(7)
          .setMinDaysAfterInstall(2)
          .setMinLaunchTimes(2)
          .setMinSecondsBeforeShowDialog(5)
          .monitor();
    } catch(e){}

    _buttonController = StreamController<int>.broadcast();
    _translationController = StreamController<bool>.broadcast();
    _pageController = PageController();
    _screenController = PageController();
    _pageController.addListener(() {
      if (_pageController.hasClients &&
          (_pageController.page ?? 0) == 0 &&
          hideEverything) {
        setState(() {
          hideEverything = false;
        });
      } else if (_pageController.hasClients &&
          (_pageController.page ?? 0) == 1 &&
          !hideEverything) {
        setState(() {
          hideEverything = true;
        });
      }
    });

    if (HiveProvider.proximityAvailable && !HiveProvider.dontShowDialog) {
      Future.delayed(const Duration(milliseconds: 1000), () async {
        await getBottomSheet(
          context,
          disableListGlow(
            child: bottomSheetSliderIcon(
              context: context,
              child: disclaimerModalWidget(context, HiveProvider.dontShowDialog,
                  text1: "Important!",
                  text2:
                      "If this app causes a distraction in salah then you should not use it. You can also consult with a local scholar/imam/da'i regarding regarding the permissibility of this app.",
                  buttonText: "I Accept",
                  compassDialog: false),
            ),
          ),
        );
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _buttonController.close();
    _translationController.close();
    _pageController.dispose();
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      TrackerScreen(pageController: _pageController),
      HiveProvider.compassAvailable
          ? const QiblaDirection()
          : const NoCompassFound(),
      const Settings()
    ];
    return Scaffold(
      appBar: NeumorphicAppBar(
        automaticallyImplyLeading: false,
        leading: hideEverything
            ? sizedActionWidget(
                child: NeumorphicButton(
                  padding: EdgeInsets.all(14.sp),
                  style: NeumorphicStyle(
                      color: baseColor(context),
                      depth: 5,
                      shape: NeumorphicShape.concave),
                  onPressed: () async {
                    // await getLightVibration();

                    _pageController.previousPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.linearToEaseOut);
                  },
                  provideHapticFeedback: HiveProvider.vibrationEnabled,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: teal800(context),
                  ),
                ),
              )
            : null,
        centerTitle: true,
        actions: _appBarActions(context),
        textStyle: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: teal800(context),
            fontSize: 22.sp),
        title: hideEverything
            ? null
            : GestureDetector(
                onTap: kReleaseMode
                    ? null
                    : () {
                        AppLovinMAX.showMediationDebugger();
                      },
                child: Text(
                  translation(context).app_name_tr,
                ),
              ),
      ),
      backgroundColor: baseColor(context),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: true,
        controller: _screenController,
        children: screens,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: (Platform.isIOS ? MediaQuery.of(context).padding.bottom : 0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            hideEverything
                ? const SizedBox.shrink()
                : StreamBuilder<int>(
                    stream: _buttonController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        pressedButton = snapshot.data!;
                        _screenController.jumpToPage(snapshot.data! - 1);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DelayedDisplay(
                              fadeIn: true,
                              slidingCurve: Curves.bounceOut,
                              delay: const Duration(milliseconds: 200),
                              fadingDuration: const Duration(milliseconds: 400),
                              child: NeumorphicButton(
                                tooltip: "Rakaat Tracker",
                                padding: buttonPadding(),
                                style:
                                    buttonNeumorphicStyle(pressedButton == 1),
                                onPressed: () async {

                                  AppLovinMAX.isInterstitialReady(
                                      ApplovinAdSdk.instance.interstitialAdUnitID)
                                      .then((isReady) {
                                    if (isReady!) {
                                      AppLovinMAX.showInterstitial(
                                          ApplovinAdSdk.instance.interstitialAdUnitID);
                                    } else {
                                      debugPrint('Loading interstitial ad...');
                                      ApplovinAdSdk.instance.interstitialLoadState =
                                          AdLoadState.loading;
                                      AppLovinMAX.loadInterstitial(
                                          ApplovinAdSdk.instance.interstitialAdUnitID);
                                    }
                                  }).then((value) {
                                    _buttonController.add(1);
                                    _translationController.add(false);
                                  });

                                },
                                provideHapticFeedback:
                                    HiveProvider.vibrationEnabled,
                                pressed: pressedButton == 1,
                                child: SvgPicture.asset(
                                  "assets/tracker_icon.svg",
                                  color: teal800(context),
                                  height: 21.sp,
                                ),
                              ),
                            ),
                            DelayedDisplay(
                              fadeIn: true,
                              slidingCurve: Curves.bounceOut,
                              delay: const Duration(milliseconds: 400),
                              fadingDuration: const Duration(milliseconds: 400),
                              child: NeumorphicButton(
                                tooltip: "Qibla Direction",
                                padding: buttonPadding(),
                                style:
                                    buttonNeumorphicStyle(pressedButton == 2),
                                onPressed: () async {

                                  AppLovinMAX.isInterstitialReady(
                                      ApplovinAdSdk.instance.interstitialAdUnitID)
                                      .then((isReady) {
                                    if (isReady!) {
                                      AppLovinMAX.showInterstitial(
                                          ApplovinAdSdk.instance.interstitialAdUnitID);
                                    } else {
                                      debugPrint('Loading interstitial ad...');
                                      ApplovinAdSdk.instance.interstitialLoadState =
                                          AdLoadState.loading;
                                      AppLovinMAX.loadInterstitial(
                                          ApplovinAdSdk.instance.interstitialAdUnitID);
                                    }
                                  }).then((value) {
                                    _buttonController.add(2);
                                    _translationController.add(false);
                                  });

                                },
                                provideHapticFeedback:
                                    HiveProvider.vibrationEnabled,
                                pressed: pressedButton == 2,
                                child: SvgPicture.asset(
                                  'assets/qibla_icon.svg',
                                  color: teal800(context),
                                  height: 20.sp,
                                ),
                              ),
                            ),
                            DelayedDisplay(
                              fadeIn: true,
                              slidingCurve: Curves.bounceOut,
                              delay: const Duration(milliseconds: 600),
                              fadingDuration: const Duration(milliseconds: 400),
                              child: NeumorphicButton(
                                tooltip: "Settings",
                                padding: buttonPadding(),
                                style:
                                    buttonNeumorphicStyle(pressedButton == 3),
                                onPressed: () async {

                                  AppLovinMAX.isInterstitialReady(
                                      ApplovinAdSdk.instance.interstitialAdUnitID)
                                      .then((isReady) {
                                    if (isReady!) {
                                      AppLovinMAX.showInterstitial(
                                          ApplovinAdSdk.instance.interstitialAdUnitID);
                                    } else {
                                      debugPrint('Loading interstitial ad...');
                                      ApplovinAdSdk.instance.interstitialLoadState =
                                          AdLoadState.loading;
                                      AppLovinMAX.loadInterstitial(
                                          ApplovinAdSdk.instance.interstitialAdUnitID);
                                    }
                                  }).then((value) {
                                    _buttonController.add(3);
                                    _translationController.add(true);
                                  });

                                },
                                provideHapticFeedback:
                                    HiveProvider.vibrationEnabled,
                                pressed: pressedButton == 3,
                                child: SvgPicture.asset(
                                  'assets/settings_icon.svg',
                                  color: teal800(context),
                                  height: 20.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
            if ((HiveProvider.mode == "0" && !hideEverything) ||
                HiveProvider.mode == "1")
              MaxAdView(
                  adUnitId: ApplovinAdSdk.instance.bannerAdUnitID,
                  adFormat: AdFormat.banner,
                  listener: ApplovinAdSdk.instance.bannerListener),
          ],
        ),
      ),
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    return [
      if (hideEverything)
        sizedActionWidget(
          child: NeumorphicButton(
            padding: EdgeInsets.all(14.sp),
            style: NeumorphicStyle(
                color: baseColor(context),
                depth: 5,
                shape: NeumorphicShape.concave),
            onPressed: () async {
              // await getLightVibration();

              HiveProvider.reset = true;
            },
            provideHapticFeedback: HiveProvider.vibrationEnabled,
            child: Icon(
              Icons.restart_alt_rounded,
              color: teal800(context),
            ),
          ),
        ),
      if (!hideEverything)
        StreamBuilder<bool>(
            stream: _translationController.stream,
            builder: (context, snapshot) {
              bool showTranslateButton = false;
              if (snapshot.hasData) {
                showTranslateButton = snapshot.data!;
              }
              if (showTranslateButton) {
                return sizedActionWidget(
                  child: NeumorphicButton(
                    padding: EdgeInsets.all(14.sp),
                    style: NeumorphicStyle(
                        color: baseColor(context),
                        depth: 5,
                        shape: NeumorphicShape.concave),
                    onPressed: () async {
                      // await getLightVibration();

                      if (context.mounted) {
                        await getBottomSheet(context, getTranslatedLangWidget())
                            .whenComplete(() {
                          AppLovinMAX.isInterstitialReady(
                                  ApplovinAdSdk.instance.interstitialAdUnitID)
                              .then((isReady) {
                            if (isReady!) {
                              AppLovinMAX.showInterstitial(
                                  ApplovinAdSdk.instance.interstitialAdUnitID);
                            } else {
                              debugPrint('Loading interstitial ad...');
                              ApplovinAdSdk.instance.interstitialLoadState =
                                  AdLoadState.loading;
                              AppLovinMAX.loadInterstitial(
                                  ApplovinAdSdk.instance.interstitialAdUnitID);
                            }
                          }).then((value) {
                            MyApp.setLocale(context, Locale(_selectedLang));
                          });

                        });
                      }
                    },
                    provideHapticFeedback: HiveProvider.vibrationEnabled,
                    child: SvgPicture.asset(
                      "assets/transalate_icon.svg",
                      color: teal800(context),
                    ),
                  ),
                );
              }
              if (pressedButton == 1) {
                return sizedActionWidget(
                  child: NeumorphicButton(
                    tooltip: "Prayer Modes",
                    padding: buttonPadding(),
                    style: NeumorphicStyle(
                        color: baseColor(context),
                        depth: 5,
                        shape: NeumorphicShape.concave),
                    onPressed: () async {
                      if (context.mounted) {
                        await getBottomSheet(context, getModeWidget())
                            .whenComplete(() {
                          AppLovinMAX.isInterstitialReady(
                                  ApplovinAdSdk.instance.interstitialAdUnitID)
                              .then((isReady) {
                            if (isReady!) {
                              AppLovinMAX.showInterstitial(
                                  ApplovinAdSdk.instance.interstitialAdUnitID);
                            } else {
                              debugPrint('Loading interstitial ad...');
                              ApplovinAdSdk.instance.interstitialLoadState =
                                  AdLoadState.loading;
                              AppLovinMAX.loadInterstitial(
                                  ApplovinAdSdk.instance.interstitialAdUnitID);
                            }
                          }).then((value) {
                            HiveProvider.mode = _selectedMode;
                          });
                        });
                      }
                    },
                    provideHapticFeedback: HiveProvider.vibrationEnabled,
                    child: SvgPicture.asset(
                      "assets/modes-salah-icon.svg",
                      color: teal800(context),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
    ];
  }

  NeumorphicStyle buttonNeumorphicStyle(bool enableBorder) {
    return NeumorphicStyle(
      color: baseColor(context),
      depth: 5,
      shape: NeumorphicShape.concave,
      border: NeumorphicBorder(
          isEnabled: enableBorder, width: 1, color: teal800(context)),
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(10),
      ),
    );
  }

  Widget getModeWidget() {
    final modes = [
      translation(context).proxi_tr,
      translation(context).pocket_tr
    ];
    return StatefulBuilder(
      builder: (context, setState) => Scrollbar(
        thumbVisibility: true,
        thickness: 5,
        radius: const Radius.circular(50),
        child: disableListGlow(
          child: bottomSheetSliderIcon(
            context: context,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              primary: true,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              shrinkWrap: true,
              children: modes
                  .map(
                    (e) => ListTile(
                      contentPadding: EdgeInsets.all(12.sp),
                      leading: NeumorphicRadio(
                        style: NeumorphicRadioStyle(
                          selectedColor: teal800(context),
                          unselectedColor: baseColor(context),
                        ),
                        onChanged: (value) async {
                          if (!HiveProvider.proximityAvailable &&
                              e == translation(context).proxi_tr) {
                            Fluttertoast.showToast(
                                msg: translation(context).feature_un_tr);
                            return;
                          }

                          // await getLightVibration();

                          HiveProvider.mode == modes.indexOf(e).toString();

                          setState(() {
                            _selectedMode = modes.indexOf(e).toString();
                          });
                        },
                        value: modes.indexOf(e).toString(),
                        groupValue: _selectedMode,
                        isEnabled: true,
                        child: SizedBox(
                          height: 30.sp,
                          width: 30.sp,
                          child: Center(
                            child: Icon(
                              (!HiveProvider.proximityAvailable &&
                                      e == translation(context).proxi_tr)
                                  ? Icons.do_not_disturb_on_outlined
                                  : _selectedMode == modes.indexOf(e).toString()
                                      ? Icons.check
                                      : Icons.circle_outlined,
                              color:
                                  _selectedMode == modes.indexOf(e).toString()
                                      ? baseColor(context)
                                      : teal800(context),
                            ),
                          ),
                        ),
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NeumorphicText(
                            e.toString(),
                            style: NeumorphicStyle(
                              color: teal800(context),
                            ),
                            textAlign: TextAlign.left,
                            textStyle: NeumorphicTextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.cairo().fontFamily,
                            ),
                          ),
                          if ((e != translation(context).proxi_tr) ||
                              (!HiveProvider.proximityAvailable &&
                                  e == translation(context).proxi_tr))
                            Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: teal800(context),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                (!HiveProvider.proximityAvailable &&
                                        e == translation(context).proxi_tr)
                                    ? translation(context).unavailable_tr
                                    : translation(context).new_tr,
                                style: GoogleFonts.cairo(
                                    color: baseColor(context),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTranslatedLangWidget() => StatefulBuilder(
        builder: (context, setState) => bottomSheetSliderIcon(
          context: context,
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 5,
            radius: const Radius.circular(50),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              shrinkWrap: true,
              children: AppLocalizations.supportedLocales
                  .map((e) => ListTile(
                        contentPadding: EdgeInsets.all(12.sp),
                        leading: NeumorphicRadio(
                          style: NeumorphicRadioStyle(
                            selectedColor: teal800(context),
                            unselectedColor: baseColor(context),
                          ),
                          onChanged: (value) async {
                            // await getLightVibration();

                            HiveProvider.locale = e.toString();
                            setState(() {
                              _selectedLang = e.toString();
                            });
                          },
                          value: e.toString(),
                          groupValue: _selectedLang,
                          isEnabled: true,
                          child: SizedBox(
                            height: 30.sp,
                            width: 30.sp,
                            child: Center(
                              child: Icon(
                                _selectedLang == e.toString()
                                    ? Icons.check
                                    : Icons.circle_outlined,
                                color: _selectedLang == e.toString()
                                    ? baseColor(context)
                                    : teal800(context),
                              ),
                            ),
                          ),
                        ),
                        title: NeumorphicText(
                          getCountryName(e.toString()),
                          style: NeumorphicStyle(
                            color: teal800(context),
                          ),
                          textAlign: TextAlign.left,
                          textStyle: NeumorphicTextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.cairo().fontFamily,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      );
}
