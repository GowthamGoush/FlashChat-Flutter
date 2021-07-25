import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/bubble_message.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  bool showProgressBar = false;

  User currentUser;
  String text;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() {
    try {
      if (_auth.currentUser != null) {
        currentUser = _auth.currentUser;
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: LoadingOverlay(
        isLoading: showProgressBar,
        child: SafeArea(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: _fireStore.collection('messages').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      showProgressBar = true;
                      return Center();
                    } else {
                      showProgressBar = false;
                    }

                    final messages = snapshot.data.docs.reversed;
                    List<BubbleMessage> bubbleMessages = [];

                    for (var message in messages) {
                      final text = message.get('text');
                      final sender = message.get('sender');

                      bubbleMessages.add(BubbleMessage(
                        text: text,
                        sender: sender,
                        isUser: sender == currentUser.email,
                      ));
                    }

                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: bubbleMessages,
                      ),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            text = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          _fireStore
                              .collection("messages")
                              .add({'text': text, 'sender': currentUser.email});
                          messageTextController.clear();
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
