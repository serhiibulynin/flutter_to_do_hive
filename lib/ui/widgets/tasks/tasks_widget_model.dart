import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_hive/domain/data_provider/box_manager.dart';
import 'package:to_do_hive/domain/entity/task.dart';
import 'package:to_do_hive/ui/navigation/main_navigation.dart';
import 'package:to_do_hive/ui/widgets/tasks/tasks_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  TasksWidgetConfiguration configuration;
  ValueListenable<Object>? _listenableBox;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.taskForm,
        arguments: configuration.groupKey);
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> doneToggle(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);
    await _readTasksFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
        );

  @override
  // ignore: overridden_fields
  final Widget child;

  static TasksWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }
}
