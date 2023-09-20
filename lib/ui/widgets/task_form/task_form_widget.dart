import 'package:flutter/material.dart';
import 'package:to_do_hive/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({super.key, required this.groupKey});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TaskFormWidgetBody(),
    );
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  // ignore: unused_element
  const _TaskFormWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New task"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            TaskFormWidgetModelProvider.of(context)?.model.saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskNameWidget extends StatelessWidget {
  // ignore: unused_element
  const _TaskNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.of(context)?.model;
    return TextField(
      autofocus: true,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Task name',
      ),
      onChanged: (value) => model?.taskName = value,
      onEditingComplete: () => model?.saveTask(context),
    );
  }
}
