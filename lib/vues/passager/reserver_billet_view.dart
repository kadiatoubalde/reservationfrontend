import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ReservationDto.dart';
import '../../services/reservation_service.dart';
import '../../services/auth_service.dart';

class ReserverBilletView extends StatefulWidget {
  final String trajetUuid;
  final int placesDispo;
  const ReserverBilletView({Key? key, required this.trajetUuid, required this.placesDispo}) : super(key: key);

  @override
  State<ReserverBilletView> createState() => _ReserverBilletViewState();
}

class _ReserverBilletViewState extends State<ReserverBilletView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreBagageController = TextEditingController();
  int _nombreBillets = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreBagageController.dispose();
    super.dispose();
  }

  Future<void> _reserver() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });
      try {
        final reservation = ReservationDto(
          trajetUuid: widget.trajetUuid,
          nombreBagage: int.parse(_nombreBagageController.text),
          nombreBillets: _nombreBillets,
        );
        final authService = Provider.of<AuthService>(context, listen: false);
        final token = authService.currentUser?.token ?? '';
        print('Envoi de la requête: ${reservation.toJson()}');
        await ReservationService().createReservation(reservation, token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Réservation effectuée avec succès!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        print('Erreur lors de la réservation: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Nombre de billets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _nombreBillets,
                decoration: const InputDecoration(),
                items: List.generate(
                  widget.placesDispo,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() { _nombreBillets = value; });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreBagageController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de bagages',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez le nombre de bagages';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Nombre invalide';
                  }
                  final number = int.parse(value);
                  if (number < 0) {
                    return 'Doit être >= 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _reserver,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Padding(
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