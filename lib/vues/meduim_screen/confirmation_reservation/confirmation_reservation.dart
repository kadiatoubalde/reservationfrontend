import 'package:flutter/material.dart';
import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';
import '../liste_voyages/liste_voyages_disponibles.dart';
import '../reservations/reservations.dart';
import '../../../services/notification_service.dart';

class ConfirmationReservation extends StatefulWidget {
  const ConfirmationReservation({super.key});
  static String path = "/confirmationReservation";

  @override
  State<ConfirmationReservation> createState() => _ConfirmationReservationState();
}

class _ConfirmationReservationState extends State<ConfirmationReservation> {
  int nombrePlaces = 1;
  final NotificationService _notificationService = NotificationService();

  void increment() {
    setState(() {
      nombrePlaces++;
    });
  }

  void decrement() {
    if (nombrePlaces > 1) {
      setState(() {
        nombrePlaces--;
      });
    }
  }

  void _envoyerNotificationConfirmation() async {
    await _notificationService.envoyerNotificationConfirmation(
      numeroReservation: "12345",
      villeDepart: "Conakry",
      villeArrivee: "Mamou",
      dateVoyage: "2024-05-15",
      heureDepart: "10h00",
    );
  }

  @override
  Widget build(BuildContext context) {
    // Envoyer la notification dès que la page est construite
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _envoyerNotificationConfirmation();
    });

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Confirmer votre Voyage',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Expanded(child: Text("Depart", style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(child: Text("Arrivée", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              Row(
                children: const [
                  Expanded(child: Text("Conakry")),
                  Expanded(child: Text("Mamou", textAlign: TextAlign.right)),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.circle, color: Colors.blue, size: 12),
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.black),
                  ),
                  Icon(Icons.circle, color: Colors.blue, size: 12),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 4),
                      Text("10h00"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("18h00"),
                      SizedBox(width: 4),
                      Icon(Icons.access_time),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(Icons.people),
                  SizedBox(width: 8),
                  Text("7 places disponibles", style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.account_balance_wallet_outlined),
                  SizedBox(width: 8),
                  Text("100.000 GNF / Personne", style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: decrement,
                    icon: const Icon(Icons.remove),
                    color: Colors.black,
                  ),
                  Text(
                    "$nombrePlaces",
                    style: const TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: increment,
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ListeVoyagesDisponibles.path);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ReservationsPage.path);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF213FAA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Réserver",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}