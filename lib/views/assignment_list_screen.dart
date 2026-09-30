import 'package:flutter/material.dart';
import 'package:homework_tracker/models/assignment_model.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget{
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen>{

  final AssignmentPresenter _presenter = AssignmentPresenter();
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async{
    await _presenter.loadAssignments();
    setState(() => _isLoading = false);

  }

  void _showAddAssignmentDialog(){
    String newAssignmentTitle = '';
    DateTime? newAssignmentDueDate;

    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Assignment'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration : const InputDecoration(hintText: 'Enter Assignment Name'),
                    onChanged: (value){
                      newAssignmentTitle = value;
                    },
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
                        setDialogState((){
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
                    if (newAssignmentTitle.trim().isNotEmpty){
                      await _presenter.addAssignment(newAssignmentTitle.trim());
                      setState(() {});
                    }
                    Navigator.pop(context);
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
  Widget build(BuildContext context){
    final assignments = _presenter.assignments;

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: 
          _isLoading ? const Center(child:CircularProgressIndicator())
          : ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context,index){
              final assignment = assignments[index];
              return CheckboxListTile(
                title : Text(assignment.title),
                value: assignment.isCompleted,
                onChanged: (_) async {
                  await _presenter.toggleCompleted(index);
                  setState((){});
                },
              );
            },
          ),
      
      floatingActionButton : FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}