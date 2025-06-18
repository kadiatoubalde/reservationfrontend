import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/reservation_service.dart';
import '../../models/ma_reservation_dto.dart';
import 'package:intl/intl.dart';

class ListeReservationsView extends StatefulWidget {
  const ListeReservationsView({Key? key}) : super(key: key);

  @override
  State<ListeReservationsView> createState() => _ListeReservationsViewState();
}

class _ListeReservationsViewState extends State<ListeReservationsView> {
  List<MaReservationDto> _reservations = [];
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
        _reservations = await ReservationService.getMesReservations(token);
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

  Color _statusColor(String statut) {
    switch (statut.toUpperCase()) {
      case 'EN_COURS':
        return Colors.blue;
      case 'TERMINE':
      case 'PASSEE':
        return Colors.grey;
      case 'ANNULEE':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String statut) {
    switch (statut.toUpperCase()) {
      case 'EN_COURS':
        return 'En cours';
      case 'TERMINE':
        return 'Terminée';
      case 'PASSEE':
        return 'Passée';
      case 'ANNULEE':
        return 'Annulée';
      default:
        return statut;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!))
                  : _reservations.isEmpty
                      ? const Center(child: Text('Aucune réservation trouvée'))
                      : ListView.builder(
                          itemCount: _reservations.length,
                          itemBuilder: (context, index) {
                            final reservation = _reservations[index];
                            final statusColor = _statusColor(reservation.statut);
                            final statusLabel = _statusLabel(reservation.statut);
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                child: isWide
                                    ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: statusColor.withOpacity(0.15),
                                            child: Icon(
                                              statusLabel == 'En cours'
                                                  ? Icons.directions_bus
                                                  : Icons.check_circle_outline,
                                              color: statusColor,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Réservation n°: ${reservation.numeroReservation}',
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: statusColor.withOpacity(0.15),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        statusLabel,
                                                        style: TextStyle(
                                                          color: statusColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text('Date : ${DateFormat('dd/MM/yyyy HH:mm').format(reservation.date)}'),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Text('Bagages : ${reservation.nombreBagage}'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: statusColor.withOpacity(0.15),
                                          child: Icon(
                                            statusLabel == 'En cours'
                                                ? Icons.directions_bus
                                                : Icons.check_circle_outline,
                                            color: statusColor,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Réservation n°: ${reservation.numeroReservation}',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                statusLabel,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Date : ${DateFormat('dd/MM/yyyy HH:mm').format(reservation.date)}'),
                                              Text('Bagages : ${reservation.nombreBagage}'),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                        );
        },
      ),
    );
  }
}