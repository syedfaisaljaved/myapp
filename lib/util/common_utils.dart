import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/model/remote_config.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'color_const.dart';

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}

String getCountryName(String countryCode) {
  switch (countryCode) {
    case "ar":
      return "عربي";
    case "bn":
      return "বাংলা";
    case "hi":
      return "हिंदी";
    case "id":
      return "Bahasa Indonesia";
    case "ur":
      return "اردو";
    case "en":
    default:
      return "English";
  }
}

String getLanguageByCountry(String countryCode) {
  switch (countryCode) {
    case "bn":
      return "bn-BD";
    case "id":
      return "id-ID";
    case "hi":
      return "hi-IN";
    case "ur":
      return "hi-IN";
    case "ar":
    case "en":
    default:
      return "en-US";
  }
}

Future<void> getLightVibration() async {
  try {
    // Check if the device can vibrate
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate && HiveProvider.vibrationEnabled) {
      Vibrate.feedback(FeedbackType.success);
    }
  } catch (e) {}
}

Future<void> getHeavyVibration() async {
  try {
    // Check if the device can vibrate
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate && HiveProvider.vibrationEnabled) {
      Vibrate.feedback(FeedbackType.heavy);
    }
  } catch (e) {}
}

Future<void> getVibration() async {
  try {
    // Check if the device can vibrate
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate && HiveProvider.vibrationEnabled) {
      Vibrate.vibrate();
    }
  } catch (e) {}
}

Future<void> getVibrationWithPauses(int rakaat) async {
  try {
    // Check if the device can vibrate
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate && HiveProvider.vibrationEnabled) {
      final vibrations =
          List.generate(rakaat, (index) => const Duration(milliseconds: 500));
      for (final Duration d in vibrations) {
        await Vibrate.vibrate();
        //Because the native vibration is not awaited, we need to wait for
        //the vibration to end before launching another one
        await Future.delayed(d);
      }
    }
  } catch (e) {}
}

Future<dynamic> getBottomSheet(BuildContext context, Widget widget) async {
  return await showModalBottomSheet(
    backgroundColor: baseColor(context),
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp))),
    builder: (context) {
      return widget;
    },
  );
}

Future<RemoteConfigModel> checkForAppUpdate() async {
  int versionCode;
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  versionCode = int.parse(packageInfo.buildNumber);
  debugPrint("version code: $versionCode");

  // Using default duration to force fetching from remote server.
  RemoteConfigModel remoteConfigModel = RemoteConfigModel(
      link:
          'https://play.google.com/store/apps/details?id=com.fj.salah.rakaat.tracker',
      linkIos: 'Your iOS app link',
      versionCode: versionCode,
      versionCodeIos: versionCode,
      optional: false,
      optionalIos: false,
      updateRequired: false);

  try {
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setDefaults(remoteConfigModel.toJson());

    if (Platform.isAndroid) {
      if (remoteConfig.getInt('version_code').toInt() > versionCode) {
        // enter code
        remoteConfigModel.updateRequired = true;
        remoteConfigModel.optional = remoteConfig.getBool("optional");
        return remoteConfigModel;
      }
    } else if (Platform.isIOS) {
      if (remoteConfig.getInt('version_code_ios').toInt() > versionCode) {
        // enter code
        remoteConfigModel.updateRequired = true;
        remoteConfigModel.optional = remoteConfig.getBool("optional_ios");
        return remoteConfigModel;
      }
    }

    return remoteConfigModel;
  } catch (exception, _) {
    debugPrint("remote exception: $exception");
    debugPrint(
        'Unable to fetch remote config. Cached or default values will be used');
    return remoteConfigModel;
  }
}

void openEmailApp() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'devfaisalj@gmail.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Rakaat Tracker Feedback',
    }),
  );

  await launchUrl(params);
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
