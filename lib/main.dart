import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'vues/meduim_screen/home/home.dart';
import 'vues/meduim_screen/login/login.dart';
import 'vues/meduim_screen/sign_up/sign_up.dart';
import 'vues/meduim_screen/splash/splash.dart';
import 'vues/meduim_screen/reset_password/reset_password.dart';
import 'vues/meduim_screen/accueil_passager/accueil_passager.dart';
import 'vues/meduim_screen/liste_voyages/liste_voyages_disponibles.dart';
import 'vues/meduim_screen/confirmation_reservation/confirmation_reservation.dart';
import 'vues/meduim_screen/reservations/reservations.dart';
import 'vues/meduim_screen/profile_passager/profile_passager.dart';
import 'services/notification_service.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation du service de notification
  final notificationService = NotificationService();
  await notificationService.initNotification();
  
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EasyTravel',
      home: const AccueilPassager(),
       localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
    
      routes: {
        Login.path: (context) => const Login(),
        Splash.path: (context) => const Splash(),
        SignUp.path: (context) => const SignUp(),
        Home.path: (context) => const Home(),
        ResetPassword.path: (context) => const ResetPassword(),
        AccueilPassager.path : (context) => const AccueilPassager(),
        ListeVoyagesDisponibles.path: (context) => const ListeVoyagesDisponibles(),
        ConfirmationReservation.path: (context) => const ConfirmationReservation(),
        ReservationsPage.path: (context) => const ReservationsPage(),
        ProfilePassager.path: (context) => const ProfilePassager(),
        
      },
    );
  }
}
