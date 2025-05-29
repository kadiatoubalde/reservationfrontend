import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class AttributionTrajetsChauffeursView extends StatelessWidget {
  const AttributionTrajetsChauffeursView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole; // Get user role from AuthService

    // Check if user is authenticated and has the ADMINISTRATEUR role
    if (!authService.isAuthenticated || userRole != 'ADMINISTRATEUR') {
      // If not authenticated or not ADMINISTRATEUR, show access denied message and redirect
      WidgetsBinding.instance.addPostFrameCallback((_) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Accès refusé. Vous n\'avez pas le rôle Administrateur.'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        // Redirect to login as this view is specifically for ADMINISTRATEUR.
        Navigator.pushReplacementNamed(context, '/login'); 
      });
      // Return an empty widget while the redirection happens
      return const SizedBox.shrink();
    }

    // If authenticated and is ADMINISTRATEUR, show the actual view content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attribution des trajets aux chauffeurs'),
      ),
      body: const Center(
        child: Text('Écran d\'attribution des trajets aux chauffeurs pour Administrateur'),
      ),
    );
  }
} 