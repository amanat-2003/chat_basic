import 'package:chat_basic/models/chat.dart';
import 'package:chat_basic/utils/logger.dart';
import 'package:chat_basic/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatWidget extends StatefulWidget {
  const NewChatWidget({super.key});

  @override
  State<NewChatWidget> createState() => _NewChatWidgetState();
}

class _NewChatWidgetState extends State<NewChatWidget> {
  void _sendChat() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    text.log();
    final currentUser = FirebaseAuth.instance.currentUser!;
    final firestoreInstance = FirebaseFirestore.instance;
    final id = currentUser.uid;
    id.log();
    try {
      final userData =
          await firestoreInstance.collection('users').doc(id).get();

      await firestoreInstance.collection('chats').add({
        ...Chat(
          text: text,
          imageUrl: userData['imageUrl'],
          userName: userData['userName'],
          userId: id,
        ).toMap(),
        'dateTime': Timestamp.now()
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.toString());
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10, right: 1),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: FocusNode(),
              decoration: const InputDecoration(
                labelText: 'Type something...',
              ),
            ),
          ),
          IconButton(
            onPressed: _sendChat,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
