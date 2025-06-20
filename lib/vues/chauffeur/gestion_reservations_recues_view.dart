import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/trajet_service.dart';
import '../../models/PassagerDto.dart';

class GestionReservationsRecuesView extends StatefulWidget {
  const GestionReservationsRecuesView({Key? key}) : super(key: key);

  @override
  State<GestionReservationsRecuesView> createState() => _GestionReservationsRecuesViewState();
}

class _GestionReservationsRecuesViewState extends State<GestionReservationsRecuesView> {
  List<PassagerDto> _passagers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPassagers();
  }

  Future<void> _loadPassagers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.currentUser?.token;
      if (token != null) {
        _passagers = await TrajetService.getMesPassagers(token);
      } else {
        _error = 'Utilisateur non authentifié';
      }
    } catch (e) {
      _error = 'Erreur lors du chargement des passagers: ${e.toString()}';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Passagers'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _passagers.isEmpty
                  ? const Center(child: Text('Aucun passager trouvé'))
                  : ListView.builder(
                      itemCount: _passagers.length,
                      itemBuilder: (context, index) {
                        final passager = _passagers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(passager.firstname.isNotEmpty ? passager.firstname[0].toUpperCase() : '?'),
                            ),
                            title: Text('${passager.firstname} ${passager.lastname}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Téléphone : ${passager.telephone}'),
                                Text('Billets : ${passager.nombreBillet}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
} 