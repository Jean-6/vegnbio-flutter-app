import 'package:flutter/material.dart';
import '../../../core/services/credential_storage_helper.dart';

class MyScreen extends StatelessWidget {
  final String userName;
  final String email;

  const MyScreen({
    super.key,
    required this.userName,
    required this.email,
  });

  Future<void> _logout(BuildContext context) async {
    final creds = CredentialStorageHelper();
    await creds.clearCredentials();
    Navigator.pushReplacementNamed(context, "/login");
  }

  void _changePassword(BuildContext context) {
    Navigator.pushNamed(context, "/change-password");
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    String? subtitle,
    bool trailingChevron = true,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.deepOrange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    if (subtitle != null)
                      const SizedBox(height: 4),
                    if (subtitle != null)
                      Text(subtitle,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              if (trailingChevron)
                Icon(Icons.chevron_right, color: Colors.grey.shade400)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const avatar =
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&q=80';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pushReplacementNamed(context, '/main-dashboard')),
        actions: [
          IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              // 🧑🏻‍💼 Carte profil utilisateur
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFFF7EF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person, // Icône générique
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    /*CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: const NetworkImage(avatar),
                    ),*/
                    const SizedBox(width: 14),
                    // Nom + Email dynamiques
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty ? userName : "Utilisateur",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email.isNotEmpty ? email : "Email non disponible",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⚙️ Menu utilisateur
              Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'Mes produits',
                    subtitle: 'Voir et gérer vos produits',
                    onTap: () {
                      // Naviguer vers l’écran MesProduits
                      Navigator.pushNamed(context, '/my-products');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Modifier mot de passe',
                    subtitle: 'Préférences et sécurité du compte',
                    onTap: () => _changePassword(context),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuTile(
                    icon: Icons.person_add,
                    title: 'Devenir fournisseur',
                    subtitle:
                    'Remplissez le formulaire et soumettez vos documents',
                    onTap: () {
                      Navigator.pushNamed(context, '/become-supplier');
                    },
                  ),
                  const SizedBox(height: 12),

                  // 🚪 Déconnexion
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    elevation: 2,
                    shadowColor: Colors.black12,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _logout(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 14),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.logout,
                                  color: Colors.red.shade400),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Déconnexion',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade600,
                                      fontSize: 15)),
                            ),
                            Icon(Icons.chevron_right,
                                color: Colors.grey.shade400)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Text(
                'App version 1.0.0',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
