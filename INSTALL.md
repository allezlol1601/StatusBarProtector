# Guide d'installation - Status Bar Protector

## 📋 Prérequis nécessaires

### Sur votre ordinateur :
- Android Studio ou Android SDK Command Line Tools
- Java Development Kit (JDK) 17 ou supérieur
- ADB (Android Debug Bridge) configuré

### Sur votre Pixel 10 Pro XL :
- Android 16 installé
- LSPosed Framework installé et fonctionnel
- Accès root
- Débogage USB activé

## 🔧 Installation pas à pas

### Étape 1 : Préparer l'environnement

```bash
# Vérifier Java
java -version
# Devrait afficher Java 17 ou supérieur

# Vérifier ADB
adb version

# Vérifier la connexion avec votre appareil
adb devices
```

### Étape 2 : Compiler le module

#### Option A : Utiliser le script automatique (recommandé)

```bash
cd StatusBarProtector
./build_and_install.sh
```

Le script va :
1. Nettoyer les anciens builds
2. Compiler le module
3. Vous proposer d'installer l'APK

#### Option B : Compilation manuelle

```bash
cd StatusBarProtector

# Nettoyer
./gradlew clean

# Compiler en mode release
./gradlew assembleRelease

# L'APK sera dans : app/build/outputs/apk/release/app-release.apk
```

### Étape 3 : Installer l'APK sur votre appareil

```bash
adb install -r app/build/outputs/apk/release/app-release.apk
```

Ou glissez-déposez l'APK sur votre téléphone et installez-le manuellement.

### Étape 4 : Activer le module dans LSPosed

1. **Ouvrir LSPosed** sur votre Pixel 10 Pro XL
2. Aller dans l'onglet **"Modules"**
3. Trouver **"Status Bar Protector"** dans la liste
4. **Activer** le module (cocher la case)

### Étape 5 : Configurer la portée du module

1. Dans LSPosed, **cliquer sur "Status Bar Protector"**
2. Aller dans **"Portée de l'application"** ou **"Application scope"**
3. **Cocher les applications** que vous voulez protéger
   
   **Exemples d'applications à sélectionner :**
   - Applications de navigation GPS qui cachent la barre d'état
   - Jeux qui passent en plein écran
   - Applications de lecture vidéo
   - Toute app qui recouvre la barre d'état et vous gêne

   **⚠️ IMPORTANT - Ne PAS sélectionner :**
   - `android` (système Android)
   - `com.android.systemui` (interface système)
   - LSPosed lui-même

### Étape 6 : Appliquer les changements

Vous avez deux options :

#### Option A : Redémarrer les applications (recommandé)
```bash
# Via ADB
adb shell am force-stop com.example.app

# Ou manuellement sur le téléphone :
# Paramètres → Applications → [App] → Forcer l'arrêt
```

#### Option B : Redémarrer l'appareil
Redémarrez simplement votre Pixel 10 Pro XL.

## ✅ Vérification

### Test rapide :
1. Ouvrez une application que vous avez sélectionnée dans la portée
2. La barre d'état devrait rester visible en haut de l'écran
3. Même si l'app essaie de passer en plein écran

### Vérifier les logs (optionnel) :
```bash
# Voir les logs du module
adb logcat | grep "StatusBarProtector"

# Vous devriez voir des messages comme :
# StatusBarProtector: Hooking com.example.app
# StatusBarProtector: Removed fullscreen flags
# StatusBarProtector: Modified system UI visibility
```

## 🔍 Dépannage

### Le module n'apparaît pas dans LSPosed

**Solution :**
```bash
# Réinstaller l'APK
adb install -r app/build/outputs/apk/release/app-release.apk

# Redémarrer LSPosed
adb shell am force-stop org.lsposed.manager

# Vérifier que l'APK est bien installé
adb shell pm list packages | grep statusbar
```

### Le module est activé mais ne fonctionne pas

**Vérifications :**
1. ✅ Le module est bien coché dans l'onglet "Modules" de LSPosed
2. ✅ Les applications sont bien cochées dans "Portée de l'application"
3. ✅ Vous avez redémarré les applications ou l'appareil
4. ✅ LSPosed fonctionne correctement (testez avec un autre module)

**Solutions :**
```bash
# Forcer l'arrêt de l'application cible
adb shell am force-stop com.example.app

# Ou redémarrer l'appareil
adb reboot
```

### Erreur de compilation

**Erreur : SDK non trouvé**
```bash
# Définir ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

**Erreur : Java version incorrecte**
```bash
# Installer JDK 17
sudo apt install openjdk-17-jdk  # Linux
# ou
brew install openjdk@17          # macOS
```

### L'application crash après activation du module

**Cause :** L'application dépend fortement du mode plein écran

**Solution :**
1. Décochez cette application dans la portée du module
2. Redémarrez l'application

## 📱 Utilisation quotidienne

Une fois configuré, le module fonctionne automatiquement :

- ✅ **Pas de configuration supplémentaire**
- ✅ **Fonctionne en arrière-plan**
- ✅ **Aucun impact sur les performances**
- ✅ **Vous pouvez ajouter/retirer des apps de la portée à tout moment**

### Ajouter une nouvelle application :

1. Ouvrir LSPosed
2. Status Bar Protector → Portée de l'application
3. Cocher la nouvelle app
4. Forcer l'arrêt de l'app ou redémarrer

### Retirer une application :

1. Ouvrir LSPosed
2. Status Bar Protector → Portée de l'application
3. Décocher l'app
4. Forcer l'arrêt de l'app

## 🔄 Mise à jour du module

Si vous modifiez le code :

```bash
# Recompiler
./gradlew assembleRelease

# Réinstaller (flag -r pour remplacer)
adb install -r app/build/outputs/apk/release/app-release.apk

# Redémarrer les apps ou l'appareil
adb reboot
```

## 💡 Conseils

- **Commencez petit** : Testez d'abord avec 2-3 applications
- **Soyez sélectif** : N'activez que pour les apps qui posent vraiment problème
- **Surveillez les logs** : Utile pour déboguer les problèmes
- **Gardez une sauvegarde** : Faites un backup avant de modifier le code

## 📞 Support

Si vous rencontrez des problèmes :

1. Vérifiez que LSPosed fonctionne avec d'autres modules
2. Consultez les logs avec `adb logcat | grep "StatusBarProtector"`
3. Assurez-vous que votre version d'Android est compatible (12+)
4. Vérifiez que vous n'avez pas sélectionné de packages système

## 🎉 C'est tout !

Votre module est maintenant installé et fonctionnel. La barre d'état restera visible dans les applications sélectionnées !
