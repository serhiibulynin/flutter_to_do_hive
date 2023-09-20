import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_hive/ui/widgets/tasks/tasks_widget_model.dart';

class TasksWidgetConfiguration {
  final int groupKey;
  final String title;

  TasksWidgetConfiguration({
    required this.groupKey,
    required this.title,
  });
}

class TasksWidget extends StatefulWidget {
  final TasksWidgetConfiguration configuration;
  const TasksWidget({
    super.key,
    required this.configuration,
  });

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }

  @override
  void dispose() async {
    await _model.dispose();
    super.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context)?.model;
    final title = model?.configuration.title ?? 'Task';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  // ignore: unused_element
  const _TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksCount =
        TasksWidgetModelProvider.of(context)?.model.tasks.length ?? 0;
    return ListView.separated(
      itemCount: tasksCount,
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
    final model = TasksWidgetModelProvider.of(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone
        ? const TextStyle(
            decoration: TextDecoration.lineThrough,
          )
        : null;
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.text,
          style: style,
        ),
        trailing: Icon(icon),
        onTap: () => {model.doneToggle(indexInList)},
      ),
    );
  }
}
