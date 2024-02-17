import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/db/hiveprovider.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';
import 'package:rakaat_tracker/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:type_text/type_text.dart';

class InstructionsScreen extends StatefulWidget {
  final bool proxiSense;

  const InstructionsScreen({Key? key, this.proxiSense = true})
      : super(key: key);

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor(context),
      body: SafeArea(
        child: widget.proxiSense ? proxiSenseIns() : pocketSenseIns(),
      ),
    );
  }

  Widget proxiSenseIns() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TypeText(
                translation(context).proxi_heading_tr,
                style: GoogleFonts.poppins(
                  color: Colors.orange,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                duration: const Duration(milliseconds: 300),
              ),
              sizedActionWidget(
                child: NeumorphicButton(
                  tooltip: "Close",
                  padding: buttonPadding(),
                  style: NeumorphicStyle(
                      color: baseColor(context),
                      depth: 5,
                      shape: NeumorphicShape.concave),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  provideHapticFeedback: HiveProvider.vibrationEnabled,
                  child: Icon(
                    Icons.close,
                    color: blackWhite(context),
                  ),
                ),
              )
            ],
          ),
          Text(
            translation(context).sense_tr,
            style: GoogleFonts.poppins(
              color: blackWhite(context),
              fontSize: 34.sp,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                  child: Divider(
                thickness: 3,
                color: Colors.orange,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  translation(context).mode_tr,
                  style: GoogleFonts.poppins(
                    color: blackWhite(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Neumorphic(
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: Text(
              translation(context).instructions_tr,
              style: GoogleFonts.poppins(
                color: Colors.orange,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).step_tr} 1:\n",
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_0_step1_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).step_tr} 2:\n",
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_0_step2_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).step_tr} 3:\n",
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_0_step3_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).note_tr}:\n",
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_0_note_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
        ],
      );

  Widget pocketSenseIns() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TypeText(
                translation(context).pocket_heading_tr,
                style: GoogleFonts.poppins(
                  color: tealWhite(context),
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                duration: const Duration(milliseconds: 300),
              ),
              sizedActionWidget(
                child: NeumorphicButton(
                    tooltip: "Close",
                    padding: buttonPadding(),
                    style: NeumorphicStyle(
                        color: baseColor(context),
                        depth: 5,
                        shape: NeumorphicShape.concave),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    provideHapticFeedback: HiveProvider.vibrationEnabled,
                    child: Icon(
                      Icons.close,
                      color: blackWhite(context),
                    )),
              )
            ],
          ),
          Text(
            translation(context).sense_tr,
            style: GoogleFonts.poppins(
              color: blackWhite(context),
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
                color: tealWhite(context),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  translation(context).mode_tr,
                  style: GoogleFonts.poppins(
                    color: blackWhite(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Neumorphic(
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: Text(
              translation(context).instructions_tr,
              style: GoogleFonts.poppins(
                color: tealWhite(context),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).step_tr} 1:\n",
                  style: GoogleFonts.poppins(
                    color: tealWhite(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_1_step1_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).step_tr} 2:\n",
                  style: GoogleFonts.poppins(
                    color: tealWhite(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_1_step2_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
          Neumorphic(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(10),
              ),
            ),
            child: RichText(
              text: TextSpan(
                  text: "${translation(context).step_tr} 3:\n",
                  style: GoogleFonts.poppins(
                    color: tealWhite(context),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: translation(context).mode_1_step3_tr,
                      style: GoogleFonts.poppins(
                        color: blackWhite(context),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ]),
            ),
          ),
          // Neumorphic(
          //   margin: const EdgeInsets.only(top: 20, right: 20),
          //   padding: const EdgeInsets.all(10),
          //   style: NeumorphicStyle(
          //     boxShape: NeumorphicBoxShape.roundRect(
          //       BorderRadius.circular(10),
          //     ),
          //   ),
          //   child: RichText(
          //     text: TextSpan(
          //         text: "${translation(context).note_tr}:\n",
          //         style: GoogleFonts.poppins(
          //           color: tealWhite(context),
          //           fontSize: 18.sp,
          //           fontWeight: FontWeight.bold,
          //         ),
          //         children: [
          //           TextSpan(
          //             text: translation(context).mode_1_note_tr,
          //             style: GoogleFonts.poppins(
          //               color: blackWhite(context),
          //               fontSize: 16.sp,
          //               fontWeight: FontWeight.normal,
          //             ),
          //           )
          //         ]),
          //   ),
          // ),
        ],
      );
}
