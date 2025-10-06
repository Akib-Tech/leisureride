import 'package:flutter/material.dart';
import 'package:leisureride/userspage/home.dart';
import 'package:leisureride/userspage/profile.dart';
import 'package:leisureride/userspage/riderequest.dart';

class ButtomNav extends StatefulWidget {
  const ButtomNav({super.key});

  @override
  State<ButtomNav> createState() => _ButtomNavState();
}

class _ButtomNavState extends State<ButtomNav> {
  int _selectedIndex = 0;

  // Pages
  final List<Widget> _pages = [
    const HomePage(),
    const RideRequestPage(), // Booking Page
    const ProfilePage(),
    const Center(child: Text("Wallet Page", style: TextStyle(fontSize: 20))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(context, MaterialPageRoute(builder: (c) => _pages[index] ));
  }

  final Color gold = const Color(0xFFFFD700);
  final Color black = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi), label: "Booking"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        ],

    );
  }
}
