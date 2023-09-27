import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject{
  
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  final DateTime creationTime;
  
  @HiveField(3)
  bool isCompleted;

  Task(
      {required this.id,
      required this.name,
      required this.creationTime,
      required this.isCompleted});

  factory Task.create(String name, DateTime creationTime) {
    return Task(
        id: const Uuid().v1(),
        name: name,
        creationTime: creationTime,
        isCompleted: false);
  }
}