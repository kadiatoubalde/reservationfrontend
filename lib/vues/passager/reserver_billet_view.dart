import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class ReserverBilletView extends StatefulWidget {
  const ReserverBilletView({Key? key}) : super(key: key);

  @override
  State<ReserverBilletView> createState() => _ReserverBilletViewState();
}

class _ReserverBilletViewState extends State<ReserverBilletView> {
  final _formKey = GlobalKey<FormState>();
  int _nombreBillets = 1;
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();

  // Données fictives du trajet pour la démonstration
  final Map<String, dynamic> _trajet = {
    'id': 1,
    'depart': 'Fria',
    'arrivee': 'Conakry',
    'date': '2024-03-20',
    'heure': '10:00',
    'prix': 50.0,
    'places': 5,
  };

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userRole = authService.userRole;

    if (!authService.isAuthenticated || userRole != 'PASSAGER') {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un Billet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détails du trajet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Départ: ${_trajet['depart']}'),
                      const SizedBox(height: 8),
                      Text('Arrivée: ${_trajet['arrivee']}'),
                      const SizedBox(height: 8),
                      Text('Date: ${_trajet['date']}'),
                      const SizedBox(height: 8),
                      Text('Heure: ${_trajet['heure']}'),
                      const SizedBox(height: 8),
                      Text('Prix: ${_trajet['prix']} €'),
                      const SizedBox(height: 8),
                      Text('Places disponibles: ${_trajet['places']}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nombre de billets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _nombreBillets,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  _trajet['places'],
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _nombreBillets = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
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
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
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
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Implémenter la réservation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Réservation effectuée avec succès!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Confirmer la réservation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 