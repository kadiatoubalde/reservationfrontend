import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class RechercheTrajetsView extends StatefulWidget {
  const RechercheTrajetsView({Key? key}) : super(key: key);

  @override
  State<RechercheTrajetsView> createState() => _RechercheTrajetsViewState();
}

class _RechercheTrajetsViewState extends State<RechercheTrajetsView> {
  final _villeDepartController = TextEditingController();
  final _villeArriveeController = TextEditingController();
  DateTime _dateDepart = DateTime.now();
  TimeOfDay _heureDepart = TimeOfDay.now();

  // Données fictives pour la démonstration
  final List<Map<String, dynamic>> _trajets = [
    {
      'id': 1,
      'depart': 'Fria',
      'arrivee': 'Conakry',
      'date': '2024-03-20',
      'heure': '10:00',
      'prix': 50.0,
      'places': 5,
    },
    {
      'id': 2,
      'depart': 'Mamou',
      'arrivee': 'Labé',
      'date': '2024-03-21',
      'heure': '14:30',
      'prix': 30.0,
      'places': 3,
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateDepart,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dateDepart) {
      setState(() {
        _dateDepart = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _heureDepart,
    );
    if (picked != null && picked != _heureDepart) {
      setState(() {
        _heureDepart = picked;
      });
    }
  }

  @override
  void dispose() {
    _villeDepartController.dispose();
    _villeArriveeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;
    final user = authService.currentUser;

    if (!authService.isAuthenticated || userRole != 'PASSAGER') {
      Navigator.pushReplacementNamed(context, '/login');
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de Trajets'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Passager',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon Profil'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Mes Réservations'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/passager/liste_reservations');
              },
            ),
            // Add more items as needed for the passenger role
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () async {
                // TODO: Implement logout logic
                 final authService = Provider.of<AuthService>(context, listen: false);
                 await authService.logout();
                 if (mounted) {
                   Navigator.pushReplacementNamed(context, '/login');
                 }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _villeDepartController,
                  decoration: const InputDecoration(
                    labelText: 'Ville de départ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _villeArriveeController,
                  decoration: const InputDecoration(
                    labelText: 'Ville d\'arrivée',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date de départ'),
                  subtitle: Text(
                    '${_dateDepart.day}/${_dateDepart.month}/${_dateDepart.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Heure de départ'),
                  subtitle: Text(_heureDepart.format(context)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implémenter la recherche de trajets
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recherche en cours...'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Rechercher'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _trajets.length,
              itemBuilder: (context, index) {
                final trajet = _trajets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      '${trajet['depart']} → ${trajet['arrivee']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Date: ${trajet['date']} à ${trajet['heure']}'),
                        const SizedBox(height: 4),
                        Text('Prix: ${trajet['prix']} €'),
                        const SizedBox(height: 4),
                        Text('Places disponibles: ${trajet['places']}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO: Naviguer vers la page de réservation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Redirection vers la réservation...'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                      child: const Text('Réserver'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 