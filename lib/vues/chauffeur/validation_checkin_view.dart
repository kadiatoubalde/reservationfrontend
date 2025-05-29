import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class ValidationCheckinView extends StatelessWidget {
  const ValidationCheckinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole; // Get user role from AuthService

    // Check if user is authenticated and has the CHAUFFEUR role
    if (!authService.isAuthenticated || userRole != 'CHAUFFEUR') {
      // If not authenticated or not CHAUFFEUR, show access denied message and redirect
      WidgetsBinding.instance.addPostFrameCallback((_) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Accès refusé. Vous n\'avez pas le rôle Chauffeur.'), // Specific message for Chauffeur
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        // Redirect to login as this view is specifically for CHAUFFEUR.
        Navigator.pushReplacementNamed(context, '/login'); 
      });
      // Return an empty widget while the redirection happens
      return const SizedBox.shrink();
    }

    // If authenticated and is CHAUFFEUR, show the actual view content
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation ou check-in'),
      ),
      body: const Center(
        child: Text('Écran de validation ou check-in pour Chauffeur'),
      ),
    );
  }
} 