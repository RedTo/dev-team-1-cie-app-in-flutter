import 'package:cie_app/generic/genericIcon.dart';
import 'package:cie_app/presenter/courseListPresenter.dart';
import 'package:cie_app/utils/staticVariables.dart';
import 'package:cie_app/widgets/courseListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

@Timeout(const Duration(seconds: 5))
void main() {
  group('simple tests', () {
    test('1 courseListPresenterTest', () async {
      final CourseListPresenter courseListPresenter =
          new CourseListPresenter(null, Flavor.MOCK);
      final int id = 1;

      final CourseListItem courseListItem = new CourseListItem(
          courseListPresenter,
          id,
          new IconButton(
            icon: GenericIcon.buildGenericFavoriteIcon(
                courseListPresenter.getFavourite(id), false),
            onPressed: null,
          ));

      expect(courseListItem.courseListPresenter, courseListPresenter);
    });

    test('1 idTest', () async {
      final CourseListPresenter courseListPresenter =
          new CourseListPresenter(null, Flavor.MOCK);
      final int id = 1;

      final CourseListItem courseListItem = new CourseListItem(
          courseListPresenter,
          id,
          new IconButton(
            icon: GenericIcon.buildGenericFavoriteIcon(
                courseListPresenter.getFavourite(id), false),
            onPressed: null,
          ));

      expect(courseListItem.id, 1);
    });
  }); //group
} //main
