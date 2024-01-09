import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_management_system/head/call_page.dart';
import 'package:hr_management_system/head/chat_screen.dart';
import 'package:hr_management_system/head/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String userid = '';
  String username = '';
  ZegoUIKitPrebuiltCallController? callController;
  @override
  void initState() {
    super.initState();
    getuserDetail();
  }

  getuserDetail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userid = sharedPreferences.getString('userid')!;

    username = sharedPreferences.getString('username')!;
    await loginuserforcall();
    await loginCustomerChat();
  }

  Future loginCustomerChat() async {
    await ZIMKit().disconnectUser();
    await ZIMKit().connectUser(
      id: userid,
      name: "Head",
      avatarUrl: "",
    );
// ZIMKit().init(appID: appID)
    // totalUnreadMessages = ZIMKit().getTotalUnreadMessageCount().value;
    // if (kDebugMode) {
    //   print(totalUnreadMessages);
    // }
  }

  Future loginuserforcall() async {
    callController ??= ZegoUIKitPrebuiltCallController();
    ZegoUIKitPrebuiltCallInvitationService().uninit();

    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2002727599 /*input your AppID*/,
      appSign:
          "5bc06ed01eefd54688d73293b7ad35c05db2a750b3bfd974394f2c63695ef4fd" /*input your AppSign*/,
      userID: userid,
      userName: username,
      notifyWhenAppRunningInBackgroundOrQuit: false,
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
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: const Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final id = user['uid'];
              final name = user['name'];
              final email = user['email'];
              final phonenumber = user['phonenumber'];

              return ListTile(
                leading: const Image(
                  image: AssetImage(
                    'assets/images/hrbg.png',
                  ),
                ),
                title: Text(name),
                subtitle: Text(email),
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
                                      id: id,
                                      logo: 'assets/images/hrbg.png',
                                      name: name,
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
                              id: id,
                              name: name,
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
                              id: id,
                              name: name,
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(user: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatefulWidget {
  final DocumentSnapshot user;

  const UserDetailScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user['name'];
    _emailController.text = widget.user['email'];
    _durationController.text = widget.user['duration'] ?? '';
    _salaryController.text = widget.user['salary'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _durationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final updatedName = _nameController.text;
    final updatedEmail = _emailController.text;
    final updatedDuration = _durationController.text;
    final updatedSalary = _salaryController.text;

    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.user.id)
          .update({
        'name': updatedName,
        'email': updatedEmail,
        'duration': updatedDuration,
        'salary': updatedSalary,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving changes: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 3,
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HeadHomeScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: const Text('User Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration:
                  const InputDecoration(labelText: 'Duration of Employee'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _saveChanges,
                child: const Center(child: Text('Save Changes')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
