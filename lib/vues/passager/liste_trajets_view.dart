import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/trajet_service.dart';
import '../../models/trajetDto.dart';
import '../../models/statut_trajet.dart';

class ListeTrajetsView extends StatefulWidget {
  const ListeTrajetsView({Key? key}) : super(key: key);

  @override
  State<ListeTrajetsView> createState() => _ListeTrajetsViewState();
}

class _ListeTrajetsViewState extends State<ListeTrajetsView> {
  List<TrajetDto> _trajets = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTrajets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTrajets() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final trajets = await TrajetService.getAll(
        authService.currentUser?.token ?? '',
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

  List<TrajetDto> get _filteredTrajets {
    if (_searchQuery.isEmpty) return _trajets;
    return _trajets.where((trajet) {
      final depart = trajet.pointDepart?.toLowerCase() ?? '';
      final arrivee = trajet.pointArriver?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return depart.contains(query) || arrivee.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (!authService.isAuthenticated || authService.userRole != 'PASSAGER') {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Trajets'),
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
              leading: const Icon(Icons.search),
              title: const Text('Rechercher des trajets'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/passager/recherche_trajets');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Liste des trajets'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: const Text('Mes réservations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/passager/liste_reservations');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mon Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profil');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un trajet...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: _isLoading
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
                    : _filteredTrajets.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun trajet disponible',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadTrajets,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _filteredTrajets.length,
                              itemBuilder: (context, index) {
                                final trajet = _filteredTrajets[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ExpansionTile(
                                    title: Text(
                                      '${trajet.pointDepart ?? 'N/A'} → ${trajet.pointArriver ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          'Date:  A0${trajet.dateDepart?.toString().split('.')[0] ?? 'N/A'}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Heure:  A0${trajet.timeDepart != null ? TimeOfDay.fromDateTime(trajet.timeDepart!).format(context) : 'N/A'}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Prix:  A0${trajet.montant ?? 'N/A'} GNF',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Places:  A0${trajet.nombrePlaces ?? 'N/A'}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Véhicule:  A0${trajet.typeVehicule ?? 'N/A'}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Statut:  A0${_getStatusLabel(trajet.status)}',
                                          style: TextStyle(
                                            color: _getStatusColor(trajet.status),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: trajet.status == StatutTrajet.OUVERT
                                                  ? () {
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/passager/reserver_billet',
                                                        arguments: {
                                                          'trajetUuid': trajet.uuid,
                                                          'placesDispo': trajet.placesDisponibles ?? 1,
                                                        },
                                                      );
                                                    }
                                                  : null,
                                              icon: const Icon(Icons.confirmation_number),
                                              label: const Text('Réserver un billet'),
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.all(16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
} 