import 'package:flutter/material.dart';

import '../screens/ath/register.dart';
import '../screens/inner_screens/add_task.dart';

class Constant {
  static List<String> taskCategory = [
    'Business',
    'Programming',
    'Information Technology',
    'Human Resource',
    'Marketing',
    'Design',
    'Accounting',
  ];
  static List<String> jobList = [
    'manager',
    'team leader',
    'designer',
    'web design',
    'full stack developer',
    'mobile developer',
    'Marketing',
    'digital marketing',
  ];

  Widget alterDialogCategoryWidget({
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

  Widget alterDialogJopWidget({
    size,
    required context,
    GestureTapCallback? cancelFilter,
    String? cancel,
  }) =>
      AlertDialog(
        title: Text(
          'Jop List',
          style: TextStyle(color: Colors.pink.shade700),
        ),
        content: SizedBox(
          width: size.width * .9,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: Constant.jobList.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                positionController.text = Constant.jobList[index];
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
                    Constant.jobList[index],
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
        ],
      );
}
