import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectcompany/constant/constant_screen.dart';
import 'package:projectcompany/screens/widgets/drawer_widget_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../account_screen/account_screen.dart';

class AllWorkersScreen extends StatefulWidget {
  @override
  State<AllWorkersScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<AllWorkersScreen> {
  Constant object = Constant();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        title: Text(
          'All workers',
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
                      return object.alterDialogCategoryWidget(
                          context: context,
                          size: size,
                          button: TextButton(
                            onPressed: () {},
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
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShot.connectionState == ConnectionState.active) {
            if (snapShot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  return allWorkers(
                    userId: snapShot.data!.docs[index]['id'],
                    userName: snapShot.data!.docs[index]['name'],
                    userEmail: snapShot.data!.docs[index]['email'],
                    userImage: snapShot.data!.docs[index]['imageProfile'],
                    positionInCompany: snapShot.data!.docs[index]['position'],
                    date: snapShot.data!.docs[index]['createDate'],
                  );
                },
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

  Widget allWorkers({
    required String userId,
    required String userName,
    required String userEmail,
    required String positionInCompany,
    required String userImage,
    required Timestamp date,
  }) =>
      Card(
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
                  builder: (context) => AccountScreen(
                        uid: userId,
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
                          onPressed: () {},
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
              backgroundImage: NetworkImage(userImage),
            ),
          ),
          title: Text(
            userName,
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
                '$positionInCompany / ${date.toDate()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              openMail();
            },
            icon: Icon(
              Icons.mail_outline,
              color: Colors.pink.shade700,
            ),
          ),
        ),
      );

  String email = 'abdo@gmail.com';
  void openMail() async {
    String mail = email;
    var url = 'mailto:$mail';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error happen couInd\' open link';
    }
  }
}
