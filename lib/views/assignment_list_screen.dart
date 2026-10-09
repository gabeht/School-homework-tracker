import 'package:flutter/material.dart';
import 'package:homework_tracker/models/assignment_model.dart';
import '../widgets/add_fab.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _assignmentPresenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();
  
  bool _isLoading = true;
  String searchQuery = '';
  String? _selectedCourseFilter;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async{
    await _coursePresenter.loadCourses();
    await _assignmentPresenter.loadAssignments();

    setState((){
      _isLoading = false;
      _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
    });
  }

  Future<void> _loadAssignments() async {
    await _assignmentPresenter.loadAssignments();
    setState(() => _isLoading = false);
  }

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;

    DateTime? newAssignmentDueDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Assignment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter assignment title',
                    ),
                    onChanged: (value) => newAssignmentTitle = value,
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: _newAssignmentCourse,
                    items:
                        _courseNames.map((name) {
                          return DropdownMenuItem(value: name, child: Text(name));
                        }).toList(),
                    onChanged:
                        (value) => setState(() => _newAssignmentCourse = value),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          newAssignmentDueDate = picked;
                        });
                      }
                    },
                    child: Text(
                      newAssignmentDueDate == null
                          ? 'Pick due date'
                          : 'Due: ${newAssignmentDueDate!.month}/${newAssignmentDueDate!.day}/${newAssignmentDueDate!.year}',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (newAssignmentTitle.trim().isNotEmpty &&
                        _newAssignmentCourse != null) {
                      await _assignmentPresenter.addAssignment(
                        newAssignmentTitle.trim(),
                        _newAssignmentCourse!,
                      );
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.toLowerCase();
    final assignments = _assignmentPresenter.assignments
        .where((a) => a.title.toLowerCase().contains(query))
        .toList();
    final displayedAssignments =
        _selectedCourseFilter == null
            ? assignments
            : assignments
                .where((a) => a.courseName == _selectedCourseFilter)
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          if (_courseNames.isNotEmpty)
            DropdownButton<String>(
              hint: const Text(
                'Filter by course',
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.blue[100],
              value: _selectedCourseFilter,
              onChanged: (value) {
                setState(() {
                  _selectedCourseFilter = value;
                });
              },
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Courses'),
                ),
                ..._courseNames.map(
                  (name) => DropdownMenuItem(value: name, child: Text(name)),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search assignments',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment = displayedAssignments[index];
                      return CheckboxListTile(
                        title: Text(assignment.title),
                        subtitle: Text('Course: ${assignment.courseName}'),
                        value: assignment.isCompleted,
                        onChanged: (_) async {
                          await _assignmentPresenter.toggleCompleted(index);
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

      floatingActionButton: AddFAB(
        onPressed: _showAddAssignmentDialog
      ),
    );
  }
}
