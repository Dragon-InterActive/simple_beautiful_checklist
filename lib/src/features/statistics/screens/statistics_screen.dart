import 'package:flutter/material.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';
import 'package:simple_beautiful_checklist_exercise/src/features/statistics/widgets/task_counter_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({
    super.key,
    required this.repository,
  });

  final DatabaseRepository repository;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int currentTaskCount = 0;
  int deletedTasksCount = 0;

  void loadItemCount() async {
    int taskCount = await widget.repository.getItemCount();
    int deletedCount = await widget.repository.getDeletedCount();

    if (taskCount != currentTaskCount || deletedCount != deletedTasksCount) {
      setState(() {
        currentTaskCount = taskCount;
        deletedTasksCount = deletedCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadItemCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task-Statistik"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            TaskCounterCard(
              taskCount: currentTaskCount,
              deletedCount: deletedTasksCount,
            ),
          ],
        ),
      ),
    );
  }
}
