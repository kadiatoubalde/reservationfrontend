import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class GestionReservationsRecuesView extends StatefulWidget {
  const GestionReservationsRecuesView({Key? key}) : super(key: key);

  @override
  State<GestionReservationsRecuesView> createState() => _GestionReservationsRecuesViewState();
}

class _GestionReservationsRecuesViewState extends State<GestionReservationsRecuesView> {
  // Données fictives pour la démonstration
  final List<Map<String, dynamic>> _reservations = [
    {
      'id': 1,
      'passager': 'Jean Dupont',
      'trajet': 'Fria → Conakry',
      'date': '2024-03-20',
      'heure': '10:00',
      'statut': 'En attente',
      'places': 2,
    },
    {
      'id': 2,
      'passager': 'Marie Martin',
      'trajet': 'Mamou → Labé',
      'date': '2024-03-21',
      'heure': '14:30',
      'statut': 'Confirmée',
      'places': 1,
    },
  ];

  void _changerStatutReservation(int reservationId, String nouveauStatut) {
    setState(() {
      final reservation = _reservations.firstWhere((r) => r['id'] == reservationId);
      reservation['statut'] = nouveauStatut;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Réservation ${nouveauStatut.toLowerCase()}'),
        backgroundColor: nouveauStatut == 'Confirmée' ? Colors.green : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;

    if (!authService.isAuthenticated || userRole != 'CHAUFFEUR') {
      Navigator.pushReplacementNamed(context, '/login');
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Réservations'),
      ),
      body: ListView.builder(
        itemCount: _reservations.length,
        itemBuilder: (context, index) {
          final reservation = _reservations[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Réservation #${reservation['id']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: reservation['statut'] == 'Confirmée'
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          reservation['statut'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Passager: ${reservation['passager']}'),
                  const SizedBox(height: 8),
                  Text('Trajet: ${reservation['trajet']}'),
                  const SizedBox(height: 8),
                  Text('Date: ${reservation['date']} à ${reservation['heure']}'),
                  const SizedBox(height: 8),
                  Text('Places: ${reservation['places']}'),
                  const SizedBox(height: 16),
                  if (reservation['statut'] == 'En attente')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _changerStatutReservation(
                              reservation['id'], 'Refusée'),
                          child: const Text('Refuser'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _changerStatutReservation(
                              reservation['id'], 'Confirmée'),
                          child: const Text('Confirmer'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 