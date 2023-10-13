import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectcompany/constant/constant_screen.dart';
import 'package:projectcompany/screens/widgets/show_error_in_create_andsign.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

var positionController = TextEditingController();

class _LoginScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin //this mixin for use animation
{
  late AnimationController _animationController;
  late Animation<double> _animation;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode positionFocusNode = FocusNode();
  File? selectedImage;

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;

  @override
  //this method use to delete screen when move one screen to other
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    passFocusNode.dispose();
    positionFocusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          seconds: 20,
        ));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constant classConstant = Constant();
    return Scaffold(
      body: Stack(
        children: [
          //with animation
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            //because call animation
            alignment: FractionalOffset(_animation.value, 0),
            imageUrl:
                "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) => Image.asset(
              "assets/images/wallpaper.jpg",
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                    text: 'already have an account?    ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  TextSpan(
                    text: 'SignUp now..',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                    style: TextStyle(
                      color: Colors.blue.shade300,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ])),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: TextFormField(
                              focusNode: fullNameFocusNode,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(emailFocusNode),
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'name must not be empty';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.white,
                                ),
                                hintText: 'full name',
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.pink.shade700)),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, right: 10),
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: selectedImage == null
                                        ? Image.network(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                                        : Image.file(
                                            selectedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.pink.shade700,
                                    radius: 18,
                                    child: IconButton(
                                        iconSize: 20,
                                        alignment: Alignment.topRight,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                showDialogImage(),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'email must not be empty';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          hintText: 'email',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700)),
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        focusNode: passFocusNode,
                        controller: passwordController,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(positionFocusNode),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscureText,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'password must not be empty';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                          ),
                          hintText: 'password',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700)),
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        focusNode: phoneFocusNode,
                        controller: phoneController,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(positionFocusNode),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'phone must not be empty';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          hintText: 'phone',
                          hintStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.pink.shade700)),
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                classConstant.alterDialogJopWidget(
                              context: context,
                              size: size,
                            ),
                          );
                        },
                        child: TextFormField(
                          enabled: false,
                          focusNode: positionFocusNode,
                          controller: positionController,
                          onEditingComplete: () => submitFormOnLogin(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'what is  position in the company ?';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                            hintText: 'position in the company',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.pink.shade700)),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                      side: BorderSide.none),
                  onPressed: submitFormOnLogin,
                  color: Colors.pink.shade700,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Register  ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        await auth.createUserWithEmailAndPassword(
            email: emailController.text.toLowerCase().trim(),
            password: passwordController.text);
        var uid = FirebaseAuth.instance.currentUser!.uid;
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('$uid.jpg');
        await ref.putFile(selectedImage!);
        var url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'position': positionController.text,
          'imageProfile': url,
          'createDate': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        ShowDialogError.showDialogErrorCreateUser(
            error: error.toString(), context: context);
      }
    } else {
      print('form not valid');
    }
    setState(() {
      isLoading = false;
    });
  }

  final picker = ImagePicker();
  Future<void> getCameraImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    cutImage(pickedFile!.path);
  }

  Future<void> getGallaryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    cutImage(pickedFile!.path);
  }

  //for cut image that take
  void cutImage(filePath) async {
    final cutPhoto = await ImageCropper().cropImage(sourcePath: filePath);
    if (cutPhoto != null) {
      setState(() {
        selectedImage = File(cutPhoto.path);
        Navigator.pop(context);
      });
    }
  }

  //for take image

  Widget showDialogImage() => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            content: Column(
              children: [
                const Text(
                  'Please choose an option',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 5,
                ),
                MaterialButton(
                  onPressed: () {
                    getCameraImage();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.pink.shade700,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(' Camera',
                            style: TextStyle(
                              color: Colors.pink.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    getGallaryImage();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.pink.shade700,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(' Gallery',
                            style: TextStyle(
                              color: Colors.pink.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
