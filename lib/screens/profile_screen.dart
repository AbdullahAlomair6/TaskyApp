import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/screens/user_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userName;
  late String motivationQuote;
  bool isLoading = true;
  bool isDark = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    setState(() {
      isLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('username') ?? '';
      motivationQuote =
          pref.getString('motivation_quote') ??
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
                  style: TextStyle(
                    color: Color(0XFFFFFCFC),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
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
                                color: Color(0XFF282828),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Color(0XFFFFFCFC),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        userName,
                        style: TextStyle(
                          color: Color(0XFFFFFCFC),
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'One task at a time. One step closer.',
                        style: TextStyle(
                          color: Color(0XFFC6C6C6),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Profile Info',
                  style: TextStyle(
                    color: Color(0XFFFFFCFC),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
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

                  title: Text(
                    'User Details',
                    style: TextStyle(
                      color: Color(0XFFFFFCFC),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    'assets/images/profile-icon.svg',
                    colorFilter: ColorFilter.mode(
                      Color(0xffFFFCFC),
                      BlendMode.srcIn,
                    ),
                  ),
                  trailing: SvgPicture.asset('assets/images/arrow-icon.svg'),
                ),
                Divider(color: Color(0XFF6E6E6E)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Color(0XFFFFFCFC),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  leading: SvgPicture.asset('assets/images/dark_icon.svg'),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value;
                      });
                    },
                  ),
                ),
                Divider(color: Color(0XFF6E6E6E)),
                ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0XFFFFFCFC),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  leading: SvgPicture.asset('assets/images/logout_icon.svg'),
                  trailing: SvgPicture.asset('assets/images/arrow-icon.svg'),
                ),
              ],
            ),
          );
  }
}
