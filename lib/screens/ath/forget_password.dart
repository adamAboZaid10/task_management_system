import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin
{
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20)
    );
    _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear)..addListener(() {
          setState(() {

          });
    })..addStatusListener((animationStatus) {
      if(animationStatus == AnimationStatus.completed){
        _animationController.reset();
        _animationController.forward();
      }
    });_animationController.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(
        children:
        [
          CachedNetworkImage(
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            //now call animation
            alignment: FractionalOffset(_animation.value,0),
            imageUrl: "https://media.istockphoto.com/photos/businesswoman-using-computer-in-dark-office-picture-id557608443?k=6&m=557608443&s=612x612&w=0&h=fWWESl6nk7T6ufo4sRjRBSeSiaiVYAzVrY-CLlfMptM=",
            placeholder: (context, url) =>Image.asset(
              "assets/images/wallpaper.jpg",
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                SizedBox(height: size.height * 0.1,),
                const Text(
                    'Forget password',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height:15,),
                const Text(
                  'Forget password',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height:15,),
                Form(
                  key: _formKey,
                  child: Container(
                    color: Colors.white,
                    child: TextFormField(
                      controller:emailController ,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value!.isEmpty||!value.contains('@')){
                          return 'email must not be empty';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration:  InputDecoration(
                        prefixIcon:const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        enabledBorder:const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade700)
                        ),
                        errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:20,),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    color: Colors.pink.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                        side: BorderSide.none,
                    ),
                    onPressed: forgetPasswordFCT,
                    child: const Padding(
                      padding:  EdgeInsets.symmetric(vertical: 10.0),
                      child:  Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  void forgetPasswordFCT()
  {
    print('password controller ${emailController.text}');
  }
}
