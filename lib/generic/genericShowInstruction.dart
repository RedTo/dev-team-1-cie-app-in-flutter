import 'package:cie_team1/generic/genericIcon.dart';
import 'package:cie_team1/utils/cieColor.dart';
import 'package:cie_team1/utils/cieStyle.dart';
import 'package:cie_team1/utils/routes.dart';
import 'package:cie_team1/utils/staticVariables.dart';
import 'package:flutter/material.dart';

class GenericShowInstruction {
  static Widget showInstructions(Function onPressRefresh, BuildContext context) {
    return _getInstructionWidget(new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Text(
            "Instructions",
            style: CiEStyle.getInstructionPageHeadingStyle(),
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 10.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GenericIcon.buildGenericGetArchiveIcon(),
              new Expanded(
                  child: new Text(
                "Unfortunately you have not downloaded any course data "
                    "yet. At the end of the instruction you can download the courses for the fist time. "
                    "After finishing the setup you can swipe down on favorite and courses page at any time to refresh.",
                style: CiEStyle.getInstructionPageTextStyle(),
              ))
            ],
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child: new Text(
                "Afterwards you will be able to to select favorite courses.\n"
                    "Tipp: Use the filter at top of courses page to filter courses. Then press the heart icon.",
                style: CiEStyle.getInstructionPageTextStyle(),
              )),
              GenericIcon.buildGenericGetHeartIcon(),
            ],
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GenericIcon.buildGenericGetTrafficIcon(),
              new Expanded(
                  child: new Text(
                "You will notice that each course on the left side is dimpled "
                    "red, orange or green. Red means you can't attend this course. "
                    "Orange and green courses can be attended.",
                style: CiEStyle.getInstructionPageTextStyle(),
              )),
            ],
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                  child: new Text(
                "If you add courses to your favorites, which may lead to a time "
                    "conflict, you can see this directly in the course selection. Click "
                    "on the course for details.",
                style: CiEStyle.getInstructionPageTextStyle(),
              )),
              GenericIcon.buildGenericGetClockIcon(),
            ],
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GenericIcon.buildGenericGetHappyIcon(),
              new Expanded(
                  child: new Text(
                "Now when you have selected your favorites visit Favorite "
                    "tab and hand in your courses for lottery. And don't foreget to "
                    "check out your Timetable. By the way you can use the Timetable even if "
                    "you don't use lottery function.",
                style: CiEStyle.getInstructionPageTextStyle(),
              )),
            ],
          ),
          new Padding(padding: new EdgeInsets.only(bottom: 20.0)),
          onPressRefresh == null
              ? new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new Text(
                            "Plase go to courses page and refresh by swiping down.",
                            style: CiEStyle.getInstructionPageTextStyle()))
                  ],
                )
              : new RaisedButton(
                  color: CiEColor.lightGray,
                  onPressed: () => _toggleRefresh(onPressRefresh, context),
                  child: new Text("Download courses now and restart")),
        ],
      ),
    ));
  }

  static _toggleRefresh (Function onPressRefresh, BuildContext context) {
    () => onPressRefresh();
    Navigator.pushReplacementNamed(context, Routes.TabPages);
  }

  static Widget _getInstructionWidget(Widget text) {
    return new Expanded(
      child: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            alignment: Alignment.bottomCenter,
            image: new AssetImage(
                StaticVariables.IMAGE_PATH + "AppLogo_45Transparent.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        padding: new EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: new Container(
              padding: new EdgeInsets.all(20.0),
              alignment: Alignment.topCenter,
              child: text,
              //new Text(text,
              //    style: CiEStyle.getInstructionPageTextStyle()),
            ))
          ],
        ),
      ),
    );
  }
}