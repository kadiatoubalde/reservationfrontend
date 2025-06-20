import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../services/trajet_service.dart';
import '../../models/user.dart';
import '../../models/trajetDto.dart';
import '../../models/villeDto.dart';
import '../../models/statut_trajet.dart';
import 'dart:convert';

class AttributionTrajetsChauffeursView extends StatefulWidget {
  const AttributionTrajetsChauffeursView({Key? key}) : super(key: key);

  @override
  State<AttributionTrajetsChauffeursView> createState() => _AttributionTrajetsChauffeursViewState();
}

class _AttributionTrajetsChauffeursViewState extends State<AttributionTrajetsChauffeursView> {
  List<TrajetDto> _trajets = [];
  List<User> _chauffeurs = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<VilleDto> _villes = [];
  bool _isLoadingVilles = true;
  String? _errorVilles;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadVilles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVilles() async {
    setState(() {
      _isLoadingVilles = true;
      _errorVilles = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await ApiService.get('/villes', token: authService.currentUser?.token);
      
      if (response.statusCode == 200) {
        final List<dynamic> villesJson = json.decode(response.body);
        setState(() {
          _villes = villesJson.map((json) => VilleDto.fromJson(json)).toList();
          _isLoadingVilles = false;
        });
      } else {
        setState(() {
          _errorVilles = 'Erreur lors du chargement des villes';
          _isLoadingVilles = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorVilles = 'Erreur: ${e.toString()}';
        _isLoadingVilles = false;
      });
    }
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
        '/utilisateur?role=CHAUFFEUR',
        token: authService.currentUser?.token,
      );

      if (trajetsResponse.statusCode == 200 && chauffeursResponse.statusCode == 200) {
        setState(() {
          _trajets = (json.decode(trajetsResponse.body) as List)
              .map((json) => TrajetDto.fromJson(json))
              .toList();
          _chauffeurs = (json.decode(chauffeursResponse.body) as List)
              .map((json) => User.fromJson(json))
              .toList();
          _isLoading = false;
          print('Trajets loaded: ${_trajets.length}'); // Debug print
          if (_trajets.isNotEmpty) {
            print('First trajet data: ${_trajets.first.toJson()}'); // Debug print
          }
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
        _loadData(); // Recharger la liste pour voir les changements
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
      default:
        return 'Inconnu';
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
      default:
        return Colors.grey;
    }
  }

  // Helper to find city name by UUID
  String getVilleNom(String? uuid) {
    if (uuid == null) return 'N/A';
    final ville = _villes.firstWhere(
      (ville) => ville.uuid == uuid,
      orElse: () => VilleDto(nom: 'Inconnue'), // Default if not found
    );
    return ville.nom;
  }

  List<TrajetDto> get _filteredTrajets {
    if (_searchQuery.isEmpty) return _trajets;
    return _trajets.where((trajet) {
      // Use the directly provided city names for filtering
      final depart = trajet.pointDepart?.toLowerCase() ?? '';
      final arrivee = trajet.pointArriver?.toLowerCase() ?? '';
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
      body: (_isLoading || _isLoadingVilles)
          ? const Center(child: CircularProgressIndicator())
          : (_error != null || _errorVilles != null)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error ?? _errorVilles!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _loadData();
                          _loadVilles();
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : Column(
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
                      child: _filteredTrajets.isEmpty
                          ? const Center(
                              child: Text('Aucun trajet trouvé'),
                            )
                          : ListView.builder(
                              itemCount: _filteredTrajets.length,
                              itemBuilder: (context, index) {
                                final trajet = _filteredTrajets[index];
                                final isAttributed = trajet.chauffeurId != null;
                                final attributedChauffeur = isAttributed 
                                    ? _chauffeurs.firstWhere(
                                        (c) => c.uuid == trajet.chauffeurId,
                                        orElse: () => User(),
                                      )
                                    : null;

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  color: isAttributed ? Colors.grey[100] : null,
                                  child: ExpansionTile(
                                    leading: isAttributed
                                        ? Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                    title: Text(
                                      '${trajet.pointDepart ?? 'N/A'} → ${trajet.pointArriver ?? 'N/A'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isAttributed ? Colors.green[700] : null,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          'Date: ${trajet.dateDepart?.toString().split('.')[0] ?? 'N/A'}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Heure: ${trajet.timeDepart != null ? TimeOfDay.fromDateTime(trajet.timeDepart!).format(context) : 'N/A'}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Prix: ${trajet.montant ?? 'N/A'} GNF',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Statut: ${_getStatusLabel(trajet.status)}',
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Changer le statut:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            DropdownButtonFormField<StatutTrajet>(
                                              value: trajet.status,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
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
                                            const SizedBox(height: 16),
                                            if (!isAttributed && _chauffeurs.isNotEmpty) ...[
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
                                                          trajet.uuid.toString(),
                                                          chauffeur.uuid!,
                                                        );
                                                      }
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            ] else if (isAttributed)
                                              const Text(
                                                'Ce trajet est déjà attribué à un chauffeur',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            else
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