import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tobetoapp/models/profile_edit.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/background_sliver.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/body_sliver.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/button_back.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/cover_photo.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/cut_rectangle.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/data_cut_rentagle.dart';
import 'package:tobetoapp/widgets/profile/profile%20homepage/edit_circle_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? selectedDate;
  Province? selectedprovince;
  String _imageUrl = "";
  String _name = "";
  String _surname = "";
  String _phoneNumber = "";
  DateTime? _birthDate;
  String _tc = "";
  String _email = "";
  String _country = "";
  String _city = "";
  String _district = "";
  String _street = "";
  String _aboutMe = "";

  String userName = "Kullanıcı Adı";

  final firebaseAuthInstance = FirebaseAuth.instance;

  final firebaseFireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde bu fonksiyon çağrılır
    _getUserInfo();
  }

  void _getUserInfo() async {
    final user = firebaseAuthInstance.currentUser;
    final document = firebaseFireStore.collection("users").doc(user!.uid);
    final documentSnapshot = await document.get();
    var profileCollectionRef = document.collection('profile').doc("personal");
    var querySnapshot = await profileCollectionRef.get();
    //  final profileDocument =
    // firebaseFireStore.collection("profile").doc("personal");
    //  final documentSnapshotProfile = await profileDocument.get();

    if (mounted) {
      setState(() {
        _name = documentSnapshot.get("_name");
        _surname = documentSnapshot.get("_surname");
        _imageUrl = querySnapshot.get("_imageUrl");
        _phoneNumber = documentSnapshot.get("_phoneNumber");
        _birthDate = documentSnapshot.get(" _birthDate");
        _tc = documentSnapshot.get(" _tc");
        _email = documentSnapshot.get(" _email");
        _country = documentSnapshot.get(" _country");
        _city = documentSnapshot.get(" _city");
        _district = documentSnapshot.get(" _district");
        _street = documentSnapshot.get(" _street");
        _aboutMe = documentSnapshot.get(" _aboutMe");

        print("$_imageUrl");

        if (_name.isNotEmpty) {
          userName = "$_name $_surname";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _AppBarNetflix(
              minExtended: kToolbarHeight,
              maxExtended: size.height * 0.32,
              size: size,
            ),
          ),
          SliverToBoxAdapter(
            child: Body(size: size),
          )
        ],
      ),
    );
  }
}

class _AppBarNetflix extends SliverPersistentHeaderDelegate {
  const _AppBarNetflix({
    required this.maxExtended,
    required this.minExtended,
    required this.size,
  });
  final double maxExtended;
  final double minExtended;
  final Size size;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtended;
    //validate the angle at which the card returns
    const uploadlimit = 13 / 100;
    //return value of the card
    final valueback = (1 - percent - 0.77).clamp(0, uploadlimit);
    final fixrotation = pow(percent, 1.5);

    final card = _CoverCard(
      size: size,
      percent: percent,
      uploadlimit: uploadlimit,
      valueback: valueback,
    );

    final bottomsliverbar = _CustomBottomSliverBar(
      size: size,
      fixrotation: fixrotation,
      percent: percent,
    );

    return Stack(
      children: [
        const BackgroundSliver(),
        if (percent > uploadlimit) ...[
          card,
          bottomsliverbar,
        ] else ...[
          bottomsliverbar,
          card,
        ],
        ButtonBack(
          size: size,
          percent: percent,
          onTap: () => Navigator.pop(context),
        ),
        EditCircleButton(size: size, percent: percent)
      ],
    );
  }

  @override
  double get maxExtent => maxExtended;

  @override
  double get minExtent => minExtended;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _CoverCard extends StatelessWidget {
  const _CoverCard({
    Key? key,
    required this.size,
    required this.percent,
    required this.uploadlimit,
    required this.valueback,
  }) : super(key: key);
  final Size size;
  final double percent;
  final double uploadlimit;
  final num valueback;

  final double angleForCard = 6.5;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.15,
      left: size.width / 24,
      child: Transform(
        alignment: Alignment.topRight,
        transform: Matrix4.identity()
          ..rotateZ(percent > uploadlimit
              ? (valueback * angleForCard)
              : percent * angleForCard),
        child: CoverPhoto(size: size),
      ),
    );
  }
}

class _CustomBottomSliverBar extends StatelessWidget {
  const _CustomBottomSliverBar({
    Key? key,
    required this.size,
    required this.fixrotation,
    required this.percent,
  }) : super(key: key);
  final Size size;
  final num fixrotation;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        left: -size.width * fixrotation.clamp(0, 0.35),
        right: 0,
        child: _CustomBottomSliver(
          size: size,
          percent: percent,
        ));
  }
}

class _CustomBottomSliver extends StatelessWidget {
  const _CustomBottomSliver({
    Key? key,
    required this.size,
    required this.percent,
  }) : super(key: key);

  final Size size;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.12,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: CutRectangle(),
          ),
          DataCutRectangle(
            size: size,
            percent: percent,
          )
        ],
      ),
    );
  }
}
