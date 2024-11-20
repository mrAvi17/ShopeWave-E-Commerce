import 'package:flutter/material.dart';
import 'package:shopewave/pages/home.dart';
import 'package:shopewave/pages/order.dart';
import 'package:shopewave/pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  late List<Widget> pages;

  late Home HomePage;
  late Order order;
  late Profile profile;
  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = Home();
    order = Order();
    profile = Profile();
    pages = [HomePage, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors
            .transparent, // Set to transparent so that app background shows
        color: Colors.black, // Set color for the navigation bar itself
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            size: 30,
            color: Colors.white, // Icons are white
          ),
          Icon(
            Icons.shopping_bag_outlined,
            size: 30,
            color: Colors.white, // Icons are white
          ),
          Icon(
            Icons.person_outlined,
            size: 30,
            color: Colors.white, // Icons are white
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
