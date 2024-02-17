import 'dart:async';
import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rakaat_tracker/widgets/compass_needle.dart';
import 'package:rakaat_tracker/widgets/location_error_widget.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:rakaat_tracker/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../db/hiveprovider.dart';

class QiblaDirection extends StatefulWidget {
  const QiblaDirection({Key? key}) : super(key: key);

  @override
  State<QiblaDirection> createState() => _QiblaDirectionState();
}

class _QiblaDirectionState extends State<QiblaDirection> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    if (HiveProvider.compassAvailable && !HiveProvider.dontShowCompassDialog) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        await getBottomSheet(
          context,
          disableListGlow(
            child: bottomSheetSliderIcon(
              context: context,
              child: disclaimerModalWidget(context, HiveProvider.dontShowCompassDialog,
                  text1: translation(context).important_tr,
                  text2:
                      translation(context).calibrate_tr,
                  buttonText: translation(context).okay_tr,
                  compassDialog: true),
            ),
          ),
        );
      });
    }

    _checkLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: baseColor(context),
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0.sp),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: teal800(context),
            );
          }
          if (snapshot.data!.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                return const QiblahCompassWidget();

              case LocationPermission.denied:
                return LocationErrorWidget(
                  error: translation(context).msg_permission_not_granted_yet_tr,
                  callback: _checkLocationStatus,
                );
              case LocationPermission.deniedForever:
                return LocationErrorWidget(
                  error: translation(context).msg_permission_not_granted_yet_tr,
                  callback: _checkLocationStatus,
                );
              default:
                return const SizedBox();
            }
          } else {
            return LocationErrorWidget(
              error: translation(context).msg_permission_required_tr,
              callback: _checkLocationStatus,
            );
          }
        },
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }
}

class QiblahCompassWidget extends StatefulWidget {
  const QiblahCompassWidget({super.key});

  @override
  State<QiblahCompassWidget> createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget>
    with TickerProviderStateMixin {
  late Animation<double> _animation2;
  late AnimationController _animationController2;
  double begin2 = 0.0;

  @override
  void initState() {
    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation2 = Tween(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: _animationController2, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            color: teal800(context),
          );
        }

        final qiblahDirection = snapshot.data!;

        _animation2 = Tween(
                begin: begin2, end: (qiblahDirection.qiblah * (pi / 180) * -1))
            .animate(_animationController2);
        begin2 = (qiblahDirection.qiblah * (pi / 180) * -1);
        _animationController2.forward(from: 0);

        return Column(
          children: [
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 10,
                    boxShape: const NeumorphicBoxShape.circle(),
                    color: baseColor(context),
                  ),
                  child: SizedBox(
                    width: 80.w,
                    height: 80.w,
                  ),
                ),
                AnimatedBuilder(
                    animation: _animation2,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation2.value,
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            depth: 10,
                            boxShape: NeumorphicBoxShape.path(
                              CompassNeedlePathProvider(),
                            ),
                          ),
                          child: SvgPicture.asset(
                            "assets/kaabah compass needle.svg",
                            width: 60.w,
                          ),
                        ),
                      );
                    }),
              ],
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
