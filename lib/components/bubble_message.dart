import 'package:flutter/material.dart';

class BubbleMessage extends StatelessWidget {
  BubbleMessage({this.text, this.sender, this.isUser});

  final String text;
  final String sender;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topLeft: isUser ? Radius.circular(30.0) : Radius.zero,
              topRight: isUser ? Radius.zero : Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isUser ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                text,
                style: TextStyle(
                    color: isUser ? Colors.white : Colors.lightBlueAccent,
                    fontSize: 15.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
