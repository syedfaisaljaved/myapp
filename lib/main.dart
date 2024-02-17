import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rakaat_tracker/ads/applovin.dart';
import 'package:rakaat_tracker/firebase_options.dart';
import 'package:rakaat_tracker/screens/choose_mode_screen.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/screens/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// initialize hive db
  await HiveProvider.initHive();
  await HiveProvider.openBox();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await ApplovinAdSdk.instance.initializeSDK();

  await WakelockPlus.enable();

  const loader = SvgAssetLoader("assets/splash_screen.svg");
  svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {

  late Locale _locale;

  setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }


  @override
  void initState() {
    _locale = Locale(HiveProvider.locale);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder:(p0, p1, p2) => NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: "Rakaat Tracker",
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: HiveProvider.nightModeEnabled ? ThemeMode.dark : ThemeMode.light,
        theme: NeumorphicThemeData(
          baseColor: const Color(0xffe1ddd6),
          lightSource: LightSource.topLeft,
          accentColor: Colors.teal.shade800,
          depth: 10,
        ),
        locale: _locale,
        color: Colors.teal.shade800,
        darkTheme: const NeumorphicThemeData(
          baseColor: Color(0xff303234),
          lightSource: LightSource.topLeft,
          accentColor: Color(0xFFD7D7CC),
          shadowLightColor: Color(0x7cc6cdd5),
          shadowDarkColor: Colors.black,
          depth: 4,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
