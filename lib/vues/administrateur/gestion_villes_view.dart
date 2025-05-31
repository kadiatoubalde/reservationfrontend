import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../models/villeDto.dart';
import 'dart:convert';

class GestionVillesView extends StatefulWidget {
  const GestionVillesView({Key? key}) : super(key: key);

  @override
  State<GestionVillesView> createState() => _GestionVillesViewState();
}

class _GestionVillesViewState extends State<GestionVillesView> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  List<VilleDto> _villes = [];
  bool _isLoading = true;
  String? _error;
  bool _isEditing = false;
  String? _editingVilleId;

  @override
  void initState() {
    super.initState();
    _loadVilles();
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nomController.clear();
    setState(() {
      _isEditing = false;
      _editingVilleId = null;
    });
  }

  Future<void> _loadVilles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await ApiService.get('/villes', token: authService.currentUser?.token);
      
      if (response.statusCode == 200) {
        final List<dynamic> villesJson = json.decode(response.body);
        setState(() {
          _villes = villesJson.map((json) => VilleDto.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Erreur lors du chargement des villes';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _editVille(VilleDto ville) {
    setState(() {
      _isEditing = true;
      _editingVilleId = ville.uuid;
      _nomController.text = ville.nom;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final villeData = {
          'nom': _nomController.text,
        };

        if (_isEditing && _editingVilleId != null) {
          final response = await ApiService.put(
            '/villes/${_editingVilleId}',
            villeData,
            token: authService.currentUser?.token,
          );

          if (response.statusCode == 200) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ville modifiée avec succès')),
              );
              _resetForm();
              await _loadVilles();
            }
          } else {
            throw Exception('Erreur lors de la modification de la ville');
          }
        } else {
          final response = await ApiService.post(
            '/villes',
            villeData,
            token: authService.currentUser?.token,
          );

          if (response.statusCode == 201) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ville ajoutée avec succès')),
              );
              _resetForm();
              await _loadVilles();
            }
          } else {
            throw Exception('Erreur lors de l\'ajout de la ville');
          }
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
    }
  }

  Future<void> _supprimerVille(String villeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette ville ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final response = await ApiService.delete(
          '/villes/$villeId',
          token: authService.currentUser?.token,
        );

        if (response.statusCode == 204) {
          await _loadVilles();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ville supprimée avec succès')),
            );
          }
        } else {
          throw Exception('Erreur lors de la suppression de la ville');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Villes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVilles,
            tooltip: 'Actualiser',
          ),
        ],
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nomController,
                                    decoration: InputDecoration(
                                      labelText: _isEditing ? 'Nouveau nom de la ville' : 'Nom de la ville',
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.location_city),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer un nom de ville';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _submitForm,
                                  icon: Icon(_isEditing ? Icons.save : Icons.add),
                                  label: Text(_isEditing ? 'Modifier' : 'Ajouter'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                                if (_isEditing) ...[
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: _resetForm,
                                    icon: const Icon(Icons.cancel),
                                    label: const Text('Annuler'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _villes.length,
                        itemBuilder: (context, index) {
                          final ville = _villes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.location_city),
                              title: Text(ville.nom),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editVille(ville),
                                    tooltip: 'Modifier la ville',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      if (ville.uuid != null) {
                                        _supprimerVille(ville.uuid!);
                                      }
                                    },
                                    tooltip: 'Supprimer la ville',
                                  ),
                                ],
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