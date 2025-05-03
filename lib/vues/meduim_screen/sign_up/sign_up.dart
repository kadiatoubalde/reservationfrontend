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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
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
                title: "Nom",
                customtextfield: CustomTextFormField(
                  keyboardType: TextInputType.name,
                  hintText: "Ex: Kadiatou",
                  validator: (String? value) =>
                      Validations.emptyValidation(value),
                ),
              ),
              CustomTextField(
                title: "Nom",
                customtextfield: CustomTextFormField(
                  keyboardType: TextInputType.name,
                  hintText: "Ex: baldé",
                  validator: (String? value) =>
                      Validations.emptyValidation(value),
                ),
              ),
              CustomTextField(
                title: "Email",
                customtextfield: CustomTextFormField(
                  keyboardType: TextInputType.name,
                  hintText: "Ex: quelqun@gmail.com",
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
                      "S'inscrire",
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
