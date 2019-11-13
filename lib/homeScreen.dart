import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String email, radius, name, credit;

  const HomeScreen({Key key, this.email, this.radius, this.name, this.credit})
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  String $pagetitle = "My Food Never Waste";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
      onTap: tap,
      currentIndex: currentTabIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.blue),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.green),
          title: Text("Search"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message, color: Colors.red),
          title: Text("Messages"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.yellow),
          title: Text("Profile"),
        ),
      ],
    ));
  }

  void tap(int index) {
    setState(() {});
  }
}
