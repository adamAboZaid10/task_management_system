import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/constant/constant_screen.dart';
import 'package:projectcompany/screens/widgets/drawer_widget_screen.dart';
import 'package:projectcompany/screens/widgets/task_widget.dart';

import '../screens/inner_screens/add_task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Constant object = Constant();
  String? tasksCategory;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey[300],
        title: Text(
          'Tasks',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.pink.shade700),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return alterDialogCategory(
                          context: context,
                          size: size,
                          button: TextButton(
                            onPressed: () {
                              setState(() {
                                tasksCategory = null;
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel Filter',
                              style: TextStyle(color: Colors.pink.shade700),
                            ),
                          ));
                    });
              },
              icon: const Icon(Icons.filter_list))
        ],
      ),
      drawer: DrawerScreen(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('taskCategory', isEqualTo: tasksCategory)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => TaskWidget(
                  title: snapshot.data!.docs[index]['titleTask'],
                  description: snapshot.data!.docs[index]['descTask'],
                  isDone: snapshot.data!.docs[index]['isDone'],
                  category: snapshot.data!.docs[index]['taskCategory'],
                  uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                  taskId: snapshot.data!.docs[index]['taskId'],
                ),
              );
            }
          } else {
            return const Center(
              child: Text('no user has been uploaded'),
            );
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }

  Widget alterDialogCategory({
    size,
    required context,
    GestureTapCallback? cancelFilter,
    String? cancel,
    TextButton? button,
  }) =>
      AlertDialog(
        title: Text(
          'Task category',
          style: TextStyle(color: Colors.pink.shade700),
        ),
        content: SizedBox(
          width: size.width * .9,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: Constant.taskCategory.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                categoryController.text = Constant.taskCategory[index];
                setState(() {
                  tasksCategory = Constant.taskCategory[index];
                });
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.gpp_good,
                    color: Colors.pink.shade700,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Constant.taskCategory[index],
                    style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.pink.shade700),
            ),
          ),
          button!
        ],
      );
}
