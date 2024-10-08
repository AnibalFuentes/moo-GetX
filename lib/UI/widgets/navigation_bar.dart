// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moo/UI/pages/animals/animal_page.dart';
import 'package:moo/UI/pages/batches/batch_page.dart';
import 'package:moo/UI/pages/home_page.dart';
import 'package:moo/UI/pages/porfile_page.dart';
import 'package:moo/UI/widgets/drawer_widget.dart';
import 'package:moo/global/common/toast.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  static const List body = [
    HomePage(),
    BatchPage(),
    AnimalPage(),
    //ProductionPage(),
    // ProfilePage(),
  ];
  void _logout() async {
    try {
      
      
        await FirebaseAuth.instance.signOut();


       Navigator.pushNamed(context, "/login");
      showToast(message: "Sesión cerrada exitosamente");
    } catch (e) {
      showToast(message: "Error al cerrar sesión: $e");
    }
  }

  void _profile() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _trabajador() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(
        onProfileTap: _profile,
        onSignUp: _logout,
        // onTrabajadorTap: _trabajador,
      ),
      appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          title: const Text(
            "Moo App",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                color: Colors.white)
          ],
          iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: body.elementAt(currentIndex),
      ),
      bottomNavigationBar: NavigationBar(
        
        
        indicatorColor: Colors.grey.shade300,
        destinations: [
          NavigationDestination(
            
              icon: Icon(
                Icons.home_outlined,
                color: Colors.grey.shade600,
                size: 30,
              ),
              selectedIcon: const Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Inicio',
              
              
              ),
          NavigationDestination(
              icon: Icon(
                Icons.agriculture_outlined,
                color: Colors.grey.shade600,
                size: 30,
              ),
              selectedIcon: const Icon(
                Icons.agriculture,
                size: 30,
              ),
              label: 'Finca'),

          NavigationDestination(
              icon: Icon(
                Icons.assignment_outlined, 
                color: Colors.grey.shade600,
                size: 30,
                ),
                selectedIcon: const Icon(
                Icons.assignment,
                size: 30,
              ),
              label: 'Animales'),
          // NavigationDestination(
          //     icon:
          //         Icon(Icons.view_agenda_rounded, color: Colors.grey.shade600),
          //     label: 'Producción'),
          // NavigationDestination(
          //   icon: Icon(Icons.person_2, color: Colors.grey.shade600),
          //   label: 'Perfil',
          // ),
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
