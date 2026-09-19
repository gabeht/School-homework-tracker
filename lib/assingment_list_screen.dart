import 'package:flutter/material.dart';

class AssingmentListScreen extends StatefulWidget{
  const AssingmentListScreen({super.key});

  @override
  State<AssingmentListScreen> createState() => _AssingmentListScreenState();
}

class _AssingmentListScreenState extends State<AssingmentListScreen>{

  final List<Map<String, dynamic>> _assingments = [];
  void _showAddAssingmentDialog(){
    String newAssingmentTitle = '';

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Add New Assingment'),
          content: TextField(
            autofocus: true,
            decoration : const InputDecoration(hintText: 'Enter Assingment Name'),
            onChanged: (value){
              newAssingmentTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newAssingmentTitle.trim().isNotEmpty){
                  setState((){
                    _assingments.add({
                      'title': newAssingmentTitle.trim(),
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
  void _toggleCompleted(int index, bool? value){
    setState((){
      _assingments[index]['completed'] = value ?? false;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Assingments')),
      body: ListView.builder(
        itemCount: _assingments.length,
        itemBuilder: (context, index){
          return CheckboxListTile(
            title: Text(_assingments[index]['title']),
            value: _assingments[index]['completed'],
            onChanged: (value) => _toggleCompleted(index,value),
          );
        },
      ),
      floatingActionButton : FloatingActionButton(
        onPressed: _showAddAssingmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
