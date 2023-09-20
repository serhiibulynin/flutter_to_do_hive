import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_hive/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupsWidgetBody(),
    );
  }

  @override
  void dispose() async {
    await _model.dispose();
    super.dispose();
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  // ignore: unused_element
  const _GroupsWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Groups"),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GroupsWidgetModelProvider.of(context)?.model.showForm(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  // ignore: unused_element
  const _GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.of(context)?.model.groups.length ?? 0;
    return ListView.separated(
      itemCount: groupsCount,
      itemBuilder: (BuildContext context, int index) {
        return _GroupListRowWidget(
          indexInList: index,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 3,
        );
      },
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  // ignore: unused_element
  const _GroupListRowWidget({super.key, required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.of(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteGroup(indexInList),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => model.showTasks(context, indexInList),
      ),
    );
  }
}
