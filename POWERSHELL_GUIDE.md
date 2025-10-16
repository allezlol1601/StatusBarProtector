# 🚀 Guide PowerShell 7 - Status Bar Protector sur GitHub

## 🎯 Méthodes disponibles pour créer le repository

Comme je ne peux pas créer le repository directement pour vous, voici **3 méthodes** :

---

## Méthode 1 : GitHub CLI (gh) - LA PLUS SIMPLE ⭐

### Installation de GitHub CLI

```powershell
# Via winget (Windows 11+)
winget install --id GitHub.cli

# Via Chocolatey
choco install gh

# Via Scoop
scoop install gh
```

### Utilisation

```powershell
# 1. Se connecter à GitHub
gh auth login
# Suivez les instructions interactives

# 2. Créer le repository directement
gh repo create StatusBarProtector --public --source=. --remote=origin --push

# C'est tout ! Le repo est créé et le code est poussé ! 🎉
```

**Avantages** :
- ✅ Une seule commande
- ✅ Tout est automatique
- ✅ Pas besoin d'aller sur le navigateur

---

## Méthode 2 : Interface Web GitHub - LA PLUS CLASSIQUE

### Configuration avec PowerShell

```powershell
# 1. Extraire et naviguer
Expand-Archive StatusBarProtector.zip
cd StatusBarProtector

# 2. Configurer Git
.\setup_github.ps1

# 3. Créer le repo manuellement sur GitHub
Start-Process "https://github.com/new"
# Dans le navigateur :
# - Nom : StatusBarProtector
# - Public ou Private
# - NE PAS cocher README, .gitignore, LICENSE
# - Cliquer "Create repository"

# 4. Pousser le code
git push -u origin main

# 5. Vérifier la compilation
Start-Process "https://github.com/VOTRE_USERNAME/StatusBarProtector/actions"
```

---

## Méthode 3 : API GitHub avec PowerShell - POUR LES PROS

### Créer un Personal Access Token

1. Allez sur : https://github.com/settings/tokens
2. "Generate new token" → "Generate new token (classic)"
3. Nom : `StatusBarProtector`
4. Scopes : ☑️ `repo` (tous les sous-scopes)
5. "Generate token"
6. **COPIEZ LE TOKEN** (vous ne le reverrez plus)

### Script PowerShell

```powershell
# Définir vos credentials
$githubUsername = "VOTRE_USERNAME"
$githubToken = "VOTRE_TOKEN"

# Créer le repository via API
$headers = @{
    Authorization = "token $githubToken"
    Accept = "application/vnd.github.v3+json"
}

$body = @{
    name = "StatusBarProtector"
    description = "LSPosed module to prevent apps from covering the status bar"
    private = $false
    auto_init = $false
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
    -Method Post `
    -Headers $headers `
    -Body $body `
    -ContentType "application/json"

Write-Host "✅ Repository créé : $($response.html_url)" -ForegroundColor Green

# Configurer et pousser
cd StatusBarProtector
git init
git branch -M main
git remote add origin "https://github.com/$githubUsername/StatusBarProtector.git"
git add .
git commit -m "Initial commit - StatusBarProtector v1.0.0"
git push -u origin main
```

---

## 🚀 Utilisation après création

### Compiler localement

```powershell
# Build release
.\gradlew.bat assembleRelease

# Ou utilisez le script
.\build_and_install.ps1
```

### Créer une release

```powershell
# Créer un tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial release"

# Pousser le tag
git push origin v1.0.0

# GitHub Actions créera automatiquement la release !
```

### Télécharger l'APK compilé par GitHub

```powershell
# Ouvrir la page Actions
Start-Process "https://github.com/VOTRE_USERNAME/StatusBarProtector/actions"

# Cliquez sur le dernier workflow
# Scrollez jusqu'à "Artifacts"
# Téléchargez "StatusBarProtector-APK"
```

---

## 📊 Commandes PowerShell utiles

### Compilation

```powershell
# Clean build
.\gradlew.bat clean assembleRelease

# Build debug
.\gradlew.bat assembleDebug

# Lister les tâches
.\gradlew.bat tasks
```

### Git

```powershell
# Status
git status

# Voir les logs
git log --oneline --graph --all

# Créer une branche
git checkout -b feature/nouvelle-fonctionnalite

# Pousser une branche
git push -u origin feature/nouvelle-fonctionnalite
```

### ADB

```powershell
# Installer APK
adb install -r app\build\outputs\apk\release\app-release.apk

# Voir les logs
adb logcat | Select-String "StatusBarProtector"

# Lister les packages
adb shell pm list packages

# Forcer l'arrêt d'une app
adb shell am force-stop com.example.app
```

---

## 🔧 Configuration de l'environnement PowerShell

### Définir l'encodage UTF-8

```powershell
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

### Alias utiles

```powershell
# Dans votre profil PowerShell ($PROFILE)
Set-Alias -Name build -Value ".\gradlew.bat"
Set-Alias -Name gh-setup -Value ".\setup_github.ps1"

# Utilisation
build assembleRelease
gh-setup
```

### Fonction helper

```powershell
function Build-And-Install {
    .\gradlew.bat assembleRelease
    if ($LASTEXITCODE -eq 0) {
        adb install -r app\build\outputs\apk\release\app-release.apk
    }
}

# Utilisation
Build-And-Install
```

---

## 🎨 Personnalisation du prompt PowerShell

```powershell
# Ajouter dans $PROFILE pour voir la branche Git
function prompt {
    $location = Get-Location
    $gitBranch = git branch --show-current 2>$null
    
    if ($gitBranch) {
        Write-Host "PS $location " -NoNewline -ForegroundColor Green
        Write-Host "[$gitBranch]" -NoNewline -ForegroundColor Cyan
    } else {
        Write-Host "PS $location" -NoNewline -ForegroundColor Green
    }
    
    return "> "
}
```

---

## 📦 Package Manager pour PowerShell

### Installation de modules utiles

```powershell
# Module pour Git
Install-Module posh-git -Scope CurrentUser

# Module pour GitHub
Install-Module PowerShellForGitHub -Scope CurrentUser

# Importer
Import-Module posh-git
Import-Module PowerShellForGitHub
```

---

## 🐛 Troubleshooting PowerShell

### Erreur : Execution Policy

```powershell
# Vérifier la policy
Get-ExecutionPolicy

# Changer temporairement
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# Changer de manière permanente (admin requis)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Erreur : gradlew.bat not found

```powershell
# S'assurer d'être dans le bon répertoire
cd StatusBarProtector
Get-Location

# Vérifier que le fichier existe
Test-Path .\gradlew.bat
```

### Erreur : Git not found

```powershell
# Installer Git
winget install --id Git.Git

# Ou via Chocolatey
choco install git

# Redémarrer PowerShell après installation
```

---

## ✅ Checklist PowerShell

Avant de commencer :

- [ ] PowerShell 7+ installé (`$PSVersionTable.PSVersion`)
- [ ] Git installé (`git --version`)
- [ ] JDK 17+ installé (`java -version`)
- [ ] Android SDK configuré
- [ ] ADB accessible (`adb version`)
- [ ] Compte GitHub créé

---

## 🎯 Workflow recommandé avec PowerShell

```powershell
# 1. Extraire le projet
Expand-Archive StatusBarProtector.zip
cd StatusBarProtector

# 2. Option A : Avec GitHub CLI (recommandé)
gh auth login
gh repo create StatusBarProtector --public --source=. --push

# 2. Option B : Configuration manuelle
.\setup_github.ps1
# Créer le repo sur github.com/new
git push -u origin main

# 3. Vérifier la compilation GitHub
Start-Process "https://github.com/VOTRE_USERNAME/StatusBarProtector/actions"

# 4. Télécharger et installer l'APK
# Depuis GitHub Actions → Artifacts → StatusBarProtector-APK
adb install -r StatusBarProtector.apk

# 5. Créer une release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

---

## 📚 Ressources PowerShell

### Documentation
- [PowerShell 7](https://docs.microsoft.com/powershell/)
- [GitHub CLI](https://cli.github.com/)
- [Posh-Git](https://github.com/dahlbyk/posh-git)

### Modules utiles
- `posh-git` - Intégration Git
- `PowerShellForGitHub` - API GitHub
- `PSReadLine` - Autocomplétion améliorée

---

## 🎉 Récapitulatif

**La méthode la plus simple avec PowerShell** :

```powershell
# 1. Installer GitHub CLI
winget install GitHub.cli

# 2. Se connecter
gh auth login

# 3. Extraire et naviguer
Expand-Archive StatusBarProtector.zip
cd StatusBarProtector

# 4. Créer et pousser en une commande
gh repo create StatusBarProtector --public --source=. --remote=origin --push

# ✅ Terminé ! GitHub compile automatiquement votre APK
```

---

**Avec PowerShell 7, tout est plus simple et élégant ! 🚀**
