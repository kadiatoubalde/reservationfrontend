import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';

import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';
class ResetPassword extends StatefulWidget {

  const ResetPassword({super.key});
  static String path = "/resetPassword";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: MyStyles.raisinBlack,
            size: screenWidth * 0.07,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Logo EasyTravel
            Center(
              child: Image.asset(
                'assets/images/easytravel_logo.png',
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Réinitialiser le mot de passe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildPasswordField(
              label: "Nouveau mot de passe",
              controller: passwordController,
              obscureText: obscurePassword,
              onVisibilityToggle: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),

            _buildPasswordField(
              label: "Confirmer le mot de passe",
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              onVisibilityToggle: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
            ),

            const SizedBox(height: 25),

            // Bouton Réinitialiser
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Les mots de passe ne correspondent pas")),
                    );
                  } else {
                    // Action de réinitialisation ici
                    Navigator.pushReplacementNamed(context, "/login");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyStyles.egyptianBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Réinitialiser",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: onVisibilityToggle,
          ),
        ),
      ),
    );
  }
}