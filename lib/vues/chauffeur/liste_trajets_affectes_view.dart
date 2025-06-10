import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class ListeTrajetsAffectesView extends StatefulWidget {
  const ListeTrajetsAffectesView({Key? key}) : super(key: key);

  @override
  State<ListeTrajetsAffectesView> createState() => _ListeTrajetsAffectesViewState();
}

class _ListeTrajetsAffectesViewState extends State<ListeTrajetsAffectesView> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;
    final user = authService.currentUser;

    if (!authService.isAuthenticated || userRole != 'CHAUFFEUR') {
      Navigator.pushReplacementNamed(context, '/login');
      return const SizedBox.shrink();
    }

    // Données fictives pour la démonstration
    final List<Map<String, dynamic>> trajets = [
      {
        'id': 1,
        'depart': 'Fria',
        'arrivee': 'Conakry',
        'date': '2024-03-20',
        'heure': '10:00',
        'statut': 'En attente',
        'passagers': 3,
      },
      {
        'id': 2,
        'depart': 'Mamou',
        'arrivee': 'Labé',
        'date': '2024-03-21',
        'heure': '14:30',
        'statut': 'En cours',
        'passagers': 5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Trajets'),
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
                'Menu Chauffeur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Mes Trajets Affectés'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Stay on the current page
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon Profil'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/profil');
              },
            ),
            // Add more items as needed for the chauffeur role
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () async {
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
      body: ListView.builder(
        itemCount: trajets.length,
        itemBuilder: (context, index) {
          final trajet = trajets[index];
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
                  Text('Passagers: ${trajet['passagers']}'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trajet['statut'] == 'En cours' ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trajet['statut'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  // TODO: Naviguer vers les détails du trajet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fonctionnalité à implémenter')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}