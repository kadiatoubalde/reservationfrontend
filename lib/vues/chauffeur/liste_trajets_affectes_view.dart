import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/trajet_service.dart';
import '../../models/trajetDto.dart';
import '../../models/statut_trajet.dart';

class ListeTrajetsAffectesView extends StatefulWidget {
  const ListeTrajetsAffectesView({Key? key}) : super(key: key);

  @override
  State<ListeTrajetsAffectesView> createState() => _ListeTrajetsAffectesViewState();
}

class _ListeTrajetsAffectesViewState extends State<ListeTrajetsAffectesView> {
  List<TrajetDto> _trajets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrajets();
  }

  Future<void> _loadTrajets() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final trajets = await TrajetService.getMesTrajets(
        token: authService.currentUser?.token ?? '',
      );

      setState(() {
        _trajets = trajets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _changeStatus(String trajetId, StatutTrajet newStatus) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await TrajetService.changeStatus(
        trajetId,
        newStatus.toString().split('.').last,
        authService.currentUser?.token ?? '',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Statut mis à jour avec succès')),
        );
        _loadTrajets(); // Recharger la liste pour voir les changements
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (!authService.isAuthenticated || authService.userRole != 'CHAUFFEUR') {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Trajets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrajets,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Mes Trajets Affectés'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Mes Passagers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chauffeur/gestion_reservations_recues');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadTrajets,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _trajets.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun trajet affecté',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadTrajets,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _trajets.length,
                        itemBuilder: (context, index) {
                          final trajet = _trajets[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${trajet.pointDepart ?? 'N/A'} → ${trajet.pointArriver ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(trajet.status).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _getStatusLabel(trajet.status),
                                          style: TextStyle(
                                            color: _getStatusColor(trajet.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${trajet.dateDepart?.toString().split(' ')[0] ?? 'N/A'} à ${trajet.timeDepart != null ? TimeOfDay.fromDateTime(trajet.timeDepart!).format(context) : 'N/A'}',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.money, size: 16, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text('${trajet.montant ?? 'N/A'} GNF'),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Changer le statut :',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<StatutTrajet>(
                                    value: trajet.status,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    items: StatutTrajet.values.map((status) {
                                      return DropdownMenuItem(
                                        value: status,
                                        child: Text(_getStatusLabel(status)),
                                      );
                                    }).toList(),
                                    onChanged: (StatutTrajet? newValue) {
                                      if (newValue != null) {
                                        _changeStatus(trajet.uuid!, newValue);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  String _getStatusLabel(StatutTrajet? status) {
    if (status == null) return 'Non défini';
    switch (status) {
      case StatutTrajet.PLANIFIE:
        return 'Planifié';
      case StatutTrajet.OUVERT:
        return 'Ouvert';
      case StatutTrajet.EN_COURS:
        return 'En cours';
      case StatutTrajet.COMPLET:
        return 'Complet';
      case StatutTrajet.TERMINE:
        return 'Terminé';
    }
  }

  Color _getStatusColor(StatutTrajet? status) {
    if (status == null) return Colors.grey;
    switch (status) {
      case StatutTrajet.PLANIFIE:
        return Colors.blue;
      case StatutTrajet.OUVERT:
        return Colors.green;
      case StatutTrajet.EN_COURS:
        return Colors.orange;
      case StatutTrajet.COMPLET:
        return Colors.purple;
      case StatutTrajet.TERMINE:
        return Colors.green;
    }
  }
}