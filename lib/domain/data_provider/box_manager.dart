import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_hive/domain/entity/group.dart';
import 'package:to_do_hive/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};

  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox("groupsBox", 1, GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(makeTaskBoxName(groupKey), 2, TaskAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
    }
    var count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if (count > 0) return;

    _boxCounter.remove(box.name);
    box.compact();
    box.close();
  }

  String makeTaskBoxName(int groupKey) => "tasksBox$groupKey";

  Future<Box<T>> _openBox<T>(
    String name,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }
    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }
}
