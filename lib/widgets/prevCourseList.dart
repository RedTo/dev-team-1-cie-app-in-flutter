import 'package:cie_app/presenter/currentUserPresenter.dart';
import 'package:cie_app/utils/staticVariables.dart';
import 'package:cie_app/widgets/prevCourseListItem.dart';
import 'package:flutter/material.dart';

class PrevCourseList extends StatefulWidget {
  // Stateful because then this class can be used for favourites as well.
  final CurrentUserPresenter currentUserPresenter;

  PrevCourseList(this.currentUserPresenter);

  @override
  State<StatefulWidget> createState() {
    return new PrevCourseListState(currentUserPresenter);
  }
}

class PrevCourseListState extends State<PrevCourseList> {
  final CurrentUserPresenter currentUserPresenter;

  PrevCourseListState(this.currentUserPresenter);

  @override
  Widget build(BuildContext context) {
    try {
      return new ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            new PrevCourseListItem(currentUserPresenter, index),
        itemCount: currentUserPresenter.getPrevCourses().length,
      );
    } catch (e) {
      print("courseList.dart, error: " + e.toString());
      return new Text(StaticVariables.TAKEN_COURSES_ERROR_NO_COURSE_FOUND);
    }
  }
}
