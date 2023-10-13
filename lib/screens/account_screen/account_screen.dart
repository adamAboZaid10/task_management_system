import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../user_state.dart';

class AccountScreen extends StatefulWidget {
  final String uid;
  const AccountScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

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
        setState(() {
          isSamUser = uid == widget.uid;
        });
        print('isSamUser $isSamUser');
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
    var textStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
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
        backgroundColor: Colors.grey.shade300,
      ),
      body: isLoading == false
          ? Center(
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.grey.shade300,
                  surfaceTintColor: Colors.grey.shade300,
                  elevation: 0,
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: Stack(
                    //clipBehavior: Clip.hardEdge,
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          left: 20.0,
                          right: 20.0,
                          top: 40,
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                              left: 20.0,
                              right: 20.0,
                              top: 20,
                            ),
                            child: Column(children: [
                              const SizedBox(
                                height: 80,
                              ),
                              Text(
                                name,
                                style: textStyle,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Expanded(
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        job,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    joinedAt,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Contact Info',
                                    style: textStyle,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_circle_down_outlined,
                                    color: Colors.pink.shade700,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Email: ',
                                    style: textStyle,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Phone number: ',
                                    style: textStyle,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      phoneNumber,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              isSamUser
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        iconsPhone(
                                            iconData: Icons.message,
                                            onPressed: () {
                                              openWhatsAppChat();
                                            }),
                                        iconsPhone(
                                            iconData: Icons.email,
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              openMail();
                                            }),
                                        iconsPhone(
                                            iconData: Icons.phone,
                                            color: Colors.purple,
                                            onPressed: () {
                                              openCallNumber();
                                            }),
                                      ],
                                    ),
                              const SizedBox(
                                height: 15,
                              ),
                              isSamUser
                                  ? Container()
                                  : const Divider(
                                      thickness: 1,
                                    ),
                              const SizedBox(
                                height: 15,
                              ),
                              MaterialButton(
                                color: Colors.pink.shade700,
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
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 5, color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void openWhatsAppChat() async {
    var url = 'http://wa.me/$phoneNumber?text=HelloThere';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error happen couInd\' open link';
    }
  }

  void openMail() async {
    String mail = email;
    var url = 'mailto:$mail';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error happen couInd\' open link';
    }
  }

  void openCallNumber() async {
    var url = 'tel://$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error happen couInd\' open link';
    }
  }

  Widget iconsPhone({
    Color color = Colors.green,
    required IconData iconData,
    required GestureTapCallback? onPressed,
  }) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            color: color,
            size: 30,
          ),
        ),
      );
}
