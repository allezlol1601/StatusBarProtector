#!/bin/bash

# Script de compilation et installation du module Status Bar Protector

echo "🔨 Compilation du module Status Bar Protector..."

# Nettoyer les anciens builds
./gradlew clean

# Compiler en mode release
./gradlew assembleRelease

# Vérifier si la compilation a réussi
if [ $? -eq 0 ]; then
    echo "✅ Compilation réussie !"
    
    APK_PATH="app/build/outputs/apk/release/app-release.apk"
    
    if [ -f "$APK_PATH" ]; then
        echo "📦 APK généré : $APK_PATH"
        
        # Demander si l'utilisateur veut installer
        read -p "Voulez-vous installer l'APK sur l'appareil connecté ? (o/n) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[OoYy]$ ]]; then
            echo "📱 Installation sur l'appareil..."
            adb install -r "$APK_PATH"
            
            if [ $? -eq 0 ]; then
                echo "✅ Installation réussie !"
                echo ""
                echo "📝 Prochaines étapes :"
                echo "1. Ouvrez LSPosed"
                echo "2. Activez le module 'Status Bar Protector'"
                echo "3. Sélectionnez les applications dans la portée"
                echo "4. Redémarrez les applications ou l'appareil"
            else
                echo "❌ Erreur lors de l'installation"
            fi
        fi
    else
        echo "❌ APK non trouvé"
    fi
else
    echo "❌ Erreur lors de la compilation"
fi
