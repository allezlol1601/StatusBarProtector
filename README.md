# Status Bar Protector

[![Build APK](https://github.com//StatusBarProtector/actions/workflows/build.yml/badge.svg)](https://github.com//StatusBarProtector/actions/workflows/build.yml)
[![Release](https://github.com//StatusBarProtector/actions/workflows/release.yml/badge.svg)](https://github.com//StatusBarProtector/actions/workflows/release.yml)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Android](https://img.shields.io/badge/Android-12%2B-green.svg)](https://developer.android.com)
[![API](https://img.shields.io/badge/API-31%2B-brightgreen.svg)](https://android-arsenal.com/api?level=31)

Module LSPosed pour empêcher les applications de recouvrir la barre d'état système sur Android.

## 📱 Compatibilité

- **Android** : 12+ (API 31+)
- **Testé sur** : Android 16 (Pixel 10 Pro XL)
- **Framework requis** : LSPosed
- **Root** : Oui

## ✨ Fonctionnalités

- ✅ Bloque le mode plein écran (`FLAG_FULLSCREEN`)
- ✅ Empêche les modes immersifs (`IMMERSIVE`, `IMMERSIVE_STICKY`)
- ✅ Désactive `WindowInsetsController.hide()` pour la barre d'état
- ✅ Sélection des applications via l'interface LSPosed
- ✅ Aucun impact sur les performances
- ✅ Léger et efficace

## 📥 Installation

### Option 1 : Télécharger l'APK pré-compilé

1. Allez dans [Releases](https://github.com//StatusBarProtector/releases)
2. Téléchargez la dernière version `StatusBarProtector-vX.X.X.apk`
3. Installez l'APK sur votre appareil
4. Activez le module dans LSPosed
5. Sélectionnez les applications dans "Portée de l'application"

### Option 2 : Compiler depuis les sources

```bash
# Cloner le repository
git clone https://github.com//StatusBarProtector.git
cd StatusBarProtector

# Compiler
./gradlew assembleRelease

# Installer
adb install app/build/outputs/apk/release/app-release.apk
```

## 🚀 Utilisation

### 1. Activer le module

1. Ouvrir **LSPosed Manager**
2. Onglet **"Modules"**
3. Activer **"Status Bar Protector"** ☑️

### 2. Configurer la portée

1. Cliquer sur **"Status Bar Protector"**
2. **"Portée de l'application"** ou **"Application scope"**
3. Cocher les applications à protéger

**⚠️ Important** : Ne pas sélectionner `android` ou `com.android.systemui`

### 3. Appliquer

- Forcer l'arrêt des applications sélectionnées
- **OU** redémarrer l'appareil

## 📱 Applications recommandées

Applications qui cachent souvent la barre d'état :

- **Navigation GPS** : Google Maps, Waze
- **Jeux** : La plupart des jeux mobiles
- **Vidéo** : YouTube, Netflix, VLC
- **Réseaux sociaux** : Instagram, Snapchat, TikTok

Voir [PROBLEMATIC_APPS.md](PROBLEMATIC_APPS.md) pour la liste complète.

## 🔧 Configuration GitHub Actions

Le projet utilise GitHub Actions pour compiler automatiquement l'APK.

### Workflows disponibles

| Workflow | Déclenchement | Description |
|----------|---------------|-------------|
| `build.yml` | Push/PR sur main | Compile l'APK et le met en artefact |
| `release.yml` | Tag `v*.*.*` | Crée une release GitHub avec l'APK |

### Créer une release

```bash
# Créer un tag
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions va automatiquement :
# 1. Compiler l'APK
# 2. Créer une release
# 3. Attacher l'APK à la release
```

### Télécharger l'APK compilé

Après chaque commit sur `main` :

1. Allez dans l'onglet **"Actions"**
2. Cliquez sur le dernier workflow
3. Téléchargez l'artefact **"StatusBarProtector-APK"**

## 🛠️ Développement

### Prérequis

- JDK 17+
- Android SDK
- Gradle 8.5+

### Structure du projet

```
StatusBarProtector/
├── .github/workflows/       # GitHub Actions
│   ├── build.yml           # Build automatique
│   └── release.yml         # Release automatique
├── app/
│   ├── src/main/
│   │   ├── java/.../MainHook.java    # Code principal
│   │   ├── AndroidManifest.xml       # Config Xposed
│   │   └── assets/xposed_init        # Point d'entrée
│   └── build.gradle
└── build.gradle
```

### Commandes utiles

```bash
# Build debug
./gradlew assembleDebug

# Build release
./gradlew assembleRelease

# Clean
./gradlew clean

# Lister les tâches
./gradlew tasks
```

## 🐛 Dépannage

### Le module n'apparaît pas dans LSPosed

```bash
adb install -r app/build/outputs/apk/release/app-release.apk
adb reboot
```

### Les hooks ne fonctionnent pas

- Vérifiez que le module est activé dans LSPosed
- Vérifiez que les apps sont cochées dans la portée
- Redémarrez les applications

### Vérifier les logs

```bash
adb logcat | grep "StatusBarProtector"
```

## 📚 Documentation

- [INSTALL.md](INSTALL.md) - Guide d'installation détaillé
- [CUSTOMIZATION.md](CUSTOMIZATION.md) - Personnalisation et extensions
- [CHEATSHEET.md](CHEATSHEET.md) - Référence rapide
- [PROBLEMATIC_APPS.md](PROBLEMATIC_APPS.md) - Liste d'applications

## 🤝 Contribution

Les contributions sont les bienvenues !

1. Fork le projet
2. Créez votre branche (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📝 Changelog

### v1.0.0 (2025-10-16)
- 🎉 Release initiale
- ✅ Bloque mode plein écran
- ✅ Empêche modes immersifs
- ✅ Support Android 16
- ✅ Configuration via LSPosed

## ⚖️ Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- [LSPosed Framework](https://github.com/LSPosed/LSPosed)
- [Xposed API](https://api.xposed.info/)

## 📧 Contact

- Issues : [GitHub Issues](https://github.com//StatusBarProtector/issues)
- Discussions : [GitHub Discussions](https://github.com//StatusBarProtector/discussions)

---

**Note** : Ce module est fourni tel quel, sans garantie. Utilisez-le à vos propres risques.

Made with ❤️ for Android 16 (Pixel 10 Pro XL)
