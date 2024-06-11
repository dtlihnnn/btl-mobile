import 'package:flutter/material.dart';
import 'package:btl_mobile/home_page.dart';
import 'package:btl_mobile/account_page.dart';
class BottomBarLayout extends StatefulWidget {
  const BottomBarLayout({super.key});

  @override
  _BottomBarLayoutState createState() => _BottomBarLayoutState();
}

class _BottomBarLayoutState extends State<BottomBarLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TrangChu(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
