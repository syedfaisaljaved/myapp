import 'dart:async';
import 'package:applovin_max/applovin_max.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:rakaat_tracker/ads/applovin.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/util/constants.dart';
import 'package:rakaat_tracker/widgets/icon_path.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:rakaat_tracker/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TrackerScreen extends StatefulWidget {
  final PageController pageController;

  const TrackerScreen({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  bool clickedTaraweeh = false;
  late bool animationStart;
  late StreamController<int> _streamController;
  int taraweehCount = 8;
  int count = 0;

  @override
  void initState() {
    animationStart = !HiveProvider.rakaatScreenAnimCompleted;
    HiveProvider.rakaatScreenAnimCompleted = true;
    _streamController = StreamController<int>.broadcast();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.pageController,
      children: [
        FrontScreen(context),
        if (HiveProvider.mode == "0")
          ProximityMode(
            count: count,
          ),
        if (HiveProvider.mode == "1")
          PocketMode(
            count: count,
          ),
      ],
    );
  }

  Widget FrontScreen(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Hero(
              tag: "icon",
              child: Container(
                margin: const EdgeInsets.only(bottom: 22),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.path(IconProvider()),
                  ),
                  child: SvgPicture.asset(
                    NeumorphicTheme.isUsingDark(context)
                        ? "assets/salat_icon_new_night.svg"
                        : "assets/salat_icon_new.svg",
                    height: 70.w,
                    width: 70.w,
                  ),
                ),
              ),
            );
          },
        ),
        DelayedDisplay(
            fadeIn: true,
            delay: Duration(milliseconds: animationStart ? 400 : 0),
            fadingDuration: const Duration(milliseconds: 1000),
            child: centerBody(context)),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }

  Widget centerBody(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 25.sp, left: 25.sp, bottom: 16.sp),
          child: Text(
            translation(context).choose_tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: teal800(context),
            ),
          ),
        ),
        buttonRow(context),
        customRakaatCounter(context),
      ],
    );
  }

  Widget buttonRow(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          translation(context).two_tr,
          translation(context).three_tr,
          translation(context).four_tr
        ]
            .map(
              (String text) => roundedButton(
                context: context,
                text: text,
                onPressed: () {
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
                    if (text == translation(context).two_tr) {
                      count = 2;
                    } else if (text == translation(context).three_tr) {
                      count = 3;
                    } else {
                      count = 4;
                    }

                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linearToEaseOut,
                    );
                  });
                },
              ),
            )
            .toList(),
      );

  Widget customRakaatCounter(BuildContext context) => clickedTaraweeh
      ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            circleButton(context, Icons.arrow_back_rounded, () async {
              animationStart = false;
              // await getLightVibration();

              setState(() {
                clickedTaraweeh = false;
              });
            }),
            Neumorphic(
              padding: EdgeInsets.all(9.sp),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              style: NeumorphicStyle(
                  color: baseColor(context),
                  depth: -3,
                  boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(30.sp))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  circleButton(context, Icons.remove_rounded, () async {
                    animationStart = false;
                    // await getLightVibration();

                    int val = --taraweehCount;
                    _streamController.add(val);
                    count = val;
                  }, NeumorphicShape.convex),
                  StreamBuilder<int>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data! > 0) {
                          taraweehCount = snapshot.data!;
                        }
                        return Container(
                          width: 16.w,
                          alignment: Alignment.center,
                          child: TextField(
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                color: teal800(context),
                                fontSize: 20.sp),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            controller: TextEditingController(
                                text: taraweehCount.toString()),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  taraweehCount = 0;
                                  count = taraweehCount;
                                });
                              }
                              if (RegExp(r'[0-9]').hasMatch(value)) {
                                _streamController.add(int.parse(value));
                                count = int.parse(value);
                              }
                            },
                          ),
                        );
                      }),
                  circleButton(context, Icons.add_rounded, () async {
                    animationStart = false;
                    // await getLightVibration();

                    setState(() {
                      int val = ++taraweehCount;
                      _streamController.add(val);
                      count = val;
                    });
                  }, NeumorphicShape.convex),
                ],
              ),
            ),
            circleButton(context, Icons.arrow_forward_rounded, () async {
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
                animationStart = false;

                widget.pageController.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linearToEaseOut);
              });
            }),
          ],
        )
      : roundedButton(
          context: context,
          text: translation(context).taraweeh_tr,
          onPressed: () async {
            animationStart = false;
            // await getLightVibration();

            setState(() {
              clickedTaraweeh = true;
            });
          },
          padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 11.sp),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16));
}

class ProximityMode extends StatefulWidget {
  const ProximityMode({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  State<ProximityMode> createState() => _ProximityModeState();
}

class _ProximityModeState extends State<ProximityMode> {
  int sujood = 0;
  int rakaat = 0;

  bool hideButtons = false;

  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  Future<void> listenSensor() async {
    try {
      _streamSubscription = ProximitySensor.events.listen((int event) async {
        if (event > 0 && _isNear) {
          return;
        }
        _isNear = (event > 0) ? true : false;
        if (_isNear && mounted) {
          await _streamSubscription.cancel();
          setState(() {
            sujood++;
            if (sujood > 0 && sujood % 2 != 0) {
              rakaat++;
            }
          });
          if ((sujood / 2) != widget.count) {
            Timer(Duration(seconds: HiveProvider.intervalSujood), () {
              listenSensor();
            });
          } else {
            await getVibration();
          }
        }
      });
    } catch (e) {}
  }

  void hiveListener() {
    Hive.box(HiveProvider.box_auth).listenable(keys: ["reset"]).addListener(() {
      if (mounted) {
        setState(() {
          sujood = 0;
          rakaat = 0;
        });
        listenSensor();
      }
    });
  }

  @override
  void initState() {
    listenSensor();
    hiveListener();
    if (mounted) {
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            hideButtons = true;
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 200),
      child: rakaatCounterBodyUI(context,
          rakaat: rakaat, sujood: sujood, hideButtons: hideButtons),
    );
  }
}

class PocketMode extends StatefulWidget {
  final int count;

  const PocketMode({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  State<PocketMode> createState() => _PocketModeState();
}

class _PocketModeState extends State<PocketMode> {
  double param1 = 0.71;

  double param2 = 0.8;

  double param3 = 0.21;

  double param4 = 0.1;

  double param_1 = -0.71;

  double param_2 = -0.8;

  double param_3 = -0.21;

  double param_4 = -0.1;

  bool movementUpper_1 = false;
  bool movementLower_1 = false;
  bool movementUpper_2 = false;
  bool movementLower_2 = false;

  // bool movement1 = false;
  // bool movement2 = false;

  int counter = 0;
  int rakaat = 0;

  bool start = false;
  bool takingReading = true;

  bool hideButtons = false;

  Stream<SensorEvent>? streamAccelerometer;
  late StreamSubscription<SensorEvent> _streamSubscription;
  late StreamController<int> _sensorController;

  Future<void> _start() async {
    try {
      _sensorController = StreamController<int>.broadcast();

      streamAccelerometer = await SensorManager().sensorUpdates(
        sensorId: Sensors.LINEAR_ACCELERATION,
        interval: Sensors.SENSOR_DELAY_NORMAL,
      );

      _streamSubscription = streamAccelerometer!.listen((SensorEvent event) {
        if (rakaat == widget.count) {
          return;
        }

        double XAxis = event.data[0];
        double YAxis = event.data[1];
        // double ZAxis = event.data[2];

        // double XAxisM = pow(XAxis, 2).toDouble();
        // double YAxisM = pow(YAxis, 2).toDouble();
        // double ZAxisM = pow(ZAxis, 2).toDouble();

        print("X axis - ${XAxis}");
        print("Y axis - ${YAxis}");

        if (XAxis <= param1 && XAxis >= param2) {
          movementUpper_1 = true;
        }
        if (XAxis >= param_1 && XAxis <= param_2) {
          movementUpper_1 = true;
        }
        if (XAxis >= param3 && XAxis <= param4) {
          movementLower_1 = true;
        }
        if (XAxis <= param_3 && XAxis >= param_4) {
          movementLower_1 = true;
        }
        if (YAxis >= param1 && YAxis <= param2) {
          movementUpper_2 = true;
        }
        if (YAxis <= param_1 && YAxis >= param_2) {
          movementUpper_2 = true;
        }
        if (YAxis <= param3 && YAxis >= param4) {
          movementLower_2 = true;
        }
        if (YAxis >= param_3 && YAxis <= param_4) {
          movementLower_2 = true;
        }

        print("movement upper 1 - ${movementUpper_1}");
        print("movement lower 1 - ${movementLower_1}");
        print("movement upper 2 - ${movementUpper_2}");
        print("movement lower 2 - ${movementLower_2}");

        if (movementUpper_1 && movementLower_1 ||
            movementUpper_2 && movementLower_2) {
          movementUpper_1 = false;
          movementLower_1 = false;
          movementUpper_2 = false;
          movementLower_2 = false;

          /// increment counter
          counter++;

          /// increment rakaat
          print("increment by 1");
          if (counter % 2 == 0) {
            rakaat += counter ~/ 2;
            counter = 0;
            print("rakat: ${rakaat}");
            HiveProvider.rakaatCounter += rakaat;
            _sensorController.add(rakaat);
          }
        }

        // double magnitude = sqrt(XAxisM + YAxisM + ZAxisM);

        // if (magnitude >= 7.5) {
        //   debugPrint("going to sit or stand : ${magnitude}");
        //   movement1 = true;
        //   if (counter == 1) {
        //     movement2 = false;
        //   }
        // }
        // if (magnitude < 2) {
        //   movement2 = true;
        // }
        // increaseRakaatCountByOne();
      });
    } catch (e) {}
  }

  // void increaseRakaatCountByOne() {
  //   if (movement1 && movement2) {
  //     movement1 = false;
  //     movement2 = false;
  //     counter++;
  //     if (counter > 1 && (counter % 2 != 0)) {
  //       rakaat++;
  //       HiveProvider.rakaatCounter += 1;
  //       _sensorController.add(rakaat);
  //     }
  //   }
  // }

  void hiveListener() {
    Hive.box(HiveProvider.box_auth)
        .listenable(keys: ["reset"]).addListener(() async {
      if (mounted) {
        _streamSubscription.cancel();
        setState(() {
          counter = 0;
          rakaat = 0;
          HiveProvider.rakaatCounter = 0;
          start = false;
          streamAccelerometer = null;
          // movement1 = false;
          // movement2 = false;
        });
      }
    });
  }

  final eventChannel =
      const EventChannel('com.fj.salah.rakaat.tracker/rakaat_tracker');

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    _sensorController = StreamController<int>.broadcast();

    flutterTts.setLanguage(getLanguageByCountry(HiveProvider.locale));

    eventChannel.receiveBroadcastStream().listen((dynamic event) {
      switch (event) {
        case "powerButtonPressed":
          {
            debugPrint("power button is pressed. $rakaat");
            if (rakaat != 0) {
              flutterTts.speak(rakaat.toString());
            }
          }
          break;
        default:
          break;
      }
    });

    streamAccelerometer = null;
    if (mounted) {
      hiveListener();
    }
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _sensorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 200),
      child: StreamBuilder<int>(
          stream: _sensorController.stream,
          builder: (context, snapshot) {
            return rakaatCounterBodyUI(context,
                rakaat: rakaat,
                sujood: -1,
                hideButtons: hideButtons,
                start: start, onStartButtonPressed: () {
              if (start) {
              } else {
                setState(() {
                  start = true;
                });

                Timer(const Duration(seconds: 5), () {
                  if (mounted) {
                    _start();

                    setState(() {
                      rakaat = 1;
                    });
                  }
                });
              }
            });
          }),
    );
  }
}
