# 🍃 Veg'N Bio Mobile App (Client / Fournisseur)

Application mobile Flutter pour les **clients** et **fournisseurs** de la plateforme Veg'N Bio.
Elle permet la réservation, la gestion des repas, la participation aux événements, et la communication entre les acteurs.

---

## 🚀 Fonctionnalités principales

### 👤 Côté Client
- Création et connexion au compte.
- Consultation des restaurants partenaires.
- Recherche et filtrage de repas (vegan, bio, sans gluten...).
- Réservation de table ou participation à un événement.
- Consultation et gestion des commandes.
- Modification du profil et du mot de passe.
- Déconnexion sécurisée.

### 🏪 Côté Fournisseur (Restaurateur)
- Authentification avec BasicAuth.
- Gestion du catalogue de repas (CRUD).
- Consultation des réservations et participants aux événements.
- Gestion des événements locaux (ajout, édition, suppression).
- Statistiques sur les ventes et participations.
- Modification du mot de passe et déconnexion.

---

## 🧱 Architecture Flutter
- **State Management** : Provider
- **Networking** : `http`
- **Storage sécurisé** : `flutter_secure_storage`
- **Logging** : `logger`
- **UI** : Material Design + Grille de cards responsive
- **Routing dynamique** selon le rôle utilisateur (client / fournisseur)

---

## 📦 Installation

```bash
flutter pub get
flutter run
