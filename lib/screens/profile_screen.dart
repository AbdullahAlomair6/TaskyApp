import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/services/theme_controller.dart';
import 'package:tasky/core/widget/custom_svg_picture.dart';
import 'package:tasky/screens/user_details_screen.dart';
import 'package:tasky/screens/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;
  late String motivationQuote;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      userName = PreferencesManager().getString('username') ?? '';
      motivationQuote =
          PreferencesManager().getString('motivation_quote') ??
          'One task at a time. One step closer.';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Profile',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/profile.png',
                            ),
                            radius: 60,
                            backgroundColor: Colors.transparent,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: BoxBorder.all(
                                  color: ThemeController.isDark()
                                      ? Colors.transparent
                                      : Color(0xFFD1DAD6),
                                ),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              child: Icon(Icons.camera_alt_outlined),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        motivationQuote,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Profile Info',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 16),
                ListTile(
                  onTap: () async {
                    final bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => UserDetailsScreen(
                          userName: userName,
                          motivationQuote: motivationQuote,
                        ),
                      ),
                    );

                    if (result != null && result == true) {
                      print('updated');
                      _loadData();
                    }
                  },
                  contentPadding: EdgeInsets.zero,

                  title: Text('User Details'),
                  leading: CustomSvgPicture(
                    path: 'assets/images/profile-icon.svg',
                  ),
                  trailing: CustomSvgPicture(
                    path: 'assets/images/arrow-icon.svg',
                  ),
                ),
                Divider(color: Color(0XFF6E6E6E)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Dark Mode'),
                  leading: CustomSvgPicture(
                    path: 'assets/images/dark_icon.svg',
                  ),
                  trailing: ValueListenableBuilder(
                    valueListenable: ThemeController.themeNotifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Switch(
                        value: value == ThemeMode.dark,
                        onChanged: (value) async {
                          ThemeController.toggleTheme();
                        },
                      );
                    },
                  ),
                ),
                Divider(color: Color(0XFF6E6E6E)),
                ListTile(
                  onTap: () async {
                    await PreferencesManager().remove('username');
                    await PreferencesManager().remove('tasks');
                    await PreferencesManager().remove('motivation_quote');

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => WelcomeScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text('Log Out'),
                  leading: CustomSvgPicture(
                    path: 'assets/images/logout_icon.svg',
                  ),
                  trailing: CustomSvgPicture(
                    path: 'assets/images/arrow-icon.svg',
                  ),
                ),
              ],
            ),
          );
  }
}
