#!/bin/bash

# Script d'initialisation Git pour Status Bar Protector
# Ce script configure automatiquement votre repository GitHub

echo "🚀 Configuration du repository GitHub - Status Bar Protector"
echo ""

# Demander le nom d'utilisateur GitHub
read -p "📝 Entrez votre nom d'utilisateur GitHub : " github_username

if [ -z "$github_username" ]; then
    echo "❌ Erreur : Le nom d'utilisateur ne peut pas être vide"
    exit 1
fi

echo ""
echo "✅ Configuration pour l'utilisateur : $github_username"
echo ""

# Remplacer le README
if [ -f "README_GITHUB.md" ]; then
    echo "📄 Mise à jour du README..."
    mv README.md README_LOCAL.md 2>/dev/null
    mv README_GITHUB.md README.md
    
    # Remplacer VOTRE_USERNAME dans le README
    sed -i "s/VOTRE_USERNAME/$github_username/g" README.md 2>/dev/null || \
    sed -i '' "s/VOTRE_USERNAME/$github_username/g" README.md 2>/dev/null
    
    echo "✅ README configuré"
fi

# Initialiser Git si ce n'est pas déjà fait
if [ ! -d ".git" ]; then
    echo "🔧 Initialisation de Git..."
    git init
    git branch -M main
    echo "✅ Git initialisé"
else
    echo "ℹ️  Git déjà initialisé"
fi

# Vérifier que gradlew est exécutable
if [ -f "gradlew" ]; then
    chmod +x gradlew
    chmod +x build_and_install.sh
    echo "✅ Scripts rendus exécutables"
fi

# Ajouter tous les fichiers
echo "📦 Ajout des fichiers..."
git add .

# Créer le premier commit
echo "💾 Création du commit initial..."
git commit -m "Initial commit - StatusBarProtector v1.0.0

- LSPosed module pour protéger la barre d'état
- Support Android 12+ (API 31+)
- Testé sur Android 16 (Pixel 10 Pro XL)
- GitHub Actions pour compilation automatique
- Workflows pour build et release automatiques"

echo "✅ Commit créé"
echo ""

# Demander le type de remote (HTTPS ou SSH)
echo "🔐 Choisissez le type de connexion :"
echo "1) HTTPS (recommandé pour débuter)"
echo "2) SSH (si vous avez configuré une clé SSH)"
read -p "Votre choix (1 ou 2) : " remote_type

if [ "$remote_type" = "2" ]; then
    remote_url="git@github.com:$github_username/StatusBarProtector.git"
else
    remote_url="https://github.com/$github_username/StatusBarProtector.git"
fi

# Configurer le remote
echo "🔗 Configuration du remote..."
git remote remove origin 2>/dev/null
git remote add origin "$remote_url"
echo "✅ Remote configuré : $remote_url"
echo ""

# Afficher les instructions finales
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Configuration terminée !"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Prochaines étapes :"
echo ""
echo "1️⃣  Créez le repository sur GitHub :"
echo "   👉 https://github.com/new"
echo "   📝 Nom : StatusBarProtector"
echo "   📄 Ne pas ajouter de README, .gitignore ou LICENSE"
echo ""
echo "2️⃣  Poussez le code vers GitHub :"
echo "   git push -u origin main"
echo ""
echo "3️⃣  Vérifiez la compilation automatique :"
echo "   👉 https://github.com/$github_username/StatusBarProtector/actions"
echo ""
echo "4️⃣  Créez votre première release :"
echo "   git tag -a v1.0.0 -m \"Release v1.0.0 - Initial release\""
echo "   git push origin v1.0.0"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Documentation :"
echo "   - README.md : Documentation complète"
echo "   - GITHUB_SETUP.md : Guide détaillé GitHub"
echo ""
echo "🔗 Votre repository sera accessible sur :"
echo "   https://github.com/$github_username/StatusBarProtector"
echo ""
echo "🎉 Bon développement !"
