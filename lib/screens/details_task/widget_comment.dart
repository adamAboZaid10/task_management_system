import 'package:flutter/material.dart';
import 'package:projectcompany/screens/account_screen/account_screen.dart';

class WidgetComment extends StatefulWidget {
  String imageUrl;
  String nameUser;
  String comment;
  String commenterId;
  WidgetComment({
    super.key,
    required this.imageUrl,
    required this.comment,
    required this.nameUser,
    required this.commenterId,
  });
  @override
  State<WidgetComment> createState() => _WidgetCommentState();
}

class _WidgetCommentState extends State<WidgetComment> {
  List<Color> color = [
    Colors.pink.shade700,
    Colors.red,
    Colors.blue,
    Colors.brown,
    Colors.green,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    color.shuffle();
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AccountScreen(
                      uid: widget.commenterId,
                    )));
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: color[0]),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.fill,
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nameUser,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.comment),
            ],
          ),
        ],
      ),
    );
  }
}
