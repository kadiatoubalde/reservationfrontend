import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/villeDto.dart';
import 'dart:convert';

class CreationTrajetsView extends StatefulWidget {
  const CreationTrajetsView({Key? key}) : super(key: key);

  @override
  State<CreationTrajetsView> createState() => _CreationTrajetsViewState();
}

class _CreationTrajetsViewState extends State<CreationTrajetsView> {
  final _formKey = GlobalKey<FormState>();
  VilleDto? _villeDepart;
  VilleDto? _villeArrivee;
  final _placesController = TextEditingController();
  final _prixController = TextEditingController();
  DateTime? _dateDepart;
  TimeOfDay? _heureDepart;
  bool _isLoading = false;
  List<VilleDto> _villes = [];
  bool _isLoadingVilles = true;
  String? _errorVilles;

  @override
  void initState() {
    super.initState();
    _loadVilles();
  }

  @override
  void dispose() {
    _placesController.dispose();
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
          'depart': _villeDepart!.nom,
          'arrivee': _villeArrivee!.nom,
          'dateDepart': dateTime.toIso8601String(),
          'placesDisponibles': int.parse(_placesController.text),
          'prix': double.parse(_prixController.text),
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
              Navigator.pushNamed(context, '/gestion-villes');
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
              : SingleChildScrollView(
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
                          controller: _placesController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de places',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event_seat),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer le nombre de places';
                            }
                            final number = int.tryParse(value);
                            if (number == null || number <= 0) {
                              return 'Veuillez entrer un nombre valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _prixController,
                          decoration: const InputDecoration(
                            labelText: 'Prix',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.euro),
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
    );
  }
} 