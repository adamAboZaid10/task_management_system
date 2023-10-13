import 'package:flutter/material.dart';

class ShowDialogError{
  static void showDialogErrorCreateUser(
      {
        required String error,
        BuildContext? context,
      })=> showDialog(
    context:context!,
    builder: (context)=>Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          shape:const  RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          content: Column(
            children:
            [
              Text(
                'error is there : $error',
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

            ],
          ),
        ),
      ),
    ),
  );
}