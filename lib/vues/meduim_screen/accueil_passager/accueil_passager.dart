import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';
import '../liste_voyages/liste_voyages_disponibles.dart';
import '../reservations/reservations.dart';
import '../profile_passager/profile_passager.dart';

class AccueilPassager extends StatefulWidget {
  const AccueilPassager({super.key});

  static String path = "/accueilPassager";

  @override
  State<AccueilPassager> createState() => _AccueilPassagerState();
}

class _AccueilPassagerState extends State<AccueilPassager> {
  final List<String> villes = ['Conakry', 'Kindia', 'Mamou', 'Labé', 'Kankan'];
  String? villeDepart;
  String? villeArrivee;
  int _selectedIndex = 0;

  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('d MMM yyyy', 'fr_FR');

  void _onItemTapped(int index) {
      setState(() {
      _selectedIndex = index;
      });
    
    // Navigation vers les différentes pages
    if (index == 1) {
      Navigator.pushNamed(context, ReservationsPage.path);
    } else if (index == 2) {
      Navigator.pushNamed(context, ProfilePassager.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo déplacé ici
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              child: Image.asset(
                'assets/images/easytravel_logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),

            // Ville de départ (Dropdown)
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Ville de départ',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: villeDepart,
              hint: const Text("Sélectionnez une ville"),
              items: villes.map((String ville) {
                return DropdownMenuItem<String>(
                  value: ville,
                  child: Text(ville),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  villeDepart = val!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Ville d'arrivée (Dropdown)
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Ville d'arrivée",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: villeArrivee,
              hint: const Text("Sélectionnez une ville"),
              items: villes.map((String ville) {
                return DropdownMenuItem<String>(
                  value: ville,
                  child: Text(ville),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  villeArrivee = val!;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Date + calendrier
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(selectedDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month, size: 26),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Bouton rechercher
            ElevatedButton(
            onPressed: () {
  if (villeDepart != null && villeArrivee != null) {
    Navigator.pushNamed(context, ListeVoyagesDisponibles.path);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veuillez sélectionner les deux villes")),
    );
  }
},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213FAA),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text(
                'Rechercher un voyage',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF213FAA),
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}