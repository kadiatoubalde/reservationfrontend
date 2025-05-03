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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Easy Travel",
                  style: TextStyle(
                    color: MyStyles.raisinBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              CustomTextField(
                title: "Email",
                customtextfield: CustomTextFormField(
                  keyboardType: TextInputType.name,
                  validator: (String? value) =>
                      Validations.emptyValidation(value),
                ),
              ),
              CustomTextField(
                title: "password",
                customtextfield: CustomTextFormField(
                  keyboardType: TextInputType.name,
                  validator: (String? value) =>
                      Validations.emptyValidation(value),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Mot de pass oublier ?? ",
                    style: TextStyle(
                      color: MyStyles.raisinBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                  Text(
                    "Réinitialiser le",
                    style: TextStyle(
                      color: MyStyles.egyptianBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
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
