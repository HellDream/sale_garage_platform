import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/user_info_tile.dart';
import 'package:sale_garage_platform/constants/constant.dart';
import 'package:sale_garage_platform/screens/login_screen.dart';
import 'package:sale_garage_platform/screens/user_posts_screen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic> _profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profile = authService.profileData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            _buildAvatar(),
            UserInfoTile(
              info: _profile['displayName'],
              icon: Icons.perm_identity,
            ),
            UserInfoTile(
              info: _profile['email'],
              icon: Icons.email,
            ),
            _buildMyPostBtn(context),
            SizedBox(height: 20,),
            _signOutBtn(context),
          ],
        ));
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(_profile['photoURL'],),
      radius: 40,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildMyPostBtn(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, UserPostScreen.id);
        },
        child: ListTile(
          leading: Icon(Icons.list),
          title: Text(
            'My Garage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

  Widget _signOutBtn(BuildContext context) {
    return InkWell(
      onTap: (){
        authService.signOut();
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      },
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: <Color>[
              Colors.blue,
              Colors.blueAccent,
              Colors.blue.shade300
            ],
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: const Text(
            'Sign Out',
            style: TextStyle(fontSize: 20)
        ),
      ),
    );
  }
}
