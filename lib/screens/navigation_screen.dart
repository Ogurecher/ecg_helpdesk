import 'package:ecg_helpdesk/screens/channel_search.dart';
import 'package:ecg_helpdesk/screens/my_channels.dart';
import 'package:ecg_helpdesk/screens/my_tickets.dart';
import 'package:ecg_helpdesk/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  final int initialIndex;
  const NavigationScreen(this.initialIndex, { Key? key }) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  final List<Widget> _widgetOptions = [
    ChannelSearch(),
    MyChannels(),
    MyTickets()
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
