// ignore_for_file: non_constant_identifier_names, unnecessary_cast, use_key_in_widget_constructors, library_private_types_in_public_api, use_rethrow_when_possible, avoid_print, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/head/chat_screen.dart';
import 'package:hr_management_system/owner/edit_user_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hr_management_system/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class CustomUser {
  final String userId;
  final String name;
  final String phoneNumber;

  CustomUser({
    required this.userId,
    required this.name,
    required this.phoneNumber,
  });
}

class OwnerHomeScreen extends StatefulWidget {
  @override
  _OwnerHomeScreenState createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  List<CustomUser> employees = [];
  List<CustomUser> heads = [];
  CustomUser? owner;

  ZegoUIKitPrebuiltCallController? callController;
  List<CustomUser> Dc = [];
  late Future<void> userDataFuture;
  String userid = '';
  String username = '';
  @override
  void initState() {
    super.initState();
    userDataFuture = loadUserData();
  }

  String uid = '';
  Future<void> loadUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userid = sharedPreferences.getString('aduserid')!;

    username = sharedPreferences.getString('adusername')!;
    try {
      uid = getCurrentUserUid();
      QuerySnapshot<Map<String, dynamic>> employeesSnapshot =
          await FirebaseFirestore.instance.collection('employees').get();
      List<CustomUser> loadedEmployees = employeesSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CustomUser(
          userId: doc.id,
          name: data['name'] ?? '',
          phoneNumber: data['phonenumber'] ?? '',
        );
      }).toList();
      QuerySnapshot<Map<String, dynamic>> dcSnapshot =
          await FirebaseFirestore.instance.collection('DC').get();
      List<CustomUser> loadedDC = dcSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CustomUser(
          userId: doc.id,
          name: data['name'] ?? '',
          phoneNumber: data['phonenumber'] ?? '',
        );
      }).toList();
      QuerySnapshot<Map<String, dynamic>> headsSnapshot =
          await FirebaseFirestore.instance.collection('head').get();
      List<CustomUser> loadedHeads = headsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CustomUser(
          userId: doc.id,
          name: data['name'] ?? '',
          phoneNumber: data['phonenumber'] ?? '',
        );
      }).toList();
      DocumentSnapshot<Map<String, dynamic>> ownerSnapshot =
          await FirebaseFirestore.instance.collection('owner').doc(uid).get();
      Map<String, dynamic> ownerData = ownerSnapshot.data() ?? {};
      owner = CustomUser(
        userId: uid,
        name: ownerData['name'] ?? '',
        phoneNumber: ownerData['phonenumber'] ?? '',
      );
      setState(() {
        employees = loadedEmployees;
        heads = loadedHeads;
        Dc = loadedDC;
      });
      if (employees.isEmpty && heads.isEmpty && owner == null) {
      } else {}
    } catch (e) {
      throw e;
    }
    if (!kIsWeb) {
      loginCustomerChat();
      loginuserforcall();
    }
  }

  Future<void> _refreshData() async {
    await loadUserData();
  }

  Future loginCustomerChat() async {
    await ZIMKit().connectUser(
      id: uid,
      name: "Admin",
      avatarUrl: "",
    );
  }

  String getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future loginuserforcall() async {
    callController ??= ZegoUIKitPrebuiltCallController();
    // ZegoUIKitPrebuiltCallInvitationService().uninit();

    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 605501723 /*input your AppID*/,
      appSign:
          "10d55f45bce2456b6c5efd3dd3efd0e5b243d4817423f786283eac60d6d9578e" /*input your AppSign*/,
      userID: userid,
      userName: username,
      notifyWhenAppRunningInBackgroundOrQuit: true,
      plugins: [ZegoUIKitSignalingPlugin()],
      controller: callController,
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        // config.avatarBuilder = customAvatarBuilder;

        /// support minimizing, show minimizing button
        config.topMenuBarConfig.isVisible = true;
        config.topMenuBarConfig.buttons
            .insert(0, ZegoMenuBarButtonName.minimizingButton);

        return config;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () async {
                signOut(context);
                ZegoUIKitPrebuiltCallInvitationService().uninit();
                await ZIMKit().disconnectUser();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            // Center(
            //   child: GestureDetector(
            //     onTap: () {
            //       signOut(context);
            //     },
            //     child: Container(
            //       height: 40,
            //       width: 120,
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         shape: BoxShape.rectangle,
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //       child: const Center(
            //         child: Text(
            //           'Sign Out',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 20,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserList('Employees', employees),
                  _buildHeadList('Heads', heads),
                  _buildDcList('DC', Dc),
                  _buildOwner(owner),
                  Container(
                    height: 30,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xffFFB996)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadList(String title, List<CustomUser> userList) {
    return Expanded(
      child: userList.isEmpty
          ? Center(
              child: Text('No $title found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xff80BCBD)),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userList[index];
                      return Column(
                        children: [
                          const Divider(),
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditUserScreen(
                                            userId: user.userId, name: 'head'),
                                      ),
                                    );
                                  },
                                  backgroundColor: const Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _removeUser(user);
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 207, 3, 3),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Video and Voice Group call'),
                                      content: Row(children: [
                                        ZegoSendCallInvitationButton(
                                          iconSize: const Size(20, 30),
                                          // buttonSize: const Size(20, 20),
                                          icon: ButtonIcon(
                                            icon: const Icon(
                                              Icons.call,
                                            ),
                                          ),
                                          callID: 'VC12345',
                                          isVideoCall: false,
                                          resourceID: 'zegouikit_call',
                                          invitees: [
                                            ZegoUIKitUser(
                                              id: userList[index].userId,
                                              name: userList[index].name,
                                            ),
                                          ],
                                        ),
                                        ZegoSendCallInvitationButton(
                                          iconSize: const Size(20, 30),
                                          // buttonSize: const Size(20, 20),
                                          icon: ButtonIcon(
                                            icon: const Icon(
                                              Icons.video_call,
                                            ),
                                          ),
                                          callID: 'VD12345',
                                          isVideoCall: true,
                                          resourceID: 'zegouikit_call',
                                          invitees: [
                                            ZegoUIKitUser(
                                              id: userList[index].userId,
                                              name: userList[index].name,
                                            ),
                                          ],
                                        ),
                                      ]),
                                      actions: [
                                        TextButton(
                                            onPressed: () {},
                                            child: const Text('Cancel'))
                                      ],
                                    );
                                  },
                                );
                              },
                              title: Text(user.name),
                              subtitle: Text(user.phoneNumber),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          //Fill in a String type value.
                                          loginCustomerChat().then((value) {
                                            //This will be triggered when login successful.

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return CustomerChatScreen(
                                                    id: userList[index].userId,
                                                    logo:
                                                        'assets/images/hrbg.png',
                                                    name: userList[index].name,
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                          debugPrint(
                                            '=======12',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.message_rounded,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ZegoSendCallInvitationButton(
                                        iconSize: const Size(20, 30),
                                        // buttonSize: const Size(20, 20),
                                        icon: ButtonIcon(
                                          icon: const Icon(
                                            Icons.call,
                                          ),
                                        ),
                                        isVideoCall: false,
                                        resourceID: 'zegouikit_call',
                                        invitees: [
                                          ZegoUIKitUser(
                                            id: userList[index].userId,
                                            name: userList[index].name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       loginuserforcall().then((value) {
                                    //         //This will be triggered when login successful.
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) {
                                    //               return CallPage(
                                    //                 callID: 'khsd',
                                    //                 userId: id,
                                    //                 userName: name,
                                    //               );
                                    //             },
                                    //           ),
                                    //         );
                                    //       });
                                    //       debugPrint(
                                    //         '=======12',
                                    //       );
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.call,
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: ZegoSendCallInvitationButton(
                                        // iconSize: const Size(10, 10),
                                        // buttonSize: const Size(10, 10),
                                        iconSize: const Size(20, 30),
                                        icon: ButtonIcon(
                                          icon: const Icon(
                                            Icons.video_call,
                                          ),
                                        ),
                                        isVideoCall: true,
                                        resourceID: 'zegouikit_call',
                                        invitees: [
                                          ZegoUIKitUser(
                                            id: userList[index].userId,
                                            name: userList[index].name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       print('video call');
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.video_call,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDcList(String title, List<CustomUser> userList) {
    return Expanded(
      child: userList.isEmpty
          ? Center(
              child: Text('No $title found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xff86A7FC)),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userList[index];
                      return Column(
                        children: [
                          const Divider(),
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditUserScreen(
                                            userId: user.userId, name: 'Dc'),
                                      ),
                                    );
                                  },
                                  backgroundColor: const Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _removeUser(user);
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 207, 3, 3),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Video and Voice Group call'),
                                      content: Row(children: [
                                        ZegoSendCallInvitationButton(
                                          iconSize: const Size(20, 30),
                                          // buttonSize: const Size(20, 20),
                                          icon: ButtonIcon(
                                            icon: const Icon(
                                              Icons.call,
                                            ),
                                          ),
                                          callID: 'VC12345',
                                          isVideoCall: false,
                                          resourceID: 'zegouikit_call',
                                          invitees: [
                                            ZegoUIKitUser(
                                              id: userList[index].userId,
                                              name: userList[index].name,
                                            ),
                                          ],
                                        ),
                                        ZegoSendCallInvitationButton(
                                          iconSize: const Size(20, 30),
                                          // buttonSize: const Size(20, 20),
                                          icon: ButtonIcon(
                                            icon: const Icon(
                                              Icons.video_call,
                                            ),
                                          ),
                                          callID: 'VD12345',
                                          isVideoCall: true,
                                          resourceID: 'zegouikit_call',
                                          invitees: [
                                            ZegoUIKitUser(
                                              id: userList[index].userId,
                                              name: userList[index].name,
                                            ),
                                          ],
                                        ),
                                      ]),
                                      actions: [
                                        TextButton(
                                            onPressed: () {},
                                            child: const Text('Cancel'))
                                      ],
                                    );
                                  },
                                );
                              },
                              title: Text(user.name),
                              subtitle: Text(user.phoneNumber),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          //Fill in a String type value.
                                          loginCustomerChat().then((value) {
                                            //This will be triggered when login successful.

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return CustomerChatScreen(
                                                    id: userList[index].userId,
                                                    logo:
                                                        'assets/images/hrbg.png',
                                                    name: userList[index].name,
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                          debugPrint(
                                            '=======12',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.message_rounded,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ZegoSendCallInvitationButton(
                                        iconSize: const Size(20, 30),
                                        // buttonSize: const Size(20, 20),
                                        icon: ButtonIcon(
                                          icon: const Icon(
                                            Icons.call,
                                          ),
                                        ),
                                        isVideoCall: false,
                                        resourceID: 'zegouikit_call',
                                        invitees: [
                                          ZegoUIKitUser(
                                            id: userList[index].userId,
                                            name: userList[index].name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       loginuserforcall().then((value) {
                                    //         //This will be triggered when login successful.
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) {
                                    //               return CallPage(
                                    //                 callID: 'khsd',
                                    //                 userId: id,
                                    //                 userName: name,
                                    //               );
                                    //             },
                                    //           ),
                                    //         );
                                    //       });
                                    //       debugPrint(
                                    //         '=======12',
                                    //       );
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.call,
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: ZegoSendCallInvitationButton(
                                        // iconSize: const Size(10, 10),
                                        // buttonSize: const Size(10, 10),
                                        iconSize: const Size(20, 30),
                                        icon: ButtonIcon(
                                          icon: const Icon(
                                            Icons.video_call,
                                          ),
                                        ),
                                        isVideoCall: true,
                                        resourceID: 'zegouikit_call',
                                        invitees: [
                                          ZegoUIKitUser(
                                            id: userList[index].userId,
                                            name: userList[index].name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       print('video call');
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.video_call,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildUserList(String title, List<CustomUser> userList) {
    return Expanded(
      child: userList.isEmpty
          ? Center(
              child: Text('No $title found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xffFFB996)),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = userList[index];
                      return Column(
                        children: [
                          const Divider(),
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditUserScreen(
                                            userId: user.userId, name: 'Emp'),
                                      ),
                                    );
                                  },
                                  backgroundColor: const Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    _removeUser(user);
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 207, 3, 3),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.phoneNumber),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          //Fill in a String type value.
                                          loginCustomerChat().then((value) {
                                            //This will be triggered when login successful.

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return CustomerChatScreen(
                                                    id: userList[index].userId,
                                                    logo:
                                                        'assets/images/hrbg.png',
                                                    name: userList[index].name,
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                          debugPrint(
                                            '=======12',
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.message_rounded,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ZegoSendCallInvitationButton(
                                        iconSize: const Size(20, 30),
                                        // buttonSize: const Size(20, 20),
                                        icon: ButtonIcon(
                                          icon: const Icon(
                                            Icons.call,
                                          ),
                                        ),
                                        isVideoCall: false,
                                        resourceID: 'zegouikit_call',
                                        invitees: [
                                          ZegoUIKitUser(
                                            id: userList[index].userId,
                                            name: userList[index].name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       loginuserforcall().then((value) {
                                    //         //This will be triggered when login successful.
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) {
                                    //               return CallPage(
                                    //                 callID: 'khsd',
                                    //                 userId: id,
                                    //                 userName: name,
                                    //               );
                                    //             },
                                    //           ),
                                    //         );
                                    //       });
                                    //       debugPrint(
                                    //         '=======12',
                                    //       );
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.call,
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      child: ZegoSendCallInvitationButton(
                                        // iconSize: const Size(10, 10),
                                        // buttonSize: const Size(10, 10),
                                        iconSize: const Size(20, 30),
                                        icon: ButtonIcon(
                                          icon: const Icon(
                                            Icons.video_call,
                                          ),
                                        ),
                                        isVideoCall: true,
                                        resourceID: 'zegouikit_call',
                                        invitees: [
                                          ZegoUIKitUser(
                                            id: userList[index].userId,
                                            name: userList[index].name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: IconButton(
                                    //     onPressed: () {
                                    //       print('video call');
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.video_call,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _removeUser(CustomUser user) async {
    try {
      String collection;
      if (employees.any((e) => e.userId == user.userId)) {
        collection = 'employees';
      } else if (heads.any((h) => h.userId == user.userId)) {
        collection = 'head';
      } else if (Dc.any((d) => d.userId == user.userId)) {
        collection = 'DC';
      } else {
        return;
      }
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.userId)
          .delete();
      await _refreshData();
    } catch (e) {
      print('Error removing user: $e');
    }
  }

  Widget _buildOwner(CustomUser? owner) {
    return Expanded(
      child: owner == null
          ? const Center(
              child: Text('No owner found.'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 250, 182, 250)),
                  child: const Text(
                    'Owner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(owner.name),
                  subtitle: Text(owner.phoneNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditUserScreen(
                              userId: owner.userId, name: 'Owner'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
