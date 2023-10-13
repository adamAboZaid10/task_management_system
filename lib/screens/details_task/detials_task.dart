import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/constant/constant_uses.dart';
import 'package:projectcompany/screens/details_task/widget_comment.dart';
import 'package:uuid/uuid.dart';

class DetailsTaskScreen extends StatefulWidget {
  final String uploadBy;
  final String taskId;
  const DetailsTaskScreen(
      {Key? key, required this.uploadBy, required this.taskId})
      : super(key: key);

  @override
  State<DetailsTaskScreen> createState() => _DetailsTaskScreenState();
}

class _DetailsTaskScreenState extends State<DetailsTaskScreen> {
  String userImage = '';
  String userName = '';
  String titleJob = '';
  String dateUpload = '';
  String deadlineDate = '';
  bool isDone = false;
  String descriptionTask = '';
  String nameTask = '';
  bool addComment = false;
  var commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getDetailsData();
    super.initState();
  }

  void getDetailsData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadBy)
        .get();
    setState(() {
      if (userDoc == null) {
        return;
      } else {
        userName = userDoc.get('name');
        userImage = userDoc.get('imageProfile');
        titleJob = userDoc.get('position');
      }
    });
    final DocumentSnapshot taskDoc = await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.taskId)
        .get();
    setState(() {
      if (taskDoc == null) {
        return;
      } else {
        dateUpload = taskDoc.get('createdAt');
        deadlineDate = taskDoc.get('date');
        isDone = taskDoc.get('isDone');
        nameTask = taskDoc.get('titleTask');
        descriptionTask = taskDoc.get('descTask');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Back',
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.grey.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                nameTask,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'uploaded by ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          const Spacer(),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 5, color: Colors.pink.shade700),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImage == null
                                        ? 'https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg'
                                        : userImage,
                                  ),
                                  fit: BoxFit.fill,
                                )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              Text(userName == null
                                  ? 'Adam AboZiad'
                                  : userName!),
                              Text(
                                titleJob == null
                                    ? 'Mobile Developer'
                                    : titleJob!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('uploaded on :', style: textStyle()),
                          const Spacer(),
                          Expanded(
                              child: Text(dateUpload,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle())),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('Deadline Date :', style: textStyle()),
                          const Spacer(),
                          Text(deadlineDate,
                              style: textStyle(color: Colors.pink.shade700)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          isDone ? 'Deadline Date done' : 'deadline not done',
                          style: isDone
                              ? const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.green,
                                )
                              : const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Done State :', style: textStyle()),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            onPressed: () async {
                              var uid = FirebaseAuth.instance.currentUser!.uid;
                              if (uid == widget.uploadBy) {
                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(widget.taskId)
                                    .update({'isDone': true});
                                getDetailsData();
                              } else {
                                showToast(
                                    text: 'this not your task',
                                    state: ToastStates.ERROR);
                              }
                            },
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          isDone == true
                              ? Container(
                                  width: 25,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                )
                              : Container(),
                          const SizedBox(
                            width: 60,
                          ),
                          TextButton(
                            child: const Text(
                              'Not Done yet ',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 17,
                              ),
                            ),
                            onPressed: () async {
                              var uid = FirebaseAuth.instance.currentUser!.uid;
                              if (uid == widget.uploadBy) {
                                await FirebaseFirestore.instance
                                    .collection('tasks')
                                    .doc(widget.taskId)
                                    .update({'isDone': false});
                                getDetailsData();
                              } else {
                                showToast(
                                    text: 'this not your tasks',
                                    state: ToastStates.ERROR);
                              }
                            },
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          isDone == false
                              ? Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade700,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Task Description:', style: textStyle()),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        descriptionTask,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: addComment
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      color: Colors.grey.shade300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          key: formKey,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 7) {
                                                return 'value must not be empty';
                                              }
                                              return null;
                                            },
                                            controller: commentController,
                                            maxLines: 6,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: 'add you comment',
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .pink.shade700)),
                                              errorBorder:
                                                  const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          color: Colors.pink.shade700,
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              final generatedId =
                                                  const Uuid().v4();
                                              await FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(widget.taskId)
                                                  .update({
                                                'taskComments':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'userId': widget.uploadBy,
                                                    'commentId': generatedId,
                                                    'name': userName,
                                                    'commentBody':
                                                        commentController.text,
                                                    'time': Timestamp.now(),
                                                    'imageUrl': userImage,
                                                  }
                                                ]),
                                              });
                                              showToast(
                                                  text: 'comment Uploaded',
                                                  state: ToastStates.SUCCESS);
                                              commentController.clear();
                                            }
                                          },
                                          child: Text(
                                            'Post',
                                            style: textStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              addComment = !addComment;
                                            });
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: textStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Center(
                                child: MaterialButton(
                                  color: Colors.pink.shade700,
                                  onPressed: () {
                                    setState(() {
                                      addComment = !addComment;
                                    });
                                  },
                                  child: Text(
                                    'Add a comment',
                                    style: textStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(widget.taskId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.data!['taskComments'].isNotEmpty) {
                                return ListView.separated(
                                  reverse: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    thickness: 1,
                                  ),
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data!['taskComments'].length,
                                  itemBuilder: (context, index) =>
                                      WidgetComment(
                                    imageUrl: snapshot.data!['taskComments']
                                        [index]['imageUrl'],
                                    comment: snapshot.data!['taskComments']
                                        [index]['commentBody'],
                                    nameUser: snapshot.data!['taskComments']
                                        [index]['name'],
                                    commenterId: snapshot.data!['taskComments']
                                        [index]['userId'],
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text('no comment yet now'),
                                );
                              }
                            } else {
                              return const Center(
                                child: Text('something error'),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle({
    Color color = Colors.black,
    double fontSize = 20,
  }) =>
      TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: color,
      );
}
