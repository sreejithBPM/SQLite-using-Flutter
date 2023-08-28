import 'package:flutter/material.dart';
  import 'localdb.dart';
import 'task_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Task> _tasks = [];
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

    _editTask(Task task) {
    setState(() {
      _selectedTask = Task.copy(task);
      _titleController.text = task.title;
      _descriptionController.text = task.description;
    });
  }


  _fetchTasks() async {
    List<Task> tasks = await DatabaseHelper.instance.fetchTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  _addTask() async {
    Task newTask = Task(
     
      title: _titleController.text,
      description: _descriptionController.text,
    );
    await DatabaseHelper.instance.insertTask(newTask);
    _titleController.clear();
    _descriptionController.clear();
    _fetchTasks();
  }

  _deleteTask(int taskId) async {
    await DatabaseHelper.instance.deleteTask(taskId);
    _fetchTasks();
  }
 _updateTask() async {
    if (_selectedTask != null) {
      _selectedTask!.title = _titleController.text;
      _selectedTask!.description = _descriptionController.text;
      await DatabaseHelper.instance.updateTask(_selectedTask!);
      _clearFields();
      _fetchTasks();
    }
  }

  _clearFields() {
    setState(() {
      _selectedTask = null;
      _titleController.clear();
      _descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ),
          ElevatedButton(
          onPressed: _selectedTask != null ? _updateTask : _addTask,
            child: Text(_selectedTask != null ? 'Update Task' : 'Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index].title),
                  subtitle: Text(_tasks[index].description),
                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editTask(_tasks[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(_tasks[index].id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}