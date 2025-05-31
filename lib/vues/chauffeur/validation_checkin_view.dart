import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class ValidationCheckinView extends StatefulWidget {
  const ValidationCheckinView({Key? key}) : super(key: key);

  @override
  State<ValidationCheckinView> createState() => _ValidationCheckinViewState();
}

class _ValidationCheckinViewState extends State<ValidationCheckinView> {
  // Données fictives pour la démonstration
  final List<Map<String, dynamic>> _checkins = [
    {
      'id': 1,
      'passager': 'Jean Dupont',
      'trajet': 'Fria → Conakry',
      'date': '2024-03-20',
      'heure': '10:00',
      'statut': 'En attente',
      'code': 'ABC123',
    },
    {
      'id': 2,
      'passager': 'Marie Martin',
      'trajet': 'Mamou → Labé',
      'date': '2024-03-21',
      'heure': '14:30',
      'statut': 'Validé',
      'code': 'DEF456',
    },
  ];

  void _validerCheckin(int checkinId) {
    setState(() {
      final checkin = _checkins.firstWhere((c) => c['id'] == checkinId);
      checkin['statut'] = 'Validé';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Check-in validé avec succès!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;

    if (!authService.isAuthenticated || userRole != 'CHAUFFEUR') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Accès refusé. Vous n\'avez pas le rôle Chauffeur.'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation des Check-ins'),
      ),
      body: ListView.builder(
        itemCount: _checkins.length,
        itemBuilder: (context, index) {
          final checkin = _checkins[index];
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
                        'Check-in #${checkin['id']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: checkin['statut'] == 'Validé'
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          checkin['statut'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Passager: ${checkin['passager']}'),
                  const SizedBox(height: 8),
                  Text('Trajet: ${checkin['trajet']}'),
                  const SizedBox(height: 8),
                  Text('Date: ${checkin['date']} à ${checkin['heure']}'),
                  const SizedBox(height: 8),
                  Text('Code: ${checkin['code']}'),
                  const SizedBox(height: 16),
                  if (checkin['statut'] == 'En attente')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => _validerCheckin(checkin['id']),
                          child: const Text('Valider le check-in'),
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