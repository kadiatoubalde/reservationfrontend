import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';
import '../confirmation_reservation/confirmation_reservation.dart';

class ListeVoyagesDisponibles extends StatelessWidget {
  const ListeVoyagesDisponibles({super.key});
  static String path = "/listeVoyages";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/accueilPassager');
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Liste des voyages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213FAA),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Rechercher un voyage',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                voyageCard(context, "Conakry", "Mamou", "10h00", "18h00", 7, "100.000 GNF"),
                const SizedBox(height: 20),
                voyageCard(context, "Conakry", "Pita", "10h00", "18h00", 7, "100.000 GNF"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget voyageCard(BuildContext context, String dep, String arr, String heureDep, String heureArr,
      int places, String prix) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Depart", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Arrivée", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dep),
                Expanded(
                  child: Row(
                    children: const [
                      Icon(Icons.circle, size: 10, color: Color(0xFF213FAA)),
                      Expanded(child: Divider(color: Colors.black)),
                      Icon(Icons.circle, size: 10, color: Color(0xFF213FAA)),
                    ],
                  ),
                ),
                Text(arr),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 5),
                    Text(heureDep),
                  ],
                ),
                Row(
                  children: [
                    Text(heureArr),
                    const SizedBox(width: 5),
                    const Icon(Icons.access_time),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.group),
                const SizedBox(width: 5),
                Text('$places places disponibles'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined),
                const SizedBox(width: 5),
                Text('$prix / Personne'),
              ],
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ConfirmationReservation.path);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF213FAA),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Réserver',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}