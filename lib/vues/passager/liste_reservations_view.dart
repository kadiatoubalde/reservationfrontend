import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class ListeReservationsView extends StatelessWidget {
  const ListeReservationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole; // Get user role from AuthService

    // Check if user is authenticated and has the PASSAGER role
    if (!authService.isAuthenticated || userRole != 'PASSAGER') {
      // If not authenticated or not PASSAGER, show access denied message and redirect
      WidgetsBinding.instance.addPostFrameCallback((_) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Accès refusé. Vous n\'avez pas le rôle Passager.'), // Specific message for Passager
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        // Redirect to login as this view is specifically for PASSAGER.
        Navigator.pushReplacementNamed(context, '/login'); 
      });
      // Return an empty widget while the redirection happens
      return const SizedBox.shrink();
    }

    // If authenticated and is PASSAGER, show the actual view content
    // Dummy list of reservations
    final List<String> _reservations = [
      'Réservation 1: Trajet A vers B, 2 billets',
      'Réservation 2: Trajet C vers D, 1 billet',
      'Réservation 3: Trajet E vers F, 3 billets',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des réservations'),
      ),
      body: _reservations.isEmpty
          ? const Center(child: Text('Aucune réservation trouvée.'))
          : ListView.builder(
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_reservations[index]),
                  // TODO: Add more reservation details and onTap for reservation details view if needed
                );
              },
            ),
    );
  }
}