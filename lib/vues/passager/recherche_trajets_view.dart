import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/trajet_service.dart';
import '../../services/api_service.dart';
import '../../models/trajetDto.dart';
import '../../models/villeDto.dart';
import 'dart:convert';

class RechercheTrajetsView extends StatefulWidget {
  const RechercheTrajetsView({Key? key}) : super(key: key);

  @override
  State<RechercheTrajetsView> createState() => _RechercheTrajetsViewState();
}

class _RechercheTrajetsViewState extends State<RechercheTrajetsView> {
  VilleDto? _villeDepart;
  VilleDto? _villeArrivee;
  DateTime? _dateDepart;
  TimeOfDay? _heureDepart;
  List<TrajetDto> _trajets = [];
  List<VilleDto> _villes = [];
  bool _isLoading = false;
  bool _isLoadingVilles = true;
  String? _error;
  String? _errorVilles;

  @override
  void initState() {
    super.initState();
    _loadVilles();
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

  Future<void> _searchTrajets() async {
    if (_villeDepart == null || _villeArrivee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner les villes de départ et d\'arrivée'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final trajets = await TrajetService.search(
        departId: _villeDepart?.uuid,
        arriveId: _villeArrivee?.uuid,
        dateDepart: _dateDepart,
        timeDepart: _dateDepart != null && _heureDepart != null ? DateTime(
          _dateDepart!.year,
          _dateDepart!.month,
          _dateDepart!.day,
          _heureDepart!.hour,
          _heureDepart!.minute,
        ) : null,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateDepart ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dateDepart) {
      setState(() {
        _dateDepart = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _heureDepart ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _heureDepart) {
      setState(() {
        _heureDepart = picked;
      });
    }
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
        title: const Text('Recherche de Trajets'),
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Liste des trajets'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/passager/liste_trajets');
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
      body: _isLoadingVilles
          ? const Center(child: CircularProgressIndicator())
          : _errorVilles != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorVilles!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadVilles,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<VilleDto>(
                        value: _villeDepart,
                        decoration: const InputDecoration(
                          labelText: 'Ville de départ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        items: _villes.map((ville) {
                          return DropdownMenuItem(
                            value: ville,
                            child: Text(ville.nom),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _villeDepart = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<VilleDto>(
                        value: _villeArrivee,
                        decoration: const InputDecoration(
                          labelText: 'Ville d\'arrivée',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        items: _villes.map((ville) {
                          return DropdownMenuItem(
                            value: ville,
                            child: Text(ville.nom),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _villeArrivee = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Date de départ'),
                        subtitle: Text(
                          _dateDepart != null 
                            ? '${_dateDepart!.day}/${_dateDepart!.month}/${_dateDepart!.year}'
                            : 'Sélectionner une date',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text('Heure de départ'),
                        subtitle: Text(
                          _heureDepart != null 
                            ? _heureDepart!.format(context)
                            : 'Sélectionner une heure',
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => _selectTime(context),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _searchTrajets,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Rechercher'),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (_trajets.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Résultats de la recherche',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _trajets.length,
                          itemBuilder: (context, index) {
                            final trajet = _trajets[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
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
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/passager/reserver_billet',
                                      arguments: {
                                        'trajetUuid': trajet.uuid,
                                        'placesDispo': trajet.placesDisponibles ?? 1,
                                      },
                                    );
                                  },
                                  child: const Text('Réserver'),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
} 