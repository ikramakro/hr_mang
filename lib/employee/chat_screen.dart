import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      conversationID: id,
      conversationType: ZIMConversationType.peer,
      messageItemBuilder: (context, message, defaultWidget) {
        // final formattedTimestamp =
        //     provider1.formatChatTimestamp(message.info.timestamp);
        bool isValidUri(String uri) {
          try {
            Uri.parse(uri);
            return true;
          } catch (e) {
            return false;
          }
        }

        final check = message.zim.senderUserID != id;
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            alignment: check ? Alignment.centerRight : Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: message.imageContent?.fileDownloadUrl != null
                ? MessageImageContent(
                    formattedTimestamp: '01:34', //formattedTimestamp,
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: message.info.sentStatus.name ==
                                                  'failed'
                                              ? Colors.white
                                              : Colors.black,
                                          border: Border.all(
                                            color: Colors.orange,
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
                                                  child: Icon(Icons
                                                      .image_not_supported),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: message.videoContent
                                                          ?.videoFirstFrameDownloadUrl ??
                                                      '',
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CupertinoActivityIndicator()),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Center(
                                                    child: Icon(
                                                      Icons.error,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
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
                                            //         .read<
                                            //             ChatProvider>()
                                            //         .showSnackbar(
                                            //             context,
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
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.amber,
                                            ),
                                            width: 30,
                                            height: 30,
                                            child: const Icon(
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
                          const SizedBox(
                            height: 3,
                          ),
                          check
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text('12:23' // formattedTimestamp,
                                        // style: HelperStyle.textStyle(
                                        //   PsColors.authHeaderColor,
                                        //   10.sp,
                                        //   FontWeight.w400,
                                        // ),
                                        ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    message.info.sentStatus.name == 'failed'
                                        ? const Icon(
                                            Icons.error,
                                            size: 20,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.done_all,
                                            size: 20,
                                            color: Colors.amber,
                                          ),
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '11:40', //formattedTimestamp,
                                      // style: HelperStyle.textStyle(
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
                        formattedTimestamp: '12:244' //formattedTimestamp,
                        ),
          ),
        );
      },
      inputDecoration: const InputDecoration(
        hintText: 'Write here...',
        // hintStyle: HelperStyle.textStyle(
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
                  child: Image.asset(''
                      //AppImage.dummyProfilePic,
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
              const SizedBox(
                width: 20,
              ),
              Text(
                name,
                // style: HelperStyle.textStyle(
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
        scaffoldBackgroundColor: Colors.white, //PsColors.whiteColor,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          // titleTextStyle: HelperStyle.textStyle(
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
            // provider.deleteChatImage(List<ZIMKitMessage>message);
          },
          onTap: () {
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
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: message.imageContent?.fileDownloadUrl == ''
                    ? Colors.transparent
                    : Colors.orange,
                border: Border.all(
                  color: message.info.sentStatus.name != 'failed'
                      ? Colors.transparent
                      : Colors.orange,
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
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CupertinoActivityIndicator()),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error,
                              size: 20,
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        check
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formattedTimestamp,
                    // style: HelperStyle.textStyle(
                    //   PsColors.authHeaderColor,
                    //   10.sp,
                    //   FontWeight.w400,
                    // ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  message.info.sentStatus.name == 'failed'
                      ? const Icon(
                          Icons.error,
                          size: 20,
                          color: Colors.orange,
                        )
                      : const Icon(
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
                    // style: HelperStyle.textStyle(
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
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(7),
                topRight: const Radius.circular(7),
                bottomLeft: Radius.circular(check ? 7 : 0),
                bottomRight: Radius.circular(check ? 0 : 7),
              ),
              color: check ? Colors.red : Colors.blue,
            ),
            child: Text(
              message.textContent?.text ?? '',
              // style: HelperStyle.textStyle(
              //   PsColors.whiteColor,
              //   14.sp,
              //   FontWeight.w500,
              // ),
            ),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        check
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formattedTimestamp,
                    // style: HelperStyle.textStyle(
                    //   PsColors.authHeaderColor,
                    //   10.sp,
                    //   FontWeight.w400,
                    // ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  message.info.sentStatus.name == 'failed'
                      ? const Icon(
                          Icons.error,
                          size: 20,
                          color: Colors.red,
                        )
                      : const Icon(
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
                    // style: HelperStyle.textStyle(
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
