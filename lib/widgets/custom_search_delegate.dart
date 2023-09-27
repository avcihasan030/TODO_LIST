import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTasks;

  CustomSearchDelegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.red,
        size: 24,
      ),
      onTap: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var currentElement = filteredList[index];
              return Dismissible(
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 15),
                    Text(
                      "remove_task".tr(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                key: Key(currentElement.id),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await locator<LocalStorage>()
                      .deleteTask(task: currentElement);
                },
                child: TaskItem(
                  task: currentElement,
                ),
              );
            },
            itemCount: filteredList.length,
          )
        : Center(
            child: const Text("not_match_found").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
