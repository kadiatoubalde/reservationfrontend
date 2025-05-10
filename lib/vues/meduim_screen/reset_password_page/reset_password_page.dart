import 'package:flutter/material.dart';
import '../../../utils/global_functions/my_styles.dart';

class ResetPasswordPage extends StatelessWidget {
  static String path = "/reset-password";

  final TextEditingController emailController = TextEditingController();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyStyles.raisinBlack,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Réinitialiser le mot de passe",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyStyles.raisinBlack,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Adresse email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyStyles.egyptianBlue,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Lien de réinitialisation envoyé."),
                  ),
                );
              },
              child: const Text("Envoyer", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
