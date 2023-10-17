// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_basic/models/chat.dart';

enum SentBy {
  me,
  others,
}

class ChatBoxWidget extends StatelessWidget {
  final double screenWidth;
  final Chat chat;
  final bool isFirstMessage;
  final bool isSentByMe;

  const ChatBoxWidget.first({
    Key? key,
    required this.chat,
    required this.isSentByMe,
    required this.screenWidth,
  })  : isFirstMessage = true,
        super(key: key);

  const ChatBoxWidget.notFirst({
    Key? key,
    required this.chat,
    required this.isSentByMe,
    required this.screenWidth,
  })  : isFirstMessage = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          height: 10,
        ),
        Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            if (isFirstMessage && !isSentByMe)
              CircleAvatar(
                backgroundImage: NetworkImage(chat.imageUrl),
                radius: 20,
              ),
            if (!(isFirstMessage && !isSentByMe))
              const SizedBox(
                width: 40,
              ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              constraints: BoxConstraints(maxWidth: screenWidth * 4 / 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: isSentByMe && isFirstMessage
                      ? Radius.zero
                      : const Radius.circular(10),
                  topLeft: !isSentByMe && isFirstMessage
                      ? Radius.zero
                      : const Radius.circular(10),
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
                border:
                    Border.all(color: isSentByMe ? Colors.green : Colors.grey),
                color: isSentByMe
                    ? const Color.fromARGB(255, 239, 255, 239)
                    : Colors.white,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isFirstMessage)
                    Container(
                      color: Colors.grey.shade300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            chat.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  Text(chat.text),
                ],
              ),
            ),
            if (!(isFirstMessage && isSentByMe)) const SizedBox(width: 40),
            if (isFirstMessage && isSentByMe)
              CircleAvatar(
                backgroundImage: NetworkImage(chat.imageUrl),
                radius: 20,
              ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
