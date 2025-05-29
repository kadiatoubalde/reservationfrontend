import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';
import 'dart:convert';

class AttributionTrajetsChauffeursView extends StatefulWidget {
  const AttributionTrajetsChauffeursView({Key? key}) : super(key: key);

  @override
  State<AttributionTrajetsChauffeursView> createState() => _AttributionTrajetsChauffeursViewState();
}

class _AttributionTrajetsChauffeursViewState extends State<AttributionTrajetsChauffeursView> {
  List<dynamic> _trajets = [];
  List<User> _chauffeurs = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // Charger les trajets
      final trajetsResponse = await ApiService.get(
        '/trajets',
        token: authService.currentUser?.token,
      );
      
      // Charger les chauffeurs
      final chauffeursResponse = await ApiService.get(
        '/users?role=CHAUFFEUR',
        token: authService.currentUser?.token,
      );

      if (trajetsResponse.statusCode == 200 && chauffeursResponse.statusCode == 200) {
        setState(() {
          _trajets = json.decode(trajetsResponse.body);
          _chauffeurs = (json.decode(chauffeursResponse.body) as List)
              .map((json) => User.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Erreur lors du chargement des données');
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _attribuerTrajet(String trajetId, String chauffeurId) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await ApiService.post(
        '/trajets/$trajetId/attribuer',
        {'chauffeurId': chauffeurId},
        token: authService.currentUser?.token,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trajet attribué avec succès')),
        );
        _loadData();
      } else {
        throw Exception('Erreur lors de l\'attribution du trajet');
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

  List<dynamic> get _filteredTrajets {
    if (_searchQuery.isEmpty) return _trajets;
    return _trajets.where((trajet) {
      final depart = trajet['depart'].toString().toLowerCase();
      final arrivee = trajet['arrivee'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return depart.contains(query) || arrivee.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attribution des Trajets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Actualiser',
          ),
        ],
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
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadData,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _filteredTrajets.isEmpty
                        ? const Center(
                            child: Text('Aucun trajet trouvé'),
                          )
                        : ListView.builder(
                            itemCount: _filteredTrajets.length,
                            itemBuilder: (context, index) {
                              final trajet = _filteredTrajets[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ExpansionTile(
                                  title: Text(
                                    '${trajet['depart']} → ${trajet['arrivee']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Date: ${DateTime.parse(trajet['dateDepart']).toString().split('.')[0]}',
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Places disponibles: ${trajet['placesDisponibles']}',
                                          ),
                                          Text(
                                            'Prix: ${trajet['prix']}€',
                                          ),
                                          const SizedBox(height: 16),
                                          if (_chauffeurs.isNotEmpty) ...[
                                            const Text(
                                              'Attribuer à un chauffeur:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              children: _chauffeurs.map((chauffeur) {
                                                return ActionChip(
                                                  avatar: CircleAvatar(
                                                    child: Text(
                                                      (chauffeur.firstname?.isNotEmpty ?? false)
                                                          ? chauffeur.firstname![0].toUpperCase()
                                                          : '?',
                                                    ),
                                                  ),
                                                  label: Text(
                                                    '${chauffeur.firstname ?? ''} ${chauffeur.lastname ?? ''}',
                                                  ),
                                                  onPressed: () {
                                                    if (chauffeur.uuid != null) {
                                                      _attribuerTrajet(
                                                        trajet['id'].toString(),
                                                        chauffeur.uuid!,
                                                      );
                                                    }
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          ] else
                                            const Text(
                                              'Aucun chauffeur disponible',
                                              style: TextStyle(
                                                color: Colors.red,
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
        ],
      ),
    );
  }
} 