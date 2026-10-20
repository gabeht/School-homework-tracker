import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/models/assignment_model.dart';
import 'package:homework_tracker/presenters/assignment_presenter.dart';

void main(){
  test('New presenter starts with no assignments', () {
    final presenter = AssignmentPresenter();
    expect(presenter.totalAssignments, 0);
    expect(presenter.completionRatio, 0);
  });

  test('completedAssignments counts only completed ones', () {
    final presenter = AssignmentPresenter();
    presenter.assignments.addAll([
      Assignment(title: 'HW1', courseName: 'Math', isCompleted: true),
      Assignment(title: 'HW2', courseName: 'Math'),
      Assignment(title: 'Essay', courseName: 'English', isCompleted: true),
    ]);
    expect(presenter.totalAssignments, 3);
    expect(presenter.completedAssignments, 2);
  });

  test('completionRatio is completed / total', () {
    final presenter = AssignmentPresenter();
    presenter.assignments.addAll([
      Assignment(title: 'A', courseName: 'Art', isCompleted: true),
      Assignment(title: 'B', courseName: 'Art'),
    ]);
    expect(presenter.completionRatio, 0.5);
  });
  
}