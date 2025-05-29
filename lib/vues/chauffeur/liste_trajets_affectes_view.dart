import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class ListeTrajetsAffectesView extends StatelessWidget {
  const ListeTrajetsAffectesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;
    final user = authService.currentUser;

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
        title: const Text('Mes trajets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${user?.firstname ?? ''} ${user?.lastname ?? ''}'),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.firstname?.substring(0, 1).toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Mes trajets'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chauffeur/liste_trajets_affectes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: const Text('Gestion des réservations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chauffeur/gestion_reservations_recues');
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Validation des check-ins'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chauffeur/validation_checkin');
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            'Mes trajets',
            Icons.route,
            '/chauffeur/liste_trajets_affectes',
          ),
          _buildDashboardCard(
            context,
            'Gestion des réservations',
            Icons.confirmation_number,
            '/chauffeur/gestion_reservations_recues',
          ),
          _buildDashboardCard(
            context,
            'Validation des check-ins',
            Icons.check_circle,
            '/chauffeur/validation_checkin',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}