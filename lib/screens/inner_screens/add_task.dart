import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/constant/constant_uses.dart';
import 'package:projectcompany/layout_screen/tasks_screen.dart';
import 'package:uuid/uuid.dart';

import '../../constant/constant_screen.dart';
import '../widgets/drawer_widget_screen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

var categoryController = TextEditingController();

class _AddTaskScreenState extends State<AddTaskScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Constant object = Constant();
  DateTime? picked;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      drawer: DrawerScreen(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      child: Text(
                        'All field are required',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    textAllField(text: 'Task Category*'),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return object.alterDialogCategoryWidget(
                              context: context,
                              size: size,
                              button: TextButton(
                                onPressed: () {},
                                child: Text(
                                  '',
                                  style: TextStyle(color: Colors.pink.shade700),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: textFormField(
                        enabled: false,
                        controller: categoryController,
                        onTap: () {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your category';
                          }
                          return null;
                        },
                        hintText: 'task category',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textAllField(text: 'Task title*'),
                    textFormField(
                      controller: titleController,
                      maxLength: 100,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your title';
                        }
                        return null;
                      },
                      hintText: 'enter your title',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textAllField(text: 'Task description*'),
                    textFormField(
                      controller: descriptionController,
                      maxLength: 1000,
                      maxLine: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your description';
                        }
                        return null;
                      },
                      hintText: 'enter your description',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textAllField(text: 'Deadline date*'),
                    InkWell(
                      onTap: () {
                        pickedDate();
                      },
                      child: textFormField(
                        enabled: false,
                        controller: dateController,
                        onTap: () {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your deadline date';
                          }
                          return null;
                        },
                        hintText: 'pick up a date',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      child: MaterialButton(
                        color: Colors.pink.shade700,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final taskId = const Uuid().v4();
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(taskId)
                                .set({
                              'taskId': taskId,
                              'uploadedBy': uid,
                              'createdAt': Timestamp.now().toDate().toString(),
                              'isDone': false,
                              'taskCategory': categoryController.text,
                              'titleTask': titleController.text,
                              'descTask': descriptionController.text,
                              'date': dateController.text,
                              'taskComments': [],
                            });
                            showToast(
                                text: 'done uploaded',
                                state: ToastStates.SUCCESS);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TasksScreen()));
                          }
                        },
                        child: const Text(
                          'upLoad',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickedDate() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 5)),
      lastDate: DateTime(2029),
    );
    if (picked != null) {
      setState(() {
        dateController.text = '${picked!.year}-${picked!.month}-${picked!.day}';
      });
    }
  }

  Widget textAllField({
    required String text,
  }) =>
      Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade700),
      );

  Widget textFormField({
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required String hintText,
    int? maxLine,
    int? maxLength,
    bool? enabled,
    GestureTapCallback? onTap,
  }) =>
      TextFormField(
        onTap: onTap,
        maxLines: maxLine,
        maxLength: maxLength,
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.text,
        validator: validator,
        style: TextStyle(
          color: Colors.black,
          backgroundColor: Colors.grey[300],
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade300,
          hintText: hintText,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.pink.shade700,
            ),
          ),
        ),
      );
}
