# Script d'initialisation Git pour Status Bar Protector
# PowerShell 7

Write-Host "🚀 Configuration du repository GitHub - Status Bar Protector" -ForegroundColor Cyan
Write-Host ""

# Demander le nom d'utilisateur GitHub
$githubUsername = Read-Host "📝 Entrez votre nom d'utilisateur GitHub"

if ([string]::IsNullOrWhiteSpace($githubUsername)) {
    Write-Host "❌ Erreur : Le nom d'utilisateur ne peut pas être vide" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Configuration pour l'utilisateur : $githubUsername" -ForegroundColor Green
Write-Host ""

# Remplacer le README
if (Test-Path "README_GITHUB.md") {
    Write-Host "📄 Mise à jour du README..." -ForegroundColor Cyan
    if (Test-Path "README.md") {
        Move-Item "README.md" "README_LOCAL.md" -Force
    }
    Move-Item "README_GITHUB.md" "README.md" -Force
    
    # Remplacer VOTRE_USERNAME dans le README
    $readmeContent = Get-Content "README.md" -Raw
    $readmeContent = $readmeContent -replace "VOTRE_USERNAME", $githubUsername
    Set-Content "README.md" $readmeContent -NoNewline
    
    Write-Host "✅ README configuré" -ForegroundColor Green
}

# Initialiser Git si ce n'est pas déjà fait
if (-not (Test-Path ".git")) {
    Write-Host "🔧 Initialisation de Git..." -ForegroundColor Cyan
    git init
    git branch -M main
    Write-Host "✅ Git initialisé" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Git déjà initialisé" -ForegroundColor Yellow
}

# Ajouter tous les fichiers
Write-Host "📦 Ajout des fichiers..." -ForegroundColor Cyan
git add .

# Créer le premier commit
Write-Host "💾 Création du commit initial..." -ForegroundColor Cyan
git commit -m @"
Initial commit - StatusBarProtector v1.0.0

- LSPosed module pour protéger la barre d'état
- Support Android 12+ (API 31+)
- Testé sur Android 16 (Pixel 10 Pro XL)
- GitHub Actions pour compilation automatique
- Workflows pour build et release automatiques
"@

Write-Host "✅ Commit créé" -ForegroundColor Green
Write-Host ""

# Demander le type de remote (HTTPS ou SSH)
Write-Host "🔐 Choisissez le type de connexion :" -ForegroundColor Cyan
Write-Host "1) HTTPS (recommandé pour débuter)"
Write-Host "2) SSH (si vous avez configuré une clé SSH)"
$remoteType = Read-Host "Votre choix (1 ou 2)"

if ($remoteType -eq "2") {
    $remoteUrl = "git@github.com:$githubUsername/StatusBarProtector.git"
} else {
    $remoteUrl = "https://github.com/$githubUsername/StatusBarProtector.git"
}

# Configurer le remote
Write-Host "🔗 Configuration du remote..." -ForegroundColor Cyan
git remote remove origin 2>$null
git remote add origin $remoteUrl
Write-Host "✅ Remote configuré : $remoteUrl" -ForegroundColor Green
Write-Host ""

# Afficher les instructions finales
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Configuration terminée !" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Prochaines étapes :" -ForegroundColor Yellow
Write-Host ""
Write-Host "1️⃣  Créez le repository sur GitHub :" -ForegroundColor White
Write-Host "   👉 https://github.com/new" -ForegroundColor Cyan
Write-Host "   📝 Nom : StatusBarProtector" -ForegroundColor White
Write-Host "   📄 Ne pas ajouter de README, .gitignore ou LICENSE" -ForegroundColor White
Write-Host ""
Write-Host "2️⃣  Poussez le code vers GitHub :" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor Green
Write-Host ""
Write-Host "3️⃣  Vérifiez la compilation automatique :" -ForegroundColor White
Write-Host "   👉 https://github.com/$githubUsername/StatusBarProtector/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "4️⃣  Créez votre première release :" -ForegroundColor White
Write-Host "   git tag -a v1.0.0 -m `"Release v1.0.0 - Initial release`"" -ForegroundColor Green
Write-Host "   git push origin v1.0.0" -ForegroundColor Green
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "📚 Documentation :" -ForegroundColor Yellow
Write-Host "   - README.md : Documentation complète"
Write-Host "   - GITHUB_SETUP.md : Guide détaillé GitHub"
Write-Host ""
Write-Host "🔗 Votre repository sera accessible sur :" -ForegroundColor Yellow
Write-Host "   https://github.com/$githubUsername/StatusBarProtector" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 Bon développement !" -ForegroundColor Magenta
