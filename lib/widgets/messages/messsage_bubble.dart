import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String username;
  final bool isMe;
  final String imageUrl;
  final String sharedImage;

  MessageBubble(
      {this.username, this.text, this.imageUrl, this.isMe, this.sharedImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Material(
                    elevation: 5,
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))
                        : BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                    color: isMe ? Color(0xff058af7) : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          sharedImage == null
                              ? Text(
                                  text,
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: isMe ? Colors.white : Colors.black,
                                      fontSize: 20),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Image.network(sharedImage,fit: BoxFit.cover,) ,
                                ),
                        ],
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
