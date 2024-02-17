import 'package:hive_flutter/hive_flutter.dart';

class HiveProvider {
  static initHive() async {
    await Hive.initFlutter();
  }

  static openBox() async {
    await Hive.openBox(box_auth);
    await Hive.openBox(box_bg);
  }

  /// box variables
  static const box_auth = "auth";
  static const box_bg = "bg";

  /// key variables
  static const String _onBoardingCompleted = "on_boarding_completed";
  static const String _rakaatScreenAnim = "rakaat_screen_anim";
  static const String _proximityTestCompleted = "proximity_test";
  static const String _locale = "locale_set";
  static const String _mode = "mode";
  static const String _rakaatCounter = "rakaat_counter";
  static const String _nightMode = "night_mode";
  static const String _sujoodInterval = "sujood_interval";
  static const String _vibration = "vibration";
  static const String _hideRakaat = "hide_rakaat";
  static const String _reset = "reset";
  static const String _compass = "compass";
  static const String _proximity = "proximity";
  static const String _dontShowDialog = "dont_show_dialog";
  static const String _dontShowCompassDialog = "dont_show_compass_dialog";

  /// <-------------- setter and getter methods --------------->

  /// setter getter to check if onboarding is completed
  static bool get onBoardingCompleted =>
      Hive.box(box_auth).get(_onBoardingCompleted, defaultValue: false);

  static set onBoardingCompleted(bool value) =>
      Hive.box(box_auth).put(_onBoardingCompleted, value);

  /// setter getter to check if rakat screen anim is completed
  static bool get rakaatScreenAnimCompleted =>
      Hive.box(box_auth).get(_rakaatScreenAnim, defaultValue: false);

  static set rakaatScreenAnimCompleted(bool value) =>
      Hive.box(box_auth).put(_rakaatScreenAnim, value);

  /// setter getter for proximity test
  static bool get proximitySensorTextCompleted =>
      Hive.box(box_auth).get(_proximityTestCompleted, defaultValue: false);

  static set proximitySensorTextCompleted(bool value) =>
      Hive.box(box_auth).put(_proximityTestCompleted, value);

  /// setter getter for night mode
  static bool get nightModeEnabled =>
      Hive.box(box_auth).get(_nightMode, defaultValue: false);

  static set nightModeEnabled(bool value) =>
      Hive.box(box_auth).put(_nightMode, value);

  /// setter getter for interval b/w sujood
  static int get intervalSujood =>
      Hive.box(box_auth).get(_sujoodInterval, defaultValue: 3);

  static set intervalSujood(int value) =>
      Hive.box(box_auth).put(_sujoodInterval, value);

  /// setter getter for vibration
  static bool get vibrationEnabled =>
      Hive.box(box_auth).get(_vibration, defaultValue: true);

  static set vibrationEnabled(bool value) =>
      Hive.box(box_auth).put(_vibration, value);

  /// setter getter for rakaat counter ui
  static bool get hideSujoodCounter =>
      Hive.box(box_auth).get(_hideRakaat, defaultValue: false);

  static set hideSujoodCounter(bool value) =>
      Hive.box(box_auth).put(_hideRakaat, value);

  /// setter getter for reset
  static bool get reset =>
      Hive.box(box_auth).get(_reset, defaultValue: false);

  static set reset(bool value) =>
      Hive.box(box_auth).put(_reset, value);

  /// setter getter for reset
  static bool get compassAvailable =>
      Hive.box(box_auth).get(_compass, defaultValue: true);

  static set compassAvailable(bool value) =>
      Hive.box(box_auth).put(_compass, value);

  /// setter getter for proximity sensor
  static bool get proximityAvailable =>
      Hive.box(box_auth).get(_proximity, defaultValue: true);

  static set proximityAvailable(bool value) =>
      Hive.box(box_auth).put(_proximity, value);

  /// setter getter for dont show dialog
  static bool get dontShowDialog =>
      Hive.box(box_auth).get(_dontShowDialog, defaultValue: false);

  static set dontShowDialog(bool value) =>
      Hive.box(box_auth).put(_dontShowDialog, value);

  /// setter getter for dont show dialog
  static bool get dontShowCompassDialog =>
      Hive.box(box_auth).get(_dontShowCompassDialog, defaultValue: false);

  static set dontShowCompassDialog(bool value) =>
      Hive.box(box_auth).put(_dontShowCompassDialog, value);

  /// setter getter for locale
  static String get locale =>
      Hive.box(box_auth).get(_locale, defaultValue: "en");

  static set locale(String value) => Hive.box(box_auth).put(_locale, value);

  /// setter getter for mode
  static String get mode =>
      Hive.box(box_auth).get(_mode, defaultValue: "0");

  static set mode(String value) => Hive.box(box_auth).put(_mode, value);

  /// setter getter for rakaat counter
  static int get rakaatCounter =>
      Hive.box(box_bg).get(_rakaatCounter, defaultValue: 0);

  static set rakaatCounter(int value) => Hive.box(box_bg).put(_rakaatCounter, value);

  /// get key name for rakaatCounter
  static get rakaatCounterKeyName => _rakaatCounter;

  static Future<void> clearLocalData() async {
    await Hive.box(box_auth).clear();
  }

}
