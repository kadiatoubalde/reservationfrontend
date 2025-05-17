import 'package:custom_text_form_field_plus/custom_text_form_field_plus.dart';
import 'package:flutter/material.dart';

import '../../../utils/global_functions/my_styles.dart';
import '../../../utils/global_widgets/custom_text_field.dart';

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
            size: MediaQuery.of(context).size.width * 0.07,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/easytravel_logo.png',  
                height: MediaQuery.of(context).size.height * 0.22,  // Ajuste la taille selon ton besoin
                width: MediaQuery.of(context).size.width * 0.6,  // Ajuste la taille du logo
                fit: BoxFit.contain,  // Ajuste la façon dont l'image est redimensionnée
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
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
             TextFormField(
  keyboardType: TextInputType.visiblePassword,
  obscureText: obscurePassword,
  validator: (String? value) => Validations.emptyValidation(value),
  decoration: InputDecoration(
    labelText: 'Mot de passe',
     labelStyle: TextStyle(
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
              SizedBox(
                height: 10,
              ),
              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      "Mot de passe oublié ? ",
      style: TextStyle(
        color: MyStyles.raisinBlack,
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.035,
      ),
    ),
     SizedBox(width:8),
    GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/resetPassword");
      },
      child: Text(
        "Réinitialiser",
        style: TextStyle(
          color: MyStyles.egyptianBlue,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width * 0.035,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  ],
),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  print("click on sign in ");
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.5,
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
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}