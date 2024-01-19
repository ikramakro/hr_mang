import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zego_zimkit/zego_zimkit.dart';

class CustomerChatScreen extends StatelessWidget {
  final String id;
  final String logo;
  final String name;
  const CustomerChatScreen(
      {super.key, required this.name, required this.logo, required this.id});

  @override
  Widget build(BuildContext context) {
    return ZIMKitMessageListPage(
      showPickFileButton: false,
      // showPickMediaButton: showPickFile,
      conversationID: id,
      conversationType: ZIMConversationType.peer,
      messageItemBuilder: (context, message, defaultWidget) {
        final formattedTimestamp = formatChatTimestamp(message.info.timestamp);
        final check = message.zim.senderUserID != id;
        return Padding(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            alignment: check ? Alignment.centerRight : Alignment.centerLeft,
            decoration: BoxDecoration(
                // color: PsColors.whiteColor,
                ),
            child: message.imageContent?.fileDownloadUrl != null
                ? MessageImageContent(
                    formattedTimestamp: formattedTimestamp,
                    message: message,
                    check: check,
                  )
                : message.videoContent?.fileDownloadUrl != null
                    ? Column(
                        crossAxisAlignment: check
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 400,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // message.videoContent?.fileDownloadUrl ==
                                    //         ''
                                    //     ? context
                                    //         .read<ChatProvider>()
                                    //         .showSnackbar(
                                    //             context, 'Video Error')
                                    //     : Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //           builder: (_) => VideoPlayerScreen(
                                    //               videoUrl: message
                                    //                       .videoContent
                                    //                       ?.fileDownloadUrl ??
                                    //                   '',
                                    //               text: message.videoContent
                                    //                       ?.fileName ??
                                    //                   ''),
                                    //         ),
                                    //       );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: message.info.sentStatus.name ==
                                                'failed'
                                            ? Colors.white
                                            : Colors.black,
                                        border: Border.all(
                                          color: Colors.amber,
                                        )),
                                    height: 400,
                                    width: 250,
                                    child: message.videoContent
                                                ?.fileDownloadUrl ==
                                            ''
                                        ? const Center(
                                            child: Icon(Icons.video_file),
                                          )
                                        : message.info.sentStatus.name ==
                                                'failed'
                                            ? const Center(
                                                child: Icon(
                                                    Icons.image_not_supported),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: message.videoContent
                                                        ?.videoFirstFrameDownloadUrl ??
                                                    '',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          const CupertinoActivityIndicator()),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    size: 20,
                                                  ),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                                message.videoContent?.fileDownloadUrl == ''
                                    ? Container()
                                    : Positioned(
                                        top: 200,
                                        left: 115,
                                        child: InkWell(
                                          onTap: () {
                                            // message.videoContent
                                            //             ?.fileDownloadUrl ==
                                            //         ''
                                            //     ? context
                                            //         .read<ChatProvider>()
                                            //         .showSnackbar(context,
                                            //             'Video Error')
                                            //     : Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder: (_) => VideoPlayerScreen(
                                            //               videoUrl: message
                                            //                       .videoContent
                                            //                       ?.fileDownloadUrl ??
                                            //                   '',
                                            //               text: message
                                            //                       .videoContent
                                            //                       ?.fileName ??
                                            //                   ''),
                                            //         ),
                                            //       );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.orange,
                                            ),
                                            width: 30,
                                            height: 30,
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          check
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formattedTimestamp,
                                      // style: HelperStyle.textStyle(
                                      //   context,
                                      //   PsColors.authHeaderColor,
                                      //   10.sp,
                                      //   FontWeight.w400,
                                      // ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    message.info.sentStatus.name == 'failed'
                                        ? Icon(
                                            Icons.error,
                                            size: 20,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.done_all,
                                            size: 20,
                                            color: Colors.orange,
                                          ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedTimestamp,
                                      // style: HelperStyle.textStyle(
                                      //   context,
                                      //   PsColors.authHeaderColor,
                                      //   10.sp,
                                      //   FontWeight.w400,
                                      // ),
                                    ),
                                  ],
                                )
                        ],
                      )
                    : MessageTextContent(
                        message: message,
                        check: check,
                        formattedTimestamp: formattedTimestamp,
                      ),
          ),
        );
      },
      inputDecoration: InputDecoration(
        // enabled: enabled,
        hintText: 'Write here...',
        // hintStyle: HelperStyle.textStyle(
        //   context,
        //   PsColors.walletHistoryText2Color,
        //   12.sp,
        //   FontWeight.w400,
        // ),
      ),
      appBarBuilder: (context, defaultAppBar) {
        return AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (logo == null || logo == '')
                SizedBox(
                  width: 26,
                  height: 26,
                  child: Image.asset(
                    '',
                  ),
                )
              else
                SizedBox(
                  width: 26,
                  height: 26,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    child: Image.network(
                      logo,
                    ),
                  ),
                ),
              SizedBox(
                width: 20,
              ),
              Text(
                name,
                // style: HelperStyle.textStyle(
                //   context,
                //   PsColors.blackColor,
                //   14.sp,
                //   FontWeight.w500,
                // ),
              ),
            ],
          ),
        );
      },
      theme: ThemeData(
        splashColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 1,
          // titleTextStyle: HelperStyle.textStyle(
          //   context,
          //   PsColors.blackColor,
          //   15.sp,
          //   FontWeight.w500,
          // ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class MessageImageContent extends StatelessWidget {
  const MessageImageContent({
    super.key,
    required this.formattedTimestamp,
    required this.message,
    required this.check,
  });
  final String formattedTimestamp;
  final ZIMKitMessage message;
  final bool check;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          check ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        InkWell(
          onLongPress: () {
            //provider.deleteChatImage(List<ZIMKitMessage>message);
          },
          onTap: () {
            // print(message.imageContent?.fileDownloadUrl);
            // message.imageContent?.fileDownloadUrl != ''
            //     ? Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => ImageViwer(
            //             imageUrl: message.imageContent!.fileDownloadUrl,
            //           ),
            //         ),
            //       )
            //     : context
            //         .read<ChatProvider>()
            //         .showSnackbar(context, 'Image Error');
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: message.info.sentStatus.name != 'failed'
                    ? Colors.amber
                    : Colors.amber,
              ),
            ),
            width: 200,
            height: 200,
            child: message.imageContent?.fileDownloadUrl == ''
                ? const Center(
                    child: Icon(Icons.image),
                  )
                : message.info.sentStatus.name == 'failed'
                    ? const Center(
                        child: Icon(Icons.image_not_supported),
                      )
                    : CachedNetworkImage(
                        imageUrl: message.imageContent!.fileDownloadUrl,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: const CupertinoActivityIndicator()),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.error,
                            size: 20,
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        check
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formattedTimestamp,
                    // style: HelperStyle.textStyle(
                    //   context,
                    //   PsColors.authHeaderColor,
                    //   10.sp,
                    //   FontWeight.w400,
                    // ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  message.info.sentStatus.name == 'failed'
                      ? Icon(
                          Icons.error,
                          size: 20,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.done_all,
                          size: 20,
                          color: Colors.orange,
                        ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    formattedTimestamp,
                    // style: HelperStyle.textStyle(
                    //   context,
                    //   PsColors.authHeaderColor,
                    //   10.sp,
                    //   FontWeight.w400,
                    // ),
                  ),
                ],
              )
      ],
    );
  }
}

class MessageTextContent extends StatelessWidget {
  const MessageTextContent({
    super.key,
    required this.check,
    required this.formattedTimestamp,
    required this.message,
  });

  final bool check;
  final String formattedTimestamp;
  final ZIMKitMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          check ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
              bottomLeft: Radius.circular(check ? 7 : 0),
              bottomRight: Radius.circular(check ? 0 : 7),
            ),
            color: check ? Colors.red : Colors.blue,
          ),
          child: Text(
            message.textContent?.text ?? '',
            // style: HelperStyle.textStyle(
            //   context,
            //   PsColors.whiteColor,
            //   14.sp,
            //   FontWeight.w500,
            // ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        check
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formattedTimestamp,
                    // style: HelperStyle.textStyle(
                    //   context,
                    //   PsColors.authHeaderColor,
                    //   10.sp,
                    //   FontWeight.w400,
                    // ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  message.info.sentStatus.name == 'failed'
                      ? Icon(
                          Icons.error,
                          size: 20,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.done_all,
                          size: 20,
                          color: Colors.amber,
                        ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    formattedTimestamp,
                    //   style: HelperStyle.textStyle(
                    //     context,
                    //     PsColors.authHeaderColor,
                    //     10.sp,
                    //     FontWeight.w400,
                    //   ),
                  ),
                ],
              )
      ],
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  // Use the intl package to format the date and time
  return DateFormat('HH:mm a').format(dateTime);
}

String formatChatTimestamp(int timestamp) {
  final now = DateTime.now();
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final timeDifference = now.difference(dateTime);

  if (timeDifference.inDays == 0 && timeDifference.inHours < 24) {
    return DateFormat.jm().format(dateTime); // Display time
  } else if (timeDifference.inDays == 1) {
    return 'Yesterday ${DateFormat.jm().format(dateTime)}';
  } else {
    return DateFormat.yMMMMd().add_jm().format(dateTime);
  }
}
