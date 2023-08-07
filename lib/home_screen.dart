 
import 'dart:convert';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taximetro/prices_screen.dart';
import 'package:taximetro/register_screen.dart';
import 'package:taximetro/services/background_service.dart'; 
import 'package:taximetro/taximeter_screen.dart';
import 'package:taximetro/permission_manager.dart';
import 'taximeterstate.dart';
import 'package:taximetro/services/taximeter.services.dart';

  int _selectedTab = 0;
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();
 
 
 

  @override
void initState() {
    super.initState(); 
   // getCurrentLocation();
    fetchDataPricesFromService();

  } 
  
  void fetchDataPricesFromService() async {
    final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: false);
    final preferences = await SharedPreferences.getInstance();
    final adminCode = preferences.getString('adminCode');
 
    try {
      if (adminCode != null) {
        final response = await TaximeterService.getDataPrices();

        if (response != null) {
          final data = jsonDecode(response);
          taxiMeterState.setDataPrices(data);
        } else {
          taxiMeterState.setDataPricesFromPreferences();
        }
      }

      checkPreferencesAndRedirect();
    } catch (e) {
      // Error de conexión o cualquier otro error
      print('Error: $e');
      taxiMeterState.setDataPricesFromPreferences();
    }
  }

  void checkPreferencesAndRedirect() async {
    final preferences = await SharedPreferences.getInstance();
    final name = preferences.getString('name');

    if (name == null)
       // _selectedTab = 2;
     Navigator.pushNamed(context, '/register');
    else
      _selectedTab = 1;
      //Navigator.pushNamed(context, '/taximeter');
  }



  @override
  Widget build(BuildContext context) {
        final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: false);
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab:  PricesScreen(),
          icon: Icons.home,
          title: 'Tarifa',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const TaxiMeterScreen(),
          icon: Icons.punch_clock,
          title: 'Taximetro',
          navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab:   RegistrationForm(),
          icon: Icons.person,
          title: 'Perfil',
          navigatorkey: _tab3navigatorKey,
        ),
      ],
    );
  }
}
 
class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<PersistentTabItem> items;

  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);

  @override
  State<PersistentBottomBarScaffold> createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /// Check if curent tab can be popped
        if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
            false) {
          widget.items[_selectedTab].navigatorkey?.currentState?.pop();
          return false;
        } else {
          // if current tab can't be popped then use the root navigator
          return true;
        }
      },
      child: Scaffold(
        /// Using indexedStack to maintain the order of the tabs and the state of the
        /// previously opened tab
        body: IndexedStack(
          index: _selectedTab,
          children: widget.items
              .map((page) => Navigator(
                    /// Each tab is wrapped in a Navigator so that naigation in
                    /// one tab can be independent of the other tabs
                    key: page.navigatorkey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.tab)
                      ];
                    },
                  ))
              .toList(),
        ),

        /// Define the persistent bottom bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: widget.items
              .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon), label: item.title))
              .toList(),
        ),
      ),
    );
  }
}

/// Model class that holds the tab info for the [PersistentBottomBarScaffold]
class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final IconData icon;

  PersistentTabItem(
      {required this.tab,
      this.navigatorkey,
      required this.title,
      required this.icon});
}
