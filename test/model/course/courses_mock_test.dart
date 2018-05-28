import 'package:cie_team1/model/course/course.dart';
import 'package:cie_team1/model/course/courses_mock.dart';
import 'package:test/test.dart';


@Timeout(const Duration(seconds: 20))
void main() {

  CoursesMock sut;
  List<String> courses;
  List<String> validDepartments;

  setUp((){
    sut = new CoursesMock();
    courses = new List<String>();
    for (int i=1; i<=100; i++) {
      courses.add("Title of Course " + i.toString());
    }
    validDepartments = CourseDefinitions.DEPARTMENTS;
  });

  test('1 name', () {

    final Iterator<Course> itera = sut.getCourses().iterator;

    int counter = 0;
    while(itera.moveNext()) {
      expect(itera.current.name, courses[counter]);
      counter++;
    }
  });

  test('2 fk', () {

    final Iterator<Course> itera = sut.getCourses().iterator;

    while(itera.moveNext()) {
      expect(validDepartments.contains(itera.current.faculty), true);
    }
  });

}