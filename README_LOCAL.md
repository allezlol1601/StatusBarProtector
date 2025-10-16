# Status Bar Protector - Module LSPosed

Module LSPosed pour empêcher les applications de recouvrir la barre d'état système sur Android.

## 📋 Prérequis

- Android 12 ou supérieur (testé sur Android 16)
- LSPosed Framework installé et fonctionnel
- Accès root

## 🔧 Installation

1. **Compiler le module** :
   ```bash
   ./gradlew assembleRelease
   ```
   L'APK sera généré dans `app/build/outputs/apk/release/`

2. **Installer l'APK** sur votre appareil :
   ```bash
   adb install app/build/outputs/apk/release/app-release.apk
   ```

3. **Activer le module dans LSPosed** :
   - Ouvrez l'application LSPosed
   - Allez dans l'onglet "Modules"
   - Activez "Status Bar Protector"

4. **Sélectionner les applications** :
   - Cliquez sur "Status Bar Protector" dans LSPosed
   - Allez dans "Portée de l'application"
   - Cochez les applications que vous souhaitez protéger
   - **Important** : Ne pas inclure `android` ou `com.android.systemui`

5. **Redémarrer les applications** :
   - Forcez l'arrêt des applications sélectionnées
   - Ou redémarrez votre appareil pour appliquer les changements

## 🎯 Fonctionnalités

Le module intercepte et bloque les tentatives des applications de :

- ✅ Activer le mode plein écran (`FLAG_FULLSCREEN`)
- ✅ Masquer la barre d'état via `setSystemUiVisibility()`
- ✅ Utiliser les modes immersifs (`IMMERSIVE`, `IMMERSIVE_STICKY`)
- ✅ Cacher la barre d'état via `WindowInsetsController.hide()`
- ✅ Modifier le comportement des barres système

## 📱 Utilisation

Une fois le module activé et les applications sélectionnées :

1. Les applications ne pourront plus recouvrir ou masquer la barre d'état
2. La barre d'état restera toujours visible en haut de l'écran
3. Aucune configuration supplémentaire n'est nécessaire

## 🐛 Dépannage

### Le module ne fonctionne pas
- Vérifiez que LSPosed est bien actif dans les paramètres
- Assurez-vous que le module est activé dans LSPosed
- Vérifiez que les applications sont bien cochées dans la portée
- Redémarrez les applications ou l'appareil

### Crash d'une application
- Certaines applications peuvent ne pas fonctionner correctement si elles dépendent du mode plein écran
- Décochez l'application problématique dans la portée du module

### Vérifier les logs
```bash
adb logcat | grep "StatusBarProtector"
```

## 🔍 Comment ça marche

Le module utilise l'API Xposed pour intercepter les appels système qui contrôlent la visibilité de la barre d'état :

1. **Hook des WindowManager.LayoutParams** : Retire les flags fullscreen lors de la création des fenêtres
2. **Hook de Window.setFlags()** : Empêche l'ajout de flags fullscreen
3. **Hook de View.setSystemUiVisibility()** : Retire les flags qui cachent la barre d'état
4. **Hook de WindowInsetsController** : Bloque les tentatives de masquer la barre d'état (Android 11+)

## 📝 Notes

- Compatible Android 12+ (API 31+)
- Testé sur Android 16 (Pixel 10 Pro XL)
- Ne pas utiliser sur les applications système (`android`, `com.android.systemui`)
- Le module n'affecte que les applications sélectionnées dans la portée

## 🛠️ Structure du projet

```
StatusBarProtector/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/statusbar/protector/
│   │       │   └── MainHook.java          # Code principal du hook
│   │       ├── res/
│   │       │   └── values/
│   │       │       ├── arrays.xml         # Configuration du scope
│   │       │       └── strings.xml        # Ressources textuelles
│   │       ├── assets/
│   │       │   └── xposed_init           # Point d'entrée Xposed
│   │       └── AndroidManifest.xml        # Manifest avec métadonnées Xposed
│   └── build.gradle                       # Configuration Gradle du module
├── build.gradle                           # Configuration Gradle racine
└── settings.gradle                        # Paramètres du projet
```

## ⚖️ Licence

Ce module est fourni tel quel, sans garantie. Utilisez-le à vos propres risques.

## 🤝 Contribution

N'hésitez pas à signaler des bugs ou proposer des améliorations !
