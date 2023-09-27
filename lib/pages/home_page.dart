import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/widgets/custom_search_delegate.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet();
          },
          child: const Text(
            "title",
            style: TextStyle(color: Colors.black87),
          ).tr(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var currentElement = _allTasks[index];
                return Dismissible(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 15),
                      const Text(
                        "remove_task",
                        style: TextStyle(color: Colors.red),
                      ).tr(),
                    ],
                  ),
                  key: Key(currentElement.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStorage.deleteTask(task: currentElement);
                    setState(() {});
                  },
                  child: TaskItem(
                    task: currentElement,
                  ),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(child: const Text("empty_task_list").tr()),
    );
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.isNotEmpty) {
                  DatePicker.showTimePicker(
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var addNewTask = Task.create(value, time);
                      _allTasks.insert(0, addNewTask);
                      await _localStorage.addTask(task: addNewTask);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDB() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTasks: _allTasks));
    _getAllTaskFromDB();
  }
}
