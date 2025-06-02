import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/villeDto.dart';
import '../../models/trajetDto.dart';
import 'dart:convert';
import '../../routes.dart';

class CreationTrajetsView extends StatefulWidget {
  const CreationTrajetsView({Key? key}) : super(key: key);

  @override
  State<CreationTrajetsView> createState() => _CreationTrajetsViewState();
}

class _CreationTrajetsViewState extends State<CreationTrajetsView> {
  final _formKey = GlobalKey<FormState>();
  VilleDto? _villeDepart;
  VilleDto? _villeArrivee;
  final _prixController = TextEditingController();
  DateTime? _dateDepart;
  TimeOfDay? _heureDepart;
  bool _isLoading = false;
  List<VilleDto> _villes = [];
  bool _isLoadingVilles = true;
  String? _errorVilles;
  List<TrajetDto> _trajets = [];
  bool _isLoadingTrajets = true;
  String? _errorTrajets;

  @override
  void initState() {
    super.initState();
    _loadVilles();
    _loadTrajets();
  }

  @override
  void dispose() {
    _prixController.dispose();
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

  Future<void> _loadTrajets() async {
    setState(() {
      _isLoadingTrajets = true;
      _errorTrajets = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await ApiService.get('/trajets', token: authService.currentUser?.token);
      
      if (response.statusCode == 200) {
        final List<dynamic> trajetsJson = json.decode(response.body);
        setState(() {
          _trajets = trajetsJson.map((json) => TrajetDto.fromJson(json)).toList();
          _isLoadingTrajets = false;
        });
      } else {
        setState(() {
          _errorTrajets = 'Erreur lors du chargement des trajets';
          _isLoadingTrajets = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorTrajets = 'Erreur: ${e.toString()}';
        _isLoadingTrajets = false;
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _villeDepart != null &&
        _villeArrivee != null &&
        _dateDepart != null &&
        _heureDepart != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final dateTime = DateTime(
          _dateDepart!.year,
          _dateDepart!.month,
          _dateDepart!.day,
          _heureDepart!.hour,
          _heureDepart!.minute,
        );

        final trajetData = {
          'uuidPointDepart': _villeDepart!.uuid,
          'uuidPointArriver': _villeArrivee!.uuid,
          'montant': double.parse(_prixController.text),
          'dateDepart': dateTime.toIso8601String(),
          'timeDepart': dateTime.toIso8601String(),
        };

        final response = await ApiService.post(
          '/trajets',
          trajetData,
          token: authService.currentUser?.token,
        );

        if (response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trajet créé avec succès')),
            );
            _formKey.currentState!.reset();
            setState(() {
              _villeDepart = null;
              _villeArrivee = null;
              _dateDepart = null;
              _heureDepart = null;
            });
            _loadTrajets();
          }
        } else {
          throw Exception('Erreur lors de la création du trajet');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création de Trajet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: () {
              Navigator.pushNamed(context, Routes.adminGestionVilles);
            },
            tooltip: 'Gérer les villes',
          ),
        ],
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
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
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
                                validator: (value) {
                                  if (value == null) {
                                    return 'Veuillez sélectionner une ville de départ';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value == null) {
                                    return 'Veuillez sélectionner une ville d\'arrivée';
                                  }
                                  if (value == _villeDepart) {
                                    return 'La ville d\'arrivée doit être différente de la ville de départ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () => _selectDate(context),
                                      icon: const Icon(Icons.calendar_today),
                                      label: Text(
                                        _dateDepart == null
                                            ? 'Sélectionner la date'
                                            : '${_dateDepart!.day}/${_dateDepart!.month}/${_dateDepart!.year}',
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () => _selectTime(context),
                                      icon: const Icon(Icons.access_time),
                                      label: Text(
                                        _heureDepart == null
                                            ? 'Sélectionner l\'heure'
                                            : _heureDepart!.format(context),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(16),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _prixController,
                                decoration: const InputDecoration(
                                  labelText: 'Prix',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.attach_money),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer le prix';
                                  }
                                  final number = double.tryParse(value);
                                  if (number == null || number <= 0) {
                                    return 'Veuillez entrer un prix valide';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        'Créer le trajet',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: _isLoadingTrajets
                          ? const Center(child: CircularProgressIndicator())
                          : _errorTrajets != null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _errorTrajets!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _loadTrajets,
                                        child: const Text('Réessayer'),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _trajets.length,
                                  itemBuilder: (context, index) {
                                    final trajet = _trajets[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          '${trajet.pointDepart} → ${trajet.pointArriver}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            Text(
                                              'Date: ${trajet.dateDepart?.toString().split('.')[0]}',
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Heure: ${trajet.timeDepart != null ? TimeOfDay.fromDateTime(trajet.timeDepart!).format(context) : 'N/A'}',
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Prix: ${trajet.montant} GNF',
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            try {
                                              final authService = Provider.of<AuthService>(
                                                context,
                                                listen: false,
                                              );
                                              final response = await ApiService.delete(
                                                '/trajets/${trajet.uuid}',
                                                token: authService.currentUser?.token,
                                              );
                                              if (response.statusCode == 204) {
                                                _loadTrajets();
                                                if (mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Trajet supprimé avec succès'),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                throw Exception('Erreur lors de la suppression du trajet');
                                              }
                                            } catch (e) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Erreur: ${e.toString()}'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
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