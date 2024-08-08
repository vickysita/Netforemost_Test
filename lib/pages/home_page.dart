import 'package:flutter/material.dart';
import 'package:interview_flutter/pages/locations/view/add_new_location_page.dart';
import 'package:interview_flutter/pages/weathers/view/weather_page.dart'; // Import the UserPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'NetForemost',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          Center(child: Text('Home Screen')),
          WeatherPage(),
          Center(child: Text('User Screen'))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Weather',
            icon: Icon(Icons.cloud),
          ),
          BottomNavigationBarItem(
            label: 'User',
            icon: Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 25.0, 25.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const AddNewLocationPage();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
