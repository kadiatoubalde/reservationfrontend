import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'vues/auth/login_view.dart';
import 'vues/auth/register_view.dart';
import 'vues/profil_view.dart';

// Import placeholder views for Passager
import 'vues/passager/recherche_trajets_view.dart';
import 'vues/passager/reserver_billet_view.dart';
import 'vues/passager/liste_reservations_view.dart';
import 'vues/passager/liste_trajets_view.dart';

// Import placeholder views for Chauffeur
import 'vues/chauffeur/liste_trajets_affectes_view.dart';
import 'vues/chauffeur/gestion_reservations_recues_view.dart';
import 'vues/chauffeur/validation_checkin_view.dart';

// Import placeholder views for Administrateur
import 'vues/administrateur/gestion_utilisateurs_view.dart';
import 'vues/administrateur/creation_trajets_view.dart';
import 'vues/administrateur/attribution_trajets_chauffeurs_view.dart';
import 'vues/administrateur/tableau_bord_view.dart';
import 'vues/administrateur/gestion_villes_view.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';

  // Passager Routes
  static const String passagerRechercheTrajets = '/passager/recherche_trajets';
  static const String passagerReserverBillet = '/passager/reserver_billet';
  static const String passagerListeReservations = '/passager/liste_reservations';
  static const String passagerListeTrajets = '/passager/liste_trajets';
  static const String profil = '/profil';

  // Chauffeur Routes
  static const String chauffeurListeTrajetsAffectes = '/chauffeur/liste_trajets_affectes';
  static const String chauffeurGestionReservationsRecues = '/chauffeur/gestion_reservations_recues';
  static const String chauffeurValidationCheckin = '/chauffeur/validation_checkin';

  // Administrateur Routes
  static const String adminGestionUtilisateurs = '/admin/gestion_utilisateurs';
  static const String adminCreationTrajets = '/admin/creation_trajets';
  static const String adminAttributionTrajetsChauffeurs = '/admin/attribution_trajets_chauffeurs';
  static const String adminTableauBord = '/admin/tableau_bord';
  static const String adminGestionVilles = '/admin/gestion_villes';

  static Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Routes publiques qui ne nécessitent pas d'authentification
    if (settings.name == login || settings.name == register) {
      return MaterialPageRoute(
        builder: (_) => settings.name == login ? const LoginView() : const RegisterView(),
      );
    }

    // Vérification de l'authentification pour les autres routes
    if (!authService.isAuthenticated) {
      return MaterialPageRoute(
        builder: (_) => const LoginView(),
      );
    }

    // Vérification des permissions pour la route demandée
    if (!authService.hasAccessToRoute(settings.name!)) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('Accès non autorisé pour votre rôle'),
          ),
        ),
      );
    }

    // Routes autorisées selon le rôle
    switch (settings.name) {
      // Passager Routes
      case passagerRechercheTrajets:
        return MaterialPageRoute(
          builder: (_) => const RechercheTrajetsView(),
        );
      case passagerReserverBillet:
        return MaterialPageRoute(
          builder: (_) => const ReserverBilletView(),
        );
      case passagerListeReservations:
        return MaterialPageRoute(
          builder: (_) => const ListeReservationsView(),
        );
      case passagerListeTrajets:
        return MaterialPageRoute(
          builder: (_) => const ListeTrajetsView(),
        );

      // Profil Route
      case profil:
        return MaterialPageRoute(
          builder: (_) => const ProfilView(),
        );

      // Chauffeur Routes
      case chauffeurListeTrajetsAffectes:
        return MaterialPageRoute(
          builder: (_) => const ListeTrajetsAffectesView(),
        );
      case chauffeurGestionReservationsRecues:
        return MaterialPageRoute(
          builder: (_) => const GestionReservationsRecuesView(),
        );
      case chauffeurValidationCheckin:
        return MaterialPageRoute(
          builder: (_) => const ValidationCheckinView(),
        );

      // Administrateur Routes
      case adminGestionUtilisateurs:
        return MaterialPageRoute(
          builder: (_) => const GestionUtilisateursView(),
        );
      case adminCreationTrajets:
        return MaterialPageRoute(
          builder: (_) => const CreationTrajetsView(),
        );
      case adminAttributionTrajetsChauffeurs:
        return MaterialPageRoute(
          builder: (_) => const AttributionTrajetsChauffeursView(),
        );
      case adminTableauBord:
        return MaterialPageRoute(
          builder: (_) => const TableauBordView(),
        );
      case adminGestionVilles:
        return MaterialPageRoute(
          builder: (_) => const GestionVillesView(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }
} 