import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import 'gestion_utilisateurs_view.dart';
import 'creation_trajets_view.dart';
import 'attribution_trajets_chauffeurs_view.dart';
import 'gestion_villes_view.dart';

class TableauBordView extends StatefulWidget {
  const TableauBordView({Key? key}) : super(key: key);

  @override
  State<TableauBordView> createState() => _TableauBordViewState();
}

class _TableauBordViewState extends State<TableauBordView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToView(Widget destination) {
    _animationController.forward().then((_) {
      _animationController.reverse();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (!authService.isAuthenticated || user?.role != 'ADMINISTRATEUR') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Accès refusé. Vous n\'avez pas le rôle Administrateur.'),
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
        title: const Text('Tableau de Bord Administrateur'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Déconnexion'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await authService.logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
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
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              accountName: Text(
                '${user?.firstname ?? ''} ${user?.lastname ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.firstname?.substring(0, 1).toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 40.0, color: Colors.black54),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.people,
              title: 'Gestion des utilisateurs',
              onTap: () {
                Navigator.pop(context);
                _navigateToView(const GestionUtilisateursView());
              },
            ),
            _buildDrawerItem(
              icon: Icons.add_circle,
              title: 'Créer un trajet',
              onTap: () {
                Navigator.pop(context);
                _navigateToView(const CreationTrajetsView());
              },
            ),
            _buildDrawerItem(
              icon: Icons.assignment,
              title: 'Affecter un trajet',
              onTap: () {
                Navigator.pop(context);
                _navigateToView(const AttributionTrajetsChauffeursView());
              },
            ),
            _buildDrawerItem(
              icon: Icons.location_city,
              title: 'Gestion des villes',
              onTap: () {
                Navigator.pop(context);
                _navigateToView(const GestionVillesView());
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Mon Profil',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profil');
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Paramètres',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implémenter la page des paramètres
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à venir')),
                );
              },
            ),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Déconnexion',
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
      body: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              'Gestion des utilisateurs',
              Icons.people,
              const GestionUtilisateursView(),
              0,
            ),
            _buildDashboardCard(
              context,
              'Création des trajets',
              Icons.add_circle,
              const CreationTrajetsView(),
              1,
            ),
            _buildDashboardCard(
              context,
              'Attribution des trajets',
              Icons.assignment,
              const AttributionTrajetsChauffeursView(),
              2,
            ),
            _buildDashboardCard(
              context,
              'Gestion des villes',
              Icons.location_city,
              const GestionVillesView(),
              3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      hoverColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget destination,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSelected 
              ? Theme.of(context).primaryColor.withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected 
              ? Theme.of(context).primaryColor
              : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() => _selectedIndex = index);
            _navigateToView(destination);
          },
          onTapDown: (_) => setState(() => _selectedIndex = index),
          onTapUp: (_) => setState(() => _selectedIndex = -1),
          onTapCancel: () => setState(() => _selectedIndex = -1),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                    ? Theme.of(context).primaryColor
                    : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 