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
  List<VilleDto> _villes = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  bool _isEditing = false;
  String? _editingVilleId;

  @override
  void initState() {
    super.initState();
    _loadVilles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nomController.dispose();
    super.dispose();
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

  void _resetForm() {
    _formKey.currentState?.reset();
    _nomController.clear();
    _isEditing = false;
    _editingVilleId = null;
  }

  void _editVille(VilleDto ville) {
    setState(() {
      _isEditing = true;
      _editingVilleId = ville.uuid;
      _nomController.text = ville.nom;
    });
    _showVilleForm();
  }

  void _showVilleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Modifier la ville' : 'Nouvelle ville',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la ville',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de la ville';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _resetForm();
                        },
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(_isEditing ? 'Modifier' : 'Créer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
              Navigator.pop(context);
              _resetForm();
              _loadVilles();
            }
          } else {
            throw Exception('Erreur lors de la modification');
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
                const SnackBar(content: Text('Ville créée avec succès')),
              );
              Navigator.pop(context);
              _resetForm();
              _loadVilles();
            }
          } else {
            throw Exception('Erreur lors de la création');
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
      }
    }
  }

  Future<void> _deleteVille(String villeId) async {
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
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final response = await ApiService.delete(
          '/villes/$villeId',
          token: authService.currentUser?.token,
        );

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ville supprimée avec succès')),
            );
            _loadVilles();
          }
        } else {
          throw Exception('Erreur lors de la suppression');
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
    }
  }

  List<VilleDto> get _filteredVilles {
    if (_searchQuery.isEmpty) return _villes;
    return _villes.where((ville) {
      final nom = ville.nom.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return nom.contains(query);
    }).toList();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher une ville...',
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
                              onPressed: _loadVilles,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _filteredVilles.isEmpty
                        ? const Center(
                            child: Text('Aucune ville trouvée'),
                          )
                        : ListView.builder(
                            itemCount: _filteredVilles.length,
                            itemBuilder: (context, index) {
                              final ville = _filteredVilles[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.location_city),
                                  ),
                                  title: Text(ville.nom),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Modifier'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Supprimer'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editVille(ville);
                                      } else if (value == 'delete' && ville.uuid != null) {
                                        _deleteVille(ville.uuid!);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetForm();
          _showVilleForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 