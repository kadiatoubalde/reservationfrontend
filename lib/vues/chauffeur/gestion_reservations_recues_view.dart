import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class GestionReservationsRecuesView extends StatelessWidget {
  const GestionReservationsRecuesView({Key? key}) : super(key: key);

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
        title: const Text('Gestion des réservations reçues'),
      ),
      body: const Center(
        child: Text('Écran de gestion des réservations reçues pour Chauffeur'),
      ),
    );
  }
} 