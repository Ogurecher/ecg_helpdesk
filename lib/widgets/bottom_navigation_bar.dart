import 'package:ecg_helpdesk/screens/navigation_screen.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> bottomNavigationBarItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.list),
    label: 'All channels'
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'My channels'
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.contact_page),
    label: 'My tickets'
  )
];

BottomNavigationBar bottomNavigationBar(int currentIndex, BuildContext context) {
  
  _onItemTapped(int index) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavigationScreen(index)), (route) => false);
  }

  return BottomNavigationBar(
    items: bottomNavigationBarItems,
    currentIndex: currentIndex,
    onTap: _onItemTapped,
  );
}
