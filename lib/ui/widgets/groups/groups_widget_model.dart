import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_hive/domain/data_provider/box_manager.dart';
import 'package:to_do_hive/domain/entity/group.dart';
import 'package:to_do_hive/ui/navigation/main_navigation.dart';
import 'package:to_do_hive/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null && context.mounted) {
      final configuration = TasksWidgetConfiguration(
        groupKey: group.key as int,
        title: group.name,
      );
      Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.tasks, arguments: configuration);
    }
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(groupIndex);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox((await _box));
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  // ignore: annotate_overrides, overridden_fields
  final Widget child;

  static GroupsWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }
}
