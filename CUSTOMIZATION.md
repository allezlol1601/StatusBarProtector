# Guide de personnalisation - Status Bar Protector

Ce guide explique comment personnaliser et étendre le module selon vos besoins.

## 🎨 Personnalisation de base

### Changer le nom du module

**Fichier : `app/src/main/res/values/strings.xml`**
```xml
<string name="app_name">Mon Protecteur de Barre</string>
<string name="xposed_description">Ma description personnalisée</string>
```

### Changer l'icône de l'application

1. Créez votre icône (format PNG recommandé)
2. Générez les différentes tailles :
   - `mipmap-mdpi` : 48x48 px
   - `mipmap-hdpi` : 72x72 px
   - `mipmap-xhdpi` : 96x96 px
   - `mipmap-xxhdpi` : 144x144 px
   - `mipmap-xxxhdpi` : 192x192 px

3. Placez les fichiers dans :
   ```
   app/src/main/res/mipmap-[densité]/ic_launcher.png
   ```

### Modifier le package

Si vous voulez changer `com.statusbar.protector` :

1. **Dans `MainHook.java`** :
   ```java
   package com.votre.package;
   ```

2. **Dans `AndroidManifest.xml`** :
   ```xml
   package="com.votre.package"
   ```

3. **Dans `app/build.gradle`** :
   ```gradle
   namespace 'com.votre.package'
   applicationId "com.votre.package"
   ```

4. **Renommer le dossier** :
   ```bash
   mv app/src/main/java/com/statusbar/protector \
      app/src/main/java/com/votre/package
   ```

## 🔧 Fonctionnalités avancées

### 1. Ajouter une liste blanche/liste noire

**Créer un fichier de configuration :**

```java
// Dans MainHook.java
private static final Set<String> WHITELIST = new HashSet<>(Arrays.asList(
    "com.exemple.app1",
    "com.exemple.app2"
));

@Override
public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
    // Ignorer les apps pas dans la whitelist
    if (!WHITELIST.contains(lpparam.packageName)) {
        return;
    }
    
    // Reste du code...
}
```

### 2. Mode de protection sélectif

Permettre de choisir quel type de protection appliquer :

```java
// Constantes de configuration
private static final boolean BLOCK_FULLSCREEN = true;
private static final boolean BLOCK_IMMERSIVE = true;
private static final boolean BLOCK_HIDE_NAVIGATION = false;

private void hookSystemUiVisibility(XC_LoadPackage.LoadPackageParam lpparam) {
    XposedHelpers.findAndHookMethod(
        View.class,
        "setSystemUiVisibility",
        int.class,
        new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam param) {
                int visibility = (int) param.args[0];

                if (BLOCK_FULLSCREEN) {
                    visibility &= ~View.SYSTEM_UI_FLAG_FULLSCREEN;
                }
                
                if (BLOCK_IMMERSIVE) {
                    visibility &= ~View.SYSTEM_UI_FLAG_IMMERSIVE;
                    visibility &= ~View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
                }
                
                if (BLOCK_HIDE_NAVIGATION) {
                    visibility &= ~View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;
                }
                
                param.args[0] = visibility;
            }
        }
    );
}
```

### 3. Ajouter des logs détaillés

Pour déboguer ou monitorer le comportement :

```java
private static final boolean ENABLE_DETAILED_LOGS = true;

private void logDetailed(String message) {
    if (ENABLE_DETAILED_LOGS) {
        XposedBridge.log(TAG + ": " + message);
    }
}

// Utilisation
@Override
protected void beforeHookedMethod(MethodHookParam param) {
    logDetailed("App: " + lpparam.packageName + 
                " tried to set flags: " + param.args[0]);
    // ...
}
```

### 4. Créer une interface utilisateur

Ajouter une Activity pour configurer le module depuis l'app :

**Créer `SettingsActivity.java` :**

```java
package com.statusbar.protector;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Switch;

public class SettingsActivity extends Activity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        
        Switch switchFullscreen = findViewById(R.id.switch_fullscreen);
        Switch switchImmersive = findViewById(R.id.switch_immersive);
        
        // Charger les préférences
        // Sauvegarder les changements
    }
}
```

**Ajouter dans `AndroidManifest.xml` :**

```xml
<activity
    android:name=".SettingsActivity"
    android:label="@string/settings"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>
```

### 5. Système de préférences partagées

Permettre à l'utilisateur de configurer le module :

```java
private SharedPreferences getModulePreferences() {
    return new XSharedPreferences("com.statusbar.protector", "settings");
}

@Override
public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
    XSharedPreferences prefs = getModulePreferences();
    boolean enabled = prefs.getBoolean("module_enabled", true);
    
    if (!enabled) {
        return;
    }
    
    // Reste du code...
}
```

## 🎯 Exemples de modifications utiles

### Permettre le plein écran pour les vidéos

Détecter quand une vue vidéo est en plein écran :

```java
private boolean isVideoView(Object view) {
    return view instanceof android.widget.VideoView ||
           view.getClass().getName().contains("VideoView") ||
           view.getClass().getName().contains("Player");
}

@Override
protected void beforeHookedMethod(MethodHookParam param) {
    if (isVideoView(param.thisObject)) {
        // Ne pas bloquer pour les vues vidéo
        return;
    }
    
    // Reste du code de blocage...
}
```

### Mode "Intelligent"

Permettre le plein écran en paysage, bloquer en portrait :

```java
private boolean isLandscape(Context context) {
    return context.getResources().getConfiguration().orientation 
           == Configuration.ORIENTATION_LANDSCAPE;
}

@Override
protected void beforeHookedMethod(MethodHookParam param) {
    Context context = (Context) XposedHelpers.callMethod(
        param.thisObject, "getContext");
    
    if (isLandscape(context)) {
        // Permettre le plein écran en paysage
        return;
    }
    
    // Bloquer en portrait
    // ...
}
```

### Notifications de blocage

Afficher une notification quand une tentative est bloquée :

```java
private void showNotification(Context context, String appName) {
    NotificationCompat.Builder builder = 
        new NotificationCompat.Builder(context, "statusbar_protector")
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle("Status Bar Protector")
            .setContentText(appName + " a essayé de cacher la barre d'état")
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setAutoCancel(true);
    
    NotificationManagerCompat notificationManager = 
        NotificationManagerCompat.from(context);
    notificationManager.notify(1, builder.build());
}
```

## 🧪 Tests et débogage

### Activer les logs verbeux

```java
private static final boolean DEBUG = true;

private void debug(String message) {
    if (DEBUG) {
        XposedBridge.log(TAG + " [DEBUG]: " + message);
    }
}
```

### Tester sur une app spécifique

```java
@Override
public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
    // Tester uniquement sur une app
    if (!lpparam.packageName.equals("com.exemple.testapp")) {
        return;
    }
    
    // Code de test...
}
```

### Dumper les flags

```java
private String flagsToString(int flags) {
    StringBuilder sb = new StringBuilder();
    if ((flags & WindowManager.LayoutParams.FLAG_FULLSCREEN) != 0)
        sb.append("FULLSCREEN ");
    if ((flags & WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS) != 0)
        sb.append("NO_LIMITS ");
    // etc...
    return sb.toString();
}

XposedBridge.log(TAG + ": Flags detected: " + flagsToString(flags));
```

## 📚 Ressources utiles

### Documentation Xposed/LSPosed
- API Xposed : https://api.xposed.info/
- LSPosed GitHub : https://github.com/LSPosed/LSPosed
- XDA Developers : https://forum.xda-developers.com/

### Classes Android à hooker
- `android.view.Window`
- `android.view.WindowManager.LayoutParams`
- `android.view.View`
- `android.view.WindowInsetsController`
- `android.app.Activity`

### Outils de développement
```bash
# Voir la hiérarchie des vues
adb shell dumpsys activity top

# Voir les propriétés d'une fenêtre
adb shell dumpsys window windows

# Logs filtrés
adb logcat -s StatusBarProtector:V
```

## ⚡ Optimisations

### Cache des hooks

```java
private static final Map<String, Boolean> hookCache = new HashMap<>();

@Override
public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
    if (hookCache.containsKey(lpparam.packageName)) {
        return; // Déjà hooké
    }
    
    // Hook...
    hookCache.put(lpparam.packageName, true);
}
```

### Lazy loading

```java
private Class<?> windowClass;

private Class<?> getWindowClass(ClassLoader loader) {
    if (windowClass == null) {
        windowClass = XposedHelpers.findClass("android.view.Window", loader);
    }
    return windowClass;
}
```

## 🔐 Bonnes pratiques

1. **Toujours tester** sur plusieurs applications
2. **Gérer les exceptions** pour éviter les crashs
3. **Logger modérément** pour ne pas ralentir le système
4. **Respecter les préférences** de l'utilisateur
5. **Documenter** vos modifications

## 🚀 Prochaines étapes

Vous pouvez étendre le module pour :
- ✅ Créer une interface de configuration
- ✅ Ajouter des règles per-app
- ✅ Implémenter un mode "intelligent"
- ✅ Ajouter des statistiques d'utilisation
- ✅ Créer des profils (Gaming, Travail, etc.)

N'hésitez pas à expérimenter et à adapter le module à vos besoins !
