import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Instance singleton du service
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Instance du plugin de notification
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialisation du service de notification
  Future<void> initNotification() async {
    // Configuration Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configuration générale
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      // Callback quand l'utilisateur clique sur la notification
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // TODO: Gérer le clic sur la notification
        print('Notification cliquée: ${response.payload}');
      },
    );
  }

  // Envoyer une notification de confirmation de réservation
  Future<void> envoyerNotificationConfirmation({
    required String numeroReservation,
    required String villeDepart,
    required String villeArrivee,
    required String dateVoyage,
    required String heureDepart,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'confirmation_reservations', // ID unique du canal
      'Confirmations de réservation', // Nom du canal
      channelDescription: 'Notifications pour les confirmations de réservation',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    // Construction du message détaillé
    final String message = '''
Votre réservation n°$numeroReservation a été confirmée !

Détails du voyage :
De : $villeDepart
À : $villeArrivee
Date : $dateVoyage
Heure de départ : $heureDepart

Bon voyage avec EasyTravel !
''';

    await _notificationsPlugin.show(
      DateTime.now().millisecond, // ID unique basé sur le temps
      'Réservation confirmée !',
      message,
      notificationDetails,
      payload: numeroReservation, // Pour pouvoir identifier la réservation lors du clic
    );
  }
} 