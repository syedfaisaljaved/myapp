import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakaat_tracker/util/color_const.dart';
import 'package:rakaat_tracker/util/common_utils.dart';

class LocationErrorWidget extends StatelessWidget {
  final String? error;
  final Function? callback;

  const LocationErrorWidget({Key? key, this.error, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const box = SizedBox(height: 32);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          NeumorphicIcon(
            Icons.location_off,
            style: NeumorphicStyle(
              color: teal800(context),
              depth: 5,
            ),
            size: MediaQuery.of(context).size.width * 0.5,
          ),
          box,
          Text(
            error!,
            style: GoogleFonts.cairo(
              fontSize: 16,
                color: teal800(context), fontWeight: FontWeight.bold),
          ),
          box,
          NeumorphicButton(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            style: NeumorphicStyle(
              color: teal800(context),
              depth: 10,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
            ),
            child: Text(translation(context).retry_tr,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: baseColor(context),
            ),),
            onPressed: () {
              if (callback != null) callback!();
            },
          )
        ],
      ),
    );
  }
}
