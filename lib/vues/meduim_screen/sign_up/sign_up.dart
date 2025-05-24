import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';

import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static String path = "/signUp";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  String? _selectedRole;
  final List<String> roles = ['PASSAGER', 'CHAUFFEUR', 'ADMIN'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: MyStyles.raisinBlack, size: screenWidth * 0.07),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/easytravel_logo.png',
                  height: screenHeight * 0.15,
                  width: screenWidth * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),

              // Champs du formulaire
              _buildTextField("Nom", nomController),
              _buildTextField("Prénom", prenomController),
              _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress),
              _buildTextField("Téléphone", telephoneController, keyboardType: TextInputType.phone),

              _buildPasswordField("Mot de passe", passwordController, obscurePassword, () {
                setState(() => obscurePassword = !obscurePassword);
              }),

              _buildPasswordField("Confirmer le mot de passe", confirmPasswordController, obscureConfirmPassword, () {
                setState(() => obscureConfirmPassword = !obscureConfirmPassword);
              }),

              // Rôle : déplacé ici
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rôle',
                    border: OutlineInputBorder(),
                  ),
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedRole = value);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // Bouton S'inscrire
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyStyles.egyptianBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("S'inscrire", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback onToggle) {
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
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez choisir un rôle")));
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Les mots de passe ne correspondent pas")));
      return;
    }

    // Simuler l’envoi
    print("Inscription :");
    print("Nom : ${nomController.text}");
    print("Prénom : ${prenomController.text}");
    print("Email : ${emailController.text}");
    print("Téléphone : ${telephoneController.text}");
    print("Rôle : $_selectedRole");
    print("Mot de passe : ${passwordController.text}");
  }
}