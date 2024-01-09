import 'package:flutter/material.dart';
import 'package:hr_management_system/head/chat_screen.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'My Messages',
          // style: HelperStyle.textStyle(
          //   PsColors.authHeaderColor,
          //   18.sp,
          //   FontWeight.w600,
          // ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
            // await model.loginCustomerChat();
          },
          child: Icon(Icons.arrow_back_outlined, color: Colors.amber),
        ),
      ),
      body: ZIMKitConversationListView(
        itemBuilder: (context, conversation, defaultWidget) {
          final count = conversation.unreadMessageCount;
          final timestamp = conversation.lastMessage?.info.timestamp;

          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CustomerChatScreen(
                    id: conversation.id,
                    logo: conversation.avatarUrl,
                    name: conversation.name,
                  );
                },
              ));
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.amber,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 34,
                                height: 34,
                                child: Image.asset('AppImage.dummyProfilePic,'),
                              ),
                              conversation.unreadMessageCount != 0
                                  ? Positioned(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF25D366),
                                          shape: BoxShape.circle,
                                        ),
                                        height: 20,
                                        width: 20,
                                        child: Text(
                                          conversation.unreadMessageCount == 99
                                              ? '99'
                                              : conversation
                                                          .unreadMessageCount >=
                                                      99
                                                  ? '99+'
                                                  : conversation
                                                      .unreadMessageCount
                                                      .toString(),
                                          // style: HelperStyle.textStyle(
                                          //   Colors.white,
                                          //   10.sp,
                                          //   FontWeight.w500,
                                          // ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation.name,
                              // style: HelperStyle.textStyle(
                              //   PsColors.blackColor,
                              //   14.sp,
                              //   FontWeight.w500,
                              // ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            SizedBox(
                              width: 150,
                              child: Text(
                                conversation.lastMessage?.textContent?.text ??
                                    'file',
                                overflow: TextOverflow.ellipsis,
                                // style: HelperStyle.textStyle(
                                //   PsColors.authHeaderColor,
                                //   12.sp,
                                //   FontWeight.w400,
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text(
                      'formattedTimestamp,',
                      // style: HelperStyle.textStyle(
                      //   conversation.unreadMessageCount != 0
                      //       ? const Color(0xFF25D366)
                      //       : PsColors.authHeaderColor,
                      //   10.sp,
                      //   FontWeight.w400,
                      // ),
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
