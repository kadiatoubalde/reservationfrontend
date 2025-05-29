import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../models/utilisateurDto.dart';
import '../../services/api_service.dart';
import 'dart:convert';

class GestionUtilisateursView extends StatefulWidget {
  const GestionUtilisateursView({Key? key}) : super(key: key);

  @override
  State<GestionUtilisateursView> createState() => _GestionUtilisateursViewState();
}

class _GestionUtilisateursViewState extends State<GestionUtilisateursView> {
  List<User> _users = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  bool _isEditing = false;
  String? _editingUserId;
  bool _showPassword = false;

  final List<String> _roles = ['ADMINISTRATEUR', 'CHAUFFEUR', 'PASSAGER'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _telephoneController.clear();
    _passwordController.clear();
    _selectedRole = null;
    _isEditing = false;
    _editingUserId = null;
    _showPassword = false;
  }

  void _editUser(User user) {
    setState(() {
      _isEditing = true;
      _editingUserId = user.uuid;
      _firstnameController.text = user.firstname ?? '';
      _lastnameController.text = user.lastname ?? '';
      _emailController.text = user.email ?? '';
      _telephoneController.text = user.telephone ?? '';
      _selectedRole = user.role;
      _passwordController.clear();
    });
    _showUserForm();
  }

  void _showUserForm() {
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
                  _isEditing ? 'Modifier l\'utilisateur' : 'Nouvel utilisateur',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    if (!value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telephoneController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (!_isEditing) ...[
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !_showPassword,
                    validator: (value) {
                      if (!_isEditing && (value == null || value.isEmpty)) {
                        return 'Veuillez entrer un mot de passe';
                      }
                      if (value != null && value.length < 6) {
                        return 'Le mot de passe doit contenir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner un rôle';
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
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final utilisateurDto = UtilisateurDto(
          firstname: _firstnameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          telephone: _telephoneController.text,
          password: _passwordController.text,
          role: _selectedRole!,
        );

        if (_isEditing && _editingUserId != null) {
          final response = await ApiService.put(
            '/users/${_editingUserId}',
            utilisateurDto.toJson(),
            token: authService.currentUser?.token,
          );

          if (response.statusCode == 200) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utilisateur modifié avec succès')),
              );
              Navigator.pop(context);
              _resetForm();
              _loadUsers();
            }
          } else {
            throw Exception('Erreur lors de la modification');
          }
        } else {
          final response = await ApiService.post(
            '/users',
            utilisateurDto.toJson(),
            token: authService.currentUser?.token,
          );

          if (response.statusCode == 201) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utilisateur créé avec succès')),
              );
              Navigator.pop(context);
              _resetForm();
              _loadUsers();
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

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await ApiService.get('/users', token: authService.currentUser?.token);
      
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        setState(() {
          _users = usersJson.map((json) => User.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Erreur lors du chargement des utilisateurs';
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

  Future<void> _deleteUser(String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
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
          '/users/$userId',
          token: authService.currentUser?.token,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Utilisateur supprimé avec succès')),
          );
          _loadUsers();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la suppression'),
              backgroundColor: Colors.red,
            ),
          );
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
  }

  List<User> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) {
      final fullName = '${user.firstname ?? ''} ${user.lastname ?? ''}'.toLowerCase();
      final email = user.email?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return fullName.contains(query) || email.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
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
                hintText: 'Rechercher un utilisateur...',
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
                              onPressed: _loadUsers,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _filteredUsers.isEmpty
                        ? const Center(
                            child: Text('Aucun utilisateur trouvé'),
                          )
                        : ListView.builder(
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      (user.firstname?.isNotEmpty ?? false)
                                          ? user.firstname![0].toUpperCase()
                                          : '?',
                                    ),
                                  ),
                                  title: Text(
                                    '${user.firstname ?? ''} ${user.lastname ?? ''}',
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.email ?? ''),
                                      Text(
                                        'Rôle: ${user.role ?? 'Non défini'}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
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
                                        _editUser(user);
                                      } else if (value == 'delete' && user.uuid != null) {
                                        _deleteUser(user.uuid!);
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
          _showUserForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 