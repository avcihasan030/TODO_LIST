import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _nameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localStorage = locator<LocalStorage>();
    // _nameController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            widget.task.isCompleted
                ? BoxShadow(color: Colors.green.withOpacity(.3), blurRadius: 10)
                : BoxShadow(
                    color: Colors.black87.withOpacity(.2), blurRadius: 10),
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: widget.task.isCompleted
              ? const Icon(Icons.done, color: Colors.green)
              : Icon(
                  Icons.done_outlined,
                  color: Colors.black87.withOpacity(0.2),
                ),
        ),
        title: widget.task.isCompleted
            ? Text(widget.task.name)
            : TextField(
                controller: _nameController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.task.name = value;
                    _localStorage.updateTask(task: widget.task);
                  }
                },
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.done,
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.creationTime),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
