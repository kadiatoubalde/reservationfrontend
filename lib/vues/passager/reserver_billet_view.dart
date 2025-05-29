import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class ReserverBilletView extends StatelessWidget {
  const ReserverBilletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;

    if (!authService.isAuthenticated || userRole != 'PASSAGER') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Accès refusé. Vous n\'avez pas le rôle Passager.'),
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
        title: const Text('Réserver un billet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Détails du trajet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Départ: Ville A'),
                const SizedBox(height: 8),
                Text('Arrivée: Ville B'),
                const SizedBox(height: 8),
                Text('Date: 2024-12-31'),
                const SizedBox(height: 8),
                Text('Heure: 10:00'),
                const SizedBox(height: 8),
                Text('Prix: 50.0 €'),
                const SizedBox(height: 24),
                const Text(
                  'Nombre de billets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                 const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                     contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                  ),
                  value: 1,
                  items: List.generate(5, (index) => index + 1)
                      .map((number) => DropdownMenuItem<int>(
                            value: number,
                            child: Text(number.toString()),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    // TODO: Update number of tickets
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Réservation simulée réussie!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Réserver'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 