import 'package:flutter/material.dart';
import 'package:red_browser/config/color.dart';

class ProgressView extends StatelessWidget {
  ProgressView(this.progress);

  var progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      var width = constraint.maxWidth * progress - 20;
      if (width < 0 ) {
        width = 0;
      }
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 4,
                    width: width,
                    child: DecoratedBox(decoration: BoxDecoration(
                      color: RColor.PRIMARY_COLOR,
                    )),
                  ),

                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: width),
            child: Image.asset('assets/images/launch_progress.png', width:
            20, height: 20,),
          )
        ],
      );
    });
  }
}