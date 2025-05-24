import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ProfilePassager extends StatefulWidget {
  const ProfilePassager({Key? key}) : super(key: key);

  static String path = "/profilePassager";

  @override
  State<ProfilePassager> createState() => _ProfilePassagerState();
}

class _ProfilePassagerState extends State<ProfilePassager> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  File? _imageFile;
  bool get isSimulator => !kIsWeb && Platform.isIOS && Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
  
  // Contrôleurs pour les champs de texte
  final TextEditingController _nomController = TextEditingController(text: "Passager");
  final TextEditingController _prenomController = TextEditingController(text: "1");
  final TextEditingController _emailController = TextEditingController(text: "passager@example.com");
  final TextEditingController _telephoneController = TextEditingController(text: "+224 XX XX XX XX");

  Future<void> _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    
    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    // Afficher une boîte de dialogue pour choisir entre la caméra et la galerie
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir une photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Color(0xFF213FAA)),
                        SizedBox(width: 10),
                        Text('Galerie'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _imageFile = File(image.path);
                      });
                    }
                  },
                ),
                if (!isSimulator) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt, color: Color(0xFF213FAA)),
                          SizedBox(width: 10),
                          Text('Caméra'),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _takePicture();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mon Profil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isEditing && _formKey.currentState!.validate()) {
                // Sauvegarder les modifications
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Modifications enregistrées')),
                );
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Photo de profil
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onLongPress: _imageFile != null && _isEditing
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Photo de profil'),
                                      content: const Text('Voulez-vous supprimer cette photo ?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Annuler'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        TextButton(
                                          child: const Text('Supprimer', 
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _imageFile = null;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF213FAA),
                          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                          child: _imageFile == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF213FAA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Champs d'information
                _buildTextField(
                  controller: _nomController,
                  label: 'Nom',
                  enabled: _isEditing,
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _prenomController,
                  label: 'Prénom',
                  enabled: _isEditing,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  enabled: _isEditing,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _telephoneController,
                  label: 'Téléphone',
                  enabled: _isEditing,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),
                if (!_isEditing) ...[
                  // Bouton de déconnexion
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logique de déconnexion
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF213FAA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Se déconnecter',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF213FAA)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF213FAA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF213FAA), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        if (label == 'Email' && !value.contains('@')) {
          return 'Veuillez entrer un email valide';
        }
        return null;
      },
    );
  }
}
