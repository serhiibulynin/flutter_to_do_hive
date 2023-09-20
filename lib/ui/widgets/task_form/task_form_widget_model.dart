import 'package:flutter/material.dart';
import 'package:to_do_hive/domain/data_provider/box_manager.dart';
import 'package:to_do_hive/domain/entity/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskName = '';

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskName.isEmpty) return;
    final task = Task(text: taskName, isDone: false);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    await BoxManager.instance.closeBox(box);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;
  const TaskFormWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(child: child);

  @override
  // ignore: overridden_fields
  final Widget child;

  static TaskFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}
