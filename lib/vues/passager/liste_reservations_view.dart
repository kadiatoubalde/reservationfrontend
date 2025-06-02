import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/reservation_service.dart';
import '../../models/reservationDto.dart';

class ListeReservationsView extends StatefulWidget {
  const ListeReservationsView({Key? key}) : super(key: key);

  @override
  State<ListeReservationsView> createState() => _ListeReservationsViewState();
}

class _ListeReservationsViewState extends State<ListeReservationsView> {
  List<ReservationDto> _reservations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.currentUser?.token;

      if (token != null) {
        // Assuming getAll fetches reservations for the current user with their token
        // If not, we might need a specific endpoint or filter on the client side.
        _reservations = await ReservationService.getAll(token);
      } else {
        _error = 'Utilisateur non authentifié';
      }
    } catch (e) {
      _error = 'Erreur lors du chargement des réservations: ${e.toString()}';
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
        title: const Text('Mes Réservations'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _reservations.isEmpty
                  ? const Center(child: Text('Aucune réservation trouvée'))
                  : ListView.builder(
                      itemCount: _reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = _reservations[index];
                        return ListTile(
                          title: Text(
                              '${reservation.pointDepart ?? 'N/A'} → ${reservation.pointArriver ?? 'N/A'}'),
                          subtitle: Text(
                              'Date: ${reservation.uuidTrajet ?? 'N/A'} - Montant: ${reservation.montant ?? 'N/A'}'), // Need to adjust subtitle content
                          // Add more details as needed
                        );
                      },
                    ),
    );
  }
}