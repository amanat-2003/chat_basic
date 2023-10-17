import 'package:chat_basic/models/chat.dart';
import 'package:chat_basic/widgets/chat_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ChatsWidget extends StatelessWidget {
  const ChatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final screenWidth = MediaQuery.of(context).size.width;
    final firestoreInstance = FirebaseFirestore.instance;
    return Expanded(
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onVerticalDragDown,
        ],
        child: StreamBuilder(
          stream: firestoreInstance
              .collection('chats')
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder: (context, chatsSnapshot) {
            if (chatsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!chatsSnapshot.hasData || chatsSnapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No chat is done. Start with something with ❤️'));
            }

            if (chatsSnapshot.hasError) {
              return const Center(child: Text('Oh no... an error occured!!'));
            }

            final chatsList = chatsSnapshot.data!.docs;

            return ListView.builder(
              itemCount: chatsList.length,
              reverse: true,
              itemBuilder: (context, index) {
                final chatMap = chatsList[index].data();
                final chat = Chat.fromMap(chatMap);
                final previousChatUserId = index + 1 < chatsList.length
                    ? chatsList[index + 1].data()['userId']
                    : null;
                final isFirstInSequence = !(chat.userId == previousChatUserId);
                final isSentByMe = chat.userId == currentUserId;
                // '${chat.text} - isFirstInSequence = $isFirstInSequence'.log();
                // 'previousChatUserId = $previousChatUserId'.log();
                // 'currentUserId = $currentUserId \n'.log();

                if (isFirstInSequence) {
                  return ChatBoxWidget.first(
                    chat: chat,
                    isSentByMe: isSentByMe,
                    screenWidth: screenWidth,
                  );
                } else {
                  return ChatBoxWidget.notFirst(
                    chat: chat,
                    isSentByMe: isSentByMe,
                    screenWidth: screenWidth,
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

        // child: Column(
        //   children: [
        //     const SizedBox(width: double.infinity),
        //     ChatBoxWidget.first(
        //       chat: Chat(
        //           text: 'Hello ghow are you??',
        //           imageUrl:
        //               'https://firebasestorage.googleapis.com/v0/b/chat-basic-277a2.appspot.com/o/users_profile_images%2FaU4HbWjGpDZ5b5oF7tseFhfJwys2.jpg?alt=media&token=d65769eb-789a-46da-a0df-f0fdfc26f038',
        //           userName: 'ASD',
        //           userId: 'dsa43sWQWEdHDJAG'),
        //       screenWidth: screenWidth,
        //       isSentByMe: true,
        //     ),
        //   ],
        // ),