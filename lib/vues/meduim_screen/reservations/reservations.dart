import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  static String path = "/reservations";

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Reservation> _reservations = [
    Reservation(
      depart: 'Conakry',
      arrivee: 'Mamou',
      heureDepart: '10h00',
      heureArrivee: '18h00',
      placesDisponibles: 7,
      prix: 100000,
      dateVoyage: DateTime.now().add(const Duration(days: 1)),
    ),
    Reservation(
      depart: 'Conakry',
      arrivee: 'Pita',
      heureDepart: '10h00',
      heureArrivee: '18h00',
      placesDisponibles: 7,
      prix: 100000,
      dateVoyage: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Reservation(
      depart: 'Conakry',
      arrivee: 'Labé',
      heureDepart: '08h00',
      heureArrivee: '16h00',
      placesDisponibles: 5,
      prix: 120000,
      dateVoyage: DateTime.now().add(const Duration(days: 3)),
    ),
  ];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _reservations.sort((a, b) => b.dateVoyage.compareTo(a.dateVoyage));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _chargerReservations() async {
    // Cette méthode est maintenant vide car nous n'avons plus besoin de chargement
    return;
  }

  List<Reservation> get reservationsAVenir {
    return _reservations.where((r) => r.dateVoyage.isAfter(DateTime.now())).toList()
      ..sort((a, b) => a.dateVoyage.compareTo(b.dateVoyage)); // Trier par date croissante
  }

  List<Reservation> get reservationsPassees {
    return _reservations.where((r) => !r.dateVoyage.isAfter(DateTime.now())).toList()
      ..sort((a, b) => b.dateVoyage.compareTo(a.dateVoyage)); // Trier par date décroissante
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mes réservations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF213FAA),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF213FAA),
          tabs: const [
            Tab(
              icon: Icon(Icons.upcoming),
              text: 'À venir',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Passées',
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _chargerReservations,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildReservationsList(reservationsAVenir),
            _buildReservationsList(reservationsPassees),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF213FAA)),
          ),
          SizedBox(height: 16),
          Text(
            'Chargement des réservations...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'Une erreur est survenue',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _chargerReservations,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF213FAA),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(bool isUpcoming) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUpcoming ? Icons.upcoming : Icons.history,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isUpcoming
                ? 'Vous n\'avez pas de réservations à venir'
                : 'Vous n\'avez pas de réservations passées',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isUpcoming
                ? 'Explorez nos voyages disponibles pour réserver votre prochain trajet'
                : 'Vos réservations passées apparaîtront ici',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          if (isUpcoming) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigation vers la page de recherche de voyages
                Navigator.pushNamed(context, '/listeVoyages');
              },
              icon: const Icon(Icons.search),
              label: const Text('Rechercher un voyage'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213FAA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReservationsList(List<Reservation> reservations) {
    if (reservations.isEmpty) {
      return _buildEmptyView(_tabController.index == 0);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return Column(
          children: [
            ReservationCard(
              depart: reservation.depart,
              arrivee: reservation.arrivee,
              heureDepart: reservation.heureDepart,
              heureArrivee: reservation.heureArrivee,
              placesDisponibles: reservation.placesDisponibles,
              prix: reservation.prix,
              dateVoyage: reservation.dateVoyage,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

// Modèle de données pour une réservation
class Reservation {
  final String depart;
  final String arrivee;
  final String heureDepart;
  final String heureArrivee;
  final int placesDisponibles;
  final int prix;
  final DateTime dateVoyage;

  Reservation({
    required this.depart,
    required this.arrivee,
    required this.heureDepart,
    required this.heureArrivee,
    required this.placesDisponibles,
    required this.prix,
    required this.dateVoyage,
  });
}

class ReservationCard extends StatelessWidget {
  final String depart;
  final String arrivee;
  final String heureDepart;
  final String heureArrivee;
  final int placesDisponibles;
  final int prix;
  final DateTime dateVoyage;

  const ReservationCard({
    Key? key,
    required this.depart,
    required this.arrivee,
    required this.heureDepart,
    required this.heureArrivee,
    required this.placesDisponibles,
    required this.prix,
    required this.dateVoyage,
  }) : super(key: key);

  bool get estAVenir => dateVoyage.isAfter(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');
    final statutColor = estAVenir ? const Color(0xFF4CAF50) : Colors.grey;
    final statutText = estAVenir ? 'À venir' : 'Passé';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Départ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      depart,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statutColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statutColor),
                  ),
                  child: Text(
                    statutText,
                    style: TextStyle(
                      color: statutColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Arrivée',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      arrivee,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 2,
                        color: statutColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: statutColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: statutColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(dateVoyage),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          heureDepart,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          heureArrivee,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people_outline),
                const SizedBox(width: 8),
                Text(
                  '$placesDisponibles places disponibles',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payment),
                const SizedBox(width: 8),
                Text(
                  '$prix GNF / Personne',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 