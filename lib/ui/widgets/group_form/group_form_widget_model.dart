import 'package:flutter/material.dart';
import 'package:to_do_hive/domain/data_provider/box_manager.dart';
import 'package:to_do_hive/domain/entity/group.dart';

class GroupFormWidgetModel {
  var groupName = '';

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(child: child);

  @override
  // ignore: overridden_fields
  final Widget child;

  static GroupFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return false;
  }
}
