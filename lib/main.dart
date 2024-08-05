import 'package:flutter/material.dart';
import 'package:rate_list/utils/colors.dart';
import 'package:rate_list/2ndpage/edit.dart';
import 'package:rate_list/2ndpage/second_page.dart';
import 'package:rate_list/homepage/home_page.dart';
import 'package:rate_list/homepage/list.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rate List',
      theme: appTheme,
      home: InputListScreen(),
    );
  }
}

class InputListScreen extends StatefulWidget {
  @override
  createState() => _InputListScreenState();
}

class _InputListScreenState extends State<InputListScreen> {
  List<RateItem> rateList = [];
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratePage(rateList: rateList);
      case 1:
        page = FavoritesPage(rateList: rateList);
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rate List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
        ],
      ),
      drawer: _buildDrawer(),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Rate List',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Rate List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage your rates easily',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', 0),
          _buildDrawerItem(Icons.rate_review, 'Rate List', 1),
          Divider(),
          _buildDrawerItem(Icons.settings, 'Settings', -1),
          _buildDrawerItem(Icons.help, 'Help & Feedback', -1),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (index != -1) {
          setState(() {
            selectedIndex = index;
          });
        }
        Navigator.pop(context);
      },
    );
  }

  Future<void> editRateItem(BuildContext context, int index) async {
    final editedRateItem = await showDialog<RateItem>(
      context: context,
      builder: (context) => EditRateItemDialog(rateItem: rateList[index]),
    );

    if (editedRateItem != null) {
      setState(() {
        rateList[index] = editedRateItem;
      });
    }
  }
}