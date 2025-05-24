import 'package:flutter/material.dart';
import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';
import '../accueil_passager/accueil_passager.dart';
import '../reset_password/reset_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static String path = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obscurePassword = true;

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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: MyStyles.raisinBlack,
            size: screenWidth * 0.07,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              /// === LOGO ===
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: screenHeight * 0.22,
                  width: screenWidth * 0.6,
                  child: Image.asset(
                    'assets/images/easytravel_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              /// === Email ===
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              /// === Mot de passe ===
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscurePassword,
                
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// === Lien mot de passe oublié ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Mot de passe oublié ??",
                    style: TextStyle(
                      color: MyStyles.raisinBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ResetPassword.path);
                    },
                    child: Text(
                      "Réinitialiser le",
                      style: TextStyle(
                        color: MyStyles.egyptianBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// === Bouton Connexion ===
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AccueilPassager.path);
                },
                child: Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    color: MyStyles.egyptianBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "Se connecter",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
