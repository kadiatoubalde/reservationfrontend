import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class TableauBordView extends StatelessWidget {
  const TableauBordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging: Print the user's role in the build method
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    print('DEBUG: TableauBordView build - User Role: ${user?.role}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Administrateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
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
              leading: const Icon(Icons.people),
              title: const Text('Gestion des utilisateurs'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to user management view
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Créer un trajet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to create trip view
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Affecter un trajet'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to assign trip view
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
            'Gestion des utilisateurs',
            Icons.people,
            '/admin/gestion_utilisateurs',
          ),
          _buildDashboardCard(
            context,
            'Création des trajets',
            Icons.add_circle,
            '/admin/creation_trajets',
          ),
          _buildDashboardCard(
            context,
            'Attribution des trajets',
            Icons.assignment,
            '/admin/attribution_trajets_chauffeurs',
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