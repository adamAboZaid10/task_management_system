import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/screens/account_screen/account_screen.dart';
import 'package:projectcompany/user_state.dart';

import '../../layout_screen/tasks_screen.dart';
import '../all_worker/all_workers.dart';
import '../inner_screens/add_task.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  bool isLoading = false;
  String name = '';
  String phoneNumber = '';
  String email = '';
  String job = '';
  String imageUrl = '';
  String joinedAt = '';
  bool isSamUser = false;

  void getUserData() async {
    isLoading = true;
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phone');
          job = userDoc.get('position');
          imageUrl = userDoc.get('imageProfile');
          Timestamp joinTimeStamp = userDoc.get('createDate');
          var joinData = joinTimeStamp.toDate();
          joinedAt = '${joinData.year}-${joinData.month}-${joinData.day}';
        });
        User? user = FirebaseAuth.instance.currentUser;
        String uid = user!.uid;
        //TODO check if same user;
      }
    } catch (error) {
      print(error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: size.height * .3,
            color: Colors.cyan,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                  radius: 35,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  job,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                itemDrawer(
                    icon: Icons.list_alt_rounded,
                    text: 'All Tasks',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TasksScreen()),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                itemDrawer(
                    icon: Icons.settings,
                    text: 'My Account',
                    onTap: () {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountScreen(
                                  uid: uid,
                                )),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                itemDrawer(
                    icon: Icons.how_to_reg,
                    text: 'Registered Workers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllWorkersScreen()),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                itemDrawer(
                    icon: Icons.add,
                    text: 'Add Task',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddTaskScreen()));
                    }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(
                  height: 20,
                ),
                itemDrawer(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.cyan,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Sign out'),
                              ],
                            ),
                            content: const Text(
                              'Do you wanna Sign out?',
                              style: TextStyle(fontSize: 14),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel ',
                                        style: TextStyle(
                                          color: Colors.cyan,
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.canPop(context)
                                            ? Navigator.pop(context)
                                            : null;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserState()),
                                        );
                                      },
                                      child: const Text(
                                        'Ok ',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDrawer({
    required IconData? icon,
    required String? text,
    required GestureTapCallback? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
            ),
            Text(
              text!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
}
