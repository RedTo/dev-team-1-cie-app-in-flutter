import 'dart:async';
import 'dart:convert';

import 'package:cie_app/generic/genericAlert.dart';
import 'package:cie_app/generic/genericIcon.dart';
import 'package:cie_app/generic/genericShowInstruction.dart';
import 'package:cie_app/model/course/details/department.dart';
import 'package:cie_app/presenter/courseListPresenter.dart';
import 'package:cie_app/presenter/currentUserPresenter.dart';
import 'package:cie_app/utils/analytics.dart';
import 'package:cie_app/utils/cieColor.dart';
import 'package:cie_app/utils/cieStyle.dart';
import 'package:cie_app/utils/dataManager.dart';
import 'package:cie_app/utils/routes.dart';
import 'package:cie_app/utils/staticVariables.dart';
import 'package:cie_app/utils/utility.dart';
import 'package:cie_app/widgets/courseListItem.dart';
import 'package:flutter/material.dart';

class CourseList extends StatefulWidget {
  // Stateful because then this class can be used for favourites as well.
  final CourseListPresenter courseListPresenter;
  final CurrentUserPresenter userPresenter;
  bool shouldFilterByFavorites = false;
  final FocusNode focus;

  CourseList(this.courseListPresenter, this.shouldFilterByFavorites,
      this.userPresenter, this.focus);

  @override
  State<StatefulWidget> createState() {
    return new CourseListState(
        courseListPresenter, shouldFilterByFavorites, userPresenter, focus);
  }

  void toggleFilter() {
    shouldFilterByFavorites = !shouldFilterByFavorites;
  }
}

class CourseListState extends State<CourseList> {
  final CourseListPresenter courseListPresenter;
  final CurrentUserPresenter userPresenter;
  final TextEditingController c1 = new TextEditingController();
  final bool shouldFilterByFavorites;
  bool shouldSearch = false;
  String filter = "";
  String searchValue = "";
  FocusNode focus;
  var registeredCourses = new List<dynamic>();

  CourseListState(this.courseListPresenter, this.shouldFilterByFavorites,
      this.userPresenter, this.focus) {
    if (this.userPresenter.getCurrentUser().isLoggedIn != null &&
        this.userPresenter.getCurrentUser().isLoggedIn &&
        this.userPresenter.getCurrentUser().department.isNotEmpty) {
      var dep = this.userPresenter.getCurrentUser().department;
      if (dep.isNotEmpty && dep != StaticVariables.GUEST_DEPARTMENT) {
        String department = dep;
        this.filter =
            department.substring(department.length - 2, department.length);
      }
    }
  }

  initState() {
    super.initState();
    if (!shouldFilterByFavorites) {
      Analytics.setCurrentScreen("courses_screen");
    } else {
      Analytics.setCurrentScreen("favorites_screen");
    }
    _fetchRegisteredCourses();
  }

  void _fetchRegisteredCourses() async {
    var registeredString =
        await DataManager.getResource(DataManager.LOCAL_SUBSCRIPTIONS);
    if (registeredString != null && registeredString.isNotEmpty) {
      setState(() {
        registeredCourses = json.decode(registeredString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = new List<Widget>();

    if (courseListPresenter.getCourses().isEmpty) {
      return new Column(
        children: <Widget>[
          GenericShowInstruction.showInstructions(
              context, false, courseListPresenter, userPresenter),
        ],
      );
    } else {
      if (shouldFilterByFavorites == false) {
        widgets.add(new Container(
            color: CiEColor.white,
            padding: new EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(StaticVariables.PULL_DOWN_TO_REFRESH,
                    style: CiEStyle.getCourseListRefreshText()),
                new Icon(Icons.arrow_downward, color: CiEColor.mediumGray)
              ],
            )));

        //Select department to filter for
        EdgeInsets pad = const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0);
        String departmentLabel = StaticVariables.DEPARTMENT + " ";
        List<DropdownMenuItem<String>> departments =
            List<DropdownMenuItem<String>>();
        departments.add(new DropdownMenuItem<String>(
          value: "",
          child: new Text(StaticVariables.ALL_DEPARTMENTS,
              overflow: TextOverflow.clip),
        ));
        departments.addAll(Department.departments.map((String value) {
          if (value != null) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(departmentLabel + value,
                  overflow: TextOverflow.clip),
            );
          }
        }).toList());
        widgets.add(new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                  padding: pad,
                  child: new DropdownButton<String>(
                    items: departments,
                    onChanged: (String val) {
                      setState(() {
                        this.filter = val;
                      });
                    },
                    iconSize: 32.0,
                    value: filter,
                  )),
              new Container(
                padding: const EdgeInsets.fromLTRB(80.0, 10.0, 10.0, 10.0),
                child: new IconButton(
                    color: CiEColor.mediumGray,
                    icon: GenericIcon.buildGenericSearchIcon(shouldSearch),
                    onPressed: toggleSearch),
              )
            ]));
        if (shouldSearch) {
          widgets.add(new Container(
            padding: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
            alignment: Alignment.center,
            child: new TextField(
              focusNode: focus,
              controller: c1,
              decoration: const InputDecoration(
                hintText: StaticVariables.SEARCH_BY_COURSE_NAME,
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(),
              ),
              onChanged: (String val) => updateSearch(val),
              onSubmitted: (String val) => Analytics.logSearch(val),
            ),
          ));
        }
      } else {
        widgets.add(new Padding(
          padding: const EdgeInsets.all(10.0),
        ));
      }

      //Build the tiles of the course list / favorites list
      for (int i = 0; i < courseListPresenter.getCourses().length; i++) {
        if (_shouldShowCourse(i)) {
          if (shouldSearch == false ||
              (courseListPresenter
                  .getTitle(i)
                  .toLowerCase()
                  .contains(searchValue.toLowerCase()))) {
            widgets.add(
                new CourseListItem(courseListPresenter, i, favoriteIcon(i)));
            widgets.add(new Divider());
          }
        }
      }
      if (shouldFilterByFavorites == true) {
        widgets.add(new Container(
          margin: const EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 15.0),
          child: _getRaisedSubmitButton(),
        ));
      }

      return new RefreshIndicator(
        child: new ListView(children: widgets),
        onRefresh: () => handleRefreshIndicator(context, courseListPresenter),
        color: CiEColor.mediumGray,
      );
    }
  }

  bool _shouldShowCourse(int i) {
    if (shouldFilterByFavorites == false) {
      //return true if department is searched
      return courseListPresenter.getDepartmentShortName(i).contains(filter);
    } else {
      //return true if course is favorite or is temporary available
      return courseListPresenter.getFavourite(i) ||
          courseListPresenter.getWillChangeOnViewChange(i);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    courseListPresenter.deactivate();
  }

  // Create a raised button on which is used on favorite page to allow users to submit their choices to lottery
  Widget _getRaisedSubmitButton() {
    bool isLoggedIn = userPresenter.getCurrentUser().isLoggedIn != null
        ? userPresenter.getCurrentUser().isLoggedIn
        : false;
    bool isDepartmentSet =
        userPresenter.getCurrentUser().department.isNotEmpty != null
            ? userPresenter.getCurrentUser().department.isNotEmpty
            : false;
    bool submissionValid = isLoggedIn && isDepartmentSet;

    //Decide how to show submit button
    String textToShow;
    Color buttonColor;

    if (submissionValid) {
      textToShow = StaticVariables.FAVORITES_REGISTRATION_BUTTON;
      buttonColor = CiEColor.red;
    } else if (isLoggedIn && !isDepartmentSet) {
      textToShow =
          StaticVariables.FAVORITES_REGISTRATION_BUTTON_INACTIVE_NO_DEPARTMENT;
      buttonColor = CiEColor.lightGray;
    } else {
      textToShow = StaticVariables.FAVORITES_REGISTRATION_BUTTON_LOGIN_FIRST;
      buttonColor = CiEColor.lightGray;
    }

    return new RaisedButton(
      color: buttonColor,
      shape: new RoundedRectangleBorder(
          borderRadius: CiEStyle.getButtonBorderRadius()),
      onPressed: () => _contextualCourseSubmission(
          userPresenter, submissionValid, isLoggedIn),
      child: new Container(
        margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
        child: new Text(textToShow, style: new TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<Null> handleRefreshIndicator(
      BuildContext context, CourseListPresenter presenter,
      [oldSemesters = false, inBackground = true]) async {
    await DataManager.updateAll(
        context, userPresenter, oldSemesters, inBackground);
    presenter.addCoursesFromMemory();
    presenter.updateLecturerInfoFromMemory();
    presenter.onChanged(true);
    return null; //this is needed for RefreshIndicator to stop
  }

  Widget favoriteIcon(int id) {
    return new IconButton(
      icon: GenericIcon.buildGenericFavoriteIcon(
          courseListPresenter.getFavourite(id),
          courseListPresenter.getRegistered(id)),
      onPressed: () => _toggleFavourite(id),
    );
  }

  void _toggleFavourite(int id) {
    setState(() {
      //Remove course from favourites only after view change
      if (shouldFilterByFavorites)
        courseListPresenter.toggleFavouriteWhenChangeView(id);
      else {
        if (registeredCourses
            .contains(courseListPresenter.getCourses()[id].id)) {
          GenericAlert.confirmDialog(context, "Unfavorite not possible",
              "Please visit the favorites tab to update your registered courses.");
        } else {
          courseListPresenter.toggleFavourite(id, true);
        }
      }
    });
  }

  void toggleSearch() {
    setState(() {
      this.shouldSearch = !shouldSearch;
    });
  }

  void _contextualCourseSubmission(
      CurrentUserPresenter user, bool isSubmissionValid, bool isLoggedIn) {
    if (isSubmissionValid) {
      _handleCourseSubmission(user);
    } else if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, Routes.Login);
    } else if (!isSubmissionValid && isLoggedIn) {
      GenericAlert.confirm(
          context,
          () => Utility.tryLaunch(DataManager.REMOTE_BASE),
          StaticVariables.PLEASE_SPECIFY_HOME_DEPARTMENT);
    }
  }

  void _handleCourseSubmission(CurrentUserPresenter user) async {
    List<dynamic> unsubscribeCourses =
        courseListPresenter.getUnsubscribeCourses();
    List<dynamic> subscribeCourses = courseListPresenter
        .getCourses()
        .where((course) => course.isFavourite && !course.isRegistered)
        .map((course) => {"id": course.id})
        .toList();

    var jsonData = {
      "user": {
        "id": user.getCurrentUser().id,
        "firstName": user.getCurrentUser().firstName,
        "lastName": user.getCurrentUser().lastName
      },
      "courses": []
    };
    if (unsubscribeCourses.length > 0) {
      jsonData["courses"] = unsubscribeCourses;
      Analytics.logEvent("favorites_click",
          {"title": "unsubscribe", "courses": unsubscribeCourses});
      await DataManager.postJson(
          context, DataManager.REMOTE_UNSUBSCRIBE, jsonData);
    }
    if (subscribeCourses.length > 0) {
      jsonData["courses"] = subscribeCourses;
      Analytics.logEvent("favorites_click",
          {"title": "unsubscribe", "courses": subscribeCourses});
      var data = await DataManager.postJson(
          context, DataManager.REMOTE_SUBSCRIBE, jsonData);
    }

    jsonData["courses"] = [];
    var response = await DataManager.postJson(
        context, DataManager.REMOTE_SUBSCRIPTIONS, jsonData);
    var data = json.decode(response.body);
    var idList = new List<String>();
    for (var entry in data) {
      idList.add(entry['courseId']);
    }
    await DataManager.writeToFile(
        DataManager.LOCAL_SUBSCRIPTIONS, json.encode(idList));
    courseListPresenter.deactivate();
    courseListPresenter.syncFavoritedCoursesFromMemory();

    GenericAlert.confirmDialog(context, "Successfully updated courses",
        "Your registered courses were successfully updated.");
  }

  void updateSearch(String val) {
    setState(() {
      this.searchValue = val;
    });
  }
}
