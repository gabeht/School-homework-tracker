import 'package:flutter/material.dart';

class AssignmentListScreen extends StatefulWidget{
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen>{

  final List<Map<String, dynamic>> _assignments = [];
  void _showAddAssignmentDialog(){
    String newAssignmentTitle = '';

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Add New Assignment'),
          content: TextField(
            autofocus: true,
            decoration : const InputDecoration(hintText: 'Enter Assignment Name'),
            onChanged: (value){
              newAssignmentTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newAssignmentTitle.trim().isNotEmpty){
                  setState((){
                    _assignments.add({
                      'title': newAssignmentTitle.trim(),
                      'completed' : false,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }   

  void _toggleCompleted(int index, bool? value) async {
  
  //False boolean check to verify if the assignment has been completed
  if (value != true) {
    setState((){
      _assignments[index]['completed'] = false;
    });
    return;
  }
// main "meat" of interaction that prints the dialog chosen from previous booleans
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Mark as Completed?'),
        content: Text('Has "${_assignments[index]['title']}" been completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Nope..Not yet!'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes! All Done!'),
          ),
        ],
      );
    },
  );

// True Boolean to confirm assignment has been completed
  if (confirmed == true) {
    setState((){
      _assignments[index]['completed'] = true;
    });
  }
}
  
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index){
          return CheckboxListTile(
            title: Text(_assignments[index]['title']),
            value: _assignments[index]['completed'],
            onChanged: (value) => _toggleCompleted(index,value),
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
