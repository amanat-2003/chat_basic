import 'package:chat_basic/widgets/chats.dart';
import 'package:chat_basic/widgets/new_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final authInstance = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpPushNotifications() async {
    final fmi = FirebaseMessaging.instance;
    fmi.requestPermission();
    // (await fmi.getToken())?.log();
    fmi.subscribeToTopic('chats');
  }

  @override
  void initState() {
    super.initState();
    setUpPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Basic'),
          actions: [
            IconButton(
                onPressed: () {
                  authInstance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: const Column(
          children: [
            ChatsWidget(),
            NewChatWidget(),
          ],
        ));
  }
}
