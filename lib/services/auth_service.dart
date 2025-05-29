import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/authDto.dart';
import '../models/utilisateurDto.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  static const String _userKey = 'current_user';
  static const String _endpoint = '/auth';

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? get userRole => _currentUser?.role;

  Future<void> login(AuthDto authDto) async {
    final response = await ApiService.post('$_endpoint/login', authDto.toJson());
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final utilisateurDto = UtilisateurDto.fromJson(userData);

      if (utilisateurDto.email == null || utilisateurDto.role == null) {
         throw Exception('Données utilisateur essentielles manquantes dans la réponse API');
      }

      _currentUser = User(
        uuid: utilisateurDto.uuid,
        firstname: utilisateurDto.firstname,
        lastname: utilisateurDto.lastname,
        email: utilisateurDto.email,
        telephone: utilisateurDto.telephone,
        role: utilisateurDto.role,
        token: utilisateurDto.token,
      ); 

      // Debugging: Print user details after creating the User object
      print('DEBUG: User created after login:');
      print('  UUID: ${_currentUser?.uuid}');
      print('  Firstname: ${_currentUser?.firstname}');
      print('  Lastname: ${_currentUser?.lastname}');
      print('  Email: ${_currentUser?.email}');
      print('  Telephone: ${_currentUser?.telephone}');
      print('  Role: ${_currentUser?.role}');
      print('  Token: ${_currentUser?.token != null ? '[Present]' : '[Null]'}');

      await _saveUserToPrefs();
      notifyListeners();
    } else {
      throw Exception('Échec de la connexion');
    }
  }

  Future<void> register(UtilisateurDto utilisateurDto) async {
    final response = await ApiService.post('$_endpoint/register', utilisateurDto.toJson());
    if (response.statusCode == 201) {
      final userData = json.decode(response.body);
      final registeredUserDto = UtilisateurDto.fromJson(userData);
       // Depending on what the API returns on registration, you might want to:
       // 1. Automatically log the user in: create User from registeredUserDto, save, notify, set _currentUser
       // 2. Just confirm registration and require separate login: remove the User creation and saving logic here
       // Assuming for now we redirect to login, so no User object creation needed here.
    } else {
      throw Exception('Échec de l\'inscription');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _removeUserFromPrefs();
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  Future<void> _removeUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      _currentUser = User.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  String getInitialRoute() {
    // Safely access role, default to null if _currentUser is null
    final userRole = _currentUser?.role;
    
    // Debugging: Print the role being used for initial route determination
    print('DEBUG: Role for initial route: $userRole');

    if (!isAuthenticated || userRole == null) {
      return '/login';
    }
    
    switch (userRole) {
      case 'ADMINISTRATEUR':
        return '/admin/tableau_bord';
      case 'CHAUFFEUR':
        return '/chauffeur/liste_trajets_affectes';
      case 'PASSAGER':
        return '/passager/recherche_trajets';
      default:
        return '/login';
    }
  }

  bool hasAccessToRoute(String route) {
     // Safely access role, default to null if _currentUser is null
    final userRole = _currentUser?.role;

    if (!isAuthenticated || userRole == null) {
      return false;
    }
    
    switch (userRole) {
      case 'ADMINISTRATEUR':
        return route.startsWith('/admin/') || 
               route == '/login' || 
               route == '/register';
      case 'CHAUFFEUR': 
        return route.startsWith('/chauffeur/') || 
               route == '/login' || 
               route == '/register';
      case 'PASSAGER':
        return route.startsWith('/passager/') || 
               route == '/login' || 
               route == '/register';
      default:
        return false;
    }
  }
} 