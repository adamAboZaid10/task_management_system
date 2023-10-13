import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/constant/constant_uses.dart';

import '../details_task/detials_task.dart';

class TaskWidget extends StatefulWidget {
  String title;
  String description;
  String uploadedBy;
  bool isDone;
  String category;
  String taskId;
  TaskWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.category,
    required this.uploadedBy,
    required this.isDone,
    required this.taskId,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 13,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsTaskScreen(
                      uploadBy: widget.uploadedBy,
                      taskId: widget.taskId,
                    )),
          );
        },
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  actions: [
                    TextButton(
                        onPressed: () async {
                          var uid = FirebaseAuth.instance.currentUser!.uid;
                          if (uid == widget.uploadedBy) {
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(widget.taskId)
                                .delete();
                            showToast(
                                text: 'your task Deleted',
                                state: ToastStates.SUCCESS);
                          } else {
                            showToast(
                                text: 'this task did not upload by you',
                                state: ToastStates.ERROR);
                          }
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        )),
                  ],
                );
              });
        },
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
              border: Border(right: BorderSide(width: 1.0))),
          child: CircleAvatar(
            radius: 20,
            child: Image.network(
              widget.isDone
                  ? 'https://t3.ftcdn.net/jpg/02/01/30/82/360_F_201308263_ylhTkL69sCEDKWXlXu2S4rumX4JZqb4f.jpg'
                  : 'https://cdn-icons-png.flaticon.com/512/4388/4388350.png',
            ),
          ),
        ),
        title: Text(
          widget.category,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade700,
            ),
            Text(
              '${widget.description} :: ${widget.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.pink.shade700,
        ),
      ),
    );
  }
}
