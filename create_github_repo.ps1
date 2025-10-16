# Script PowerShell pour créer automatiquement le repository GitHub
# Nécessite un Personal Access Token GitHub
# PowerShell 7

param(
    [Parameter(Mandatory=$false)]
    [string]$Username,
    
    [Parameter(Mandatory=$false)]
    [string]$Token,
    
    [Parameter(Mandatory=$false)]
    [switch]$UseGitHubCLI
)

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║   Status Bar Protector - GitHub Repository Creator       ║
║   Configuration automatique avec PowerShell 7             ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""

# Vérifier si GitHub CLI est disponible
$ghAvailable = Get-Command gh -ErrorAction SilentlyContinue

if ($UseGitHubCLI -or ($ghAvailable -and -not $Token)) {
    Write-Host "🔧 Utilisation de GitHub CLI..." -ForegroundColor Cyan
    Write-Host ""
    
    # Vérifier l'authentification
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "🔐 Connexion à GitHub requise..." -ForegroundColor Yellow
        gh auth login
    } else {
        Write-Host "✅ Déjà connecté à GitHub" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "📝 Création du repository GitHub..." -ForegroundColor Cyan
    
    # Remplacer le README
    if (Test-Path "README_GITHUB.md") {
        if (Test-Path "README.md") {
            Move-Item "README.md" "README_LOCAL.md" -Force
        }
        Move-Item "README_GITHUB.md" "README.md" -Force
    }
    
    # Obtenir le username
    $currentUser = (gh api user | ConvertFrom-Json).login
    
    # Mettre à jour le README avec le bon username
    if (Test-Path "README.md") {
        $readmeContent = Get-Content "README.md" -Raw
        $readmeContent = $readmeContent -replace "VOTRE_USERNAME", $currentUser
        Set-Content "README.md" $readmeContent -NoNewline
    }
    
    # Initialiser Git si nécessaire
    if (-not (Test-Path ".git")) {
        git init
        git branch -M main
    }
    
    # Ajouter et commiter
    git add .
    git commit -m @"
Initial commit - StatusBarProtector v1.0.0

- LSPosed module pour protéger la barre d'état
- Support Android 12+ (API 31+)
- Testé sur Android 16 (Pixel 10 Pro XL)
- GitHub Actions pour compilation automatique
"@
    
    # Créer le repo et pousser
    Write-Host "🚀 Création et push du repository..." -ForegroundColor Cyan
    gh repo create StatusBarProtector --public --source=. --remote=origin --push
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host "✅ SUCCÈS ! Repository créé et code poussé !" -ForegroundColor Green
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 Votre repository : https://github.com/$currentUser/StatusBarProtector" -ForegroundColor Cyan
        Write-Host "⚡ Actions : https://github.com/$currentUser/StatusBarProtector/actions" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📋 Prochaines étapes :" -ForegroundColor Yellow
        Write-Host "1. GitHub Actions est en train de compiler l'APK"
        Write-Host "2. Allez dans Actions pour voir la progression"
        Write-Host "3. Téléchargez l'APK depuis Artifacts une fois terminé"
        Write-Host ""
        Write-Host "🏷️ Pour créer une release :" -ForegroundColor Yellow
        Write-Host "   git tag -a v1.0.0 -m `"Release v1.0.0`"" -ForegroundColor Green
        Write-Host "   git push origin v1.0.0" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "❌ Erreur lors de la création du repository" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "🔑 Utilisation de l'API GitHub..." -ForegroundColor Cyan
    Write-Host ""
    
    # Demander les credentials si non fournis
    if (-not $Username) {
        $Username = Read-Host "📝 Nom d'utilisateur GitHub"
    }
    
    if (-not $Token) {
        Write-Host ""
        Write-Host "🔐 Token GitHub requis :" -ForegroundColor Yellow
        Write-Host "1. Allez sur : https://github.com/settings/tokens" -ForegroundColor Cyan
        Write-Host "2. 'Generate new token (classic)'"
        Write-Host "3. Nom : StatusBarProtector"
        Write-Host "4. Cochez : repo (tous les sous-scopes)"
        Write-Host "5. Generate token"
        Write-Host ""
        Start-Process "https://github.com/settings/tokens/new"
        Write-Host ""
        $Token = Read-Host "📋 Collez votre token GitHub" -AsSecureString
        $Token = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Token))
    }
    
    Write-Host ""
    Write-Host "📝 Création du repository via API..." -ForegroundColor Cyan
    
    # Préparer les headers
    $headers = @{
        Authorization = "token $Token"
        Accept = "application/vnd.github.v3+json"
    }
    
    # Préparer le body
    $body = @{
        name = "StatusBarProtector"
        description = "LSPosed module to prevent apps from covering the status bar"
        private = $false
        auto_init = $false
        has_issues = $true
        has_projects = $true
        has_wiki = $true
    } | ConvertTo-Json
    
    try {
        # Créer le repository
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
            -Method Post `
            -Headers $headers `
            -Body $body `
            -ContentType "application/json"
        
        Write-Host "✅ Repository créé : $($response.html_url)" -ForegroundColor Green
        
        # Remplacer le README
        if (Test-Path "README_GITHUB.md") {
            if (Test-Path "README.md") {
                Move-Item "README.md" "README_LOCAL.md" -Force
            }
            Move-Item "README_GITHUB.md" "README.md" -Force
            
            # Mettre à jour le README avec le bon username
            $readmeContent = Get-Content "README.md" -Raw
            $readmeContent = $readmeContent -replace "VOTRE_USERNAME", $Username
            Set-Content "README.md" $readmeContent -NoNewline
        }
        
        # Configurer Git
        Write-Host "🔧 Configuration de Git..." -ForegroundColor Cyan
        
        if (-not (Test-Path ".git")) {
            git init
            git branch -M main
        }
        
        git remote remove origin 2>$null
        git remote add origin "https://github.com/$Username/StatusBarProtector.git"
        
        # Ajouter et commiter
        Write-Host "💾 Commit des fichiers..." -ForegroundColor Cyan
        git add .
        git commit -m @"
Initial commit - StatusBarProtector v1.0.0

- LSPosed module pour protéger la barre d'état
- Support Android 12+ (API 31+)
- Testé sur Android 16 (Pixel 10 Pro XL)
- GitHub Actions pour compilation automatique
"@
        
        # Pousser vers GitHub
        Write-Host "🚀 Push vers GitHub..." -ForegroundColor Cyan
        git push -u origin main
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
            Write-Host "✅ SUCCÈS ! Repository créé et code poussé !" -ForegroundColor Green
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
            Write-Host ""
            Write-Host "🔗 Votre repository : https://github.com/$Username/StatusBarProtector" -ForegroundColor Cyan
            Write-Host "⚡ Actions : https://github.com/$Username/StatusBarProtector/actions" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "📋 Prochaines étapes :" -ForegroundColor Yellow
            Write-Host "1. GitHub Actions est en train de compiler l'APK"
            Write-Host "2. Allez dans Actions pour voir la progression"
            Write-Host "3. Téléchargez l'APK depuis Artifacts une fois terminé"
            Write-Host ""
            Write-Host "🏷️ Pour créer une release :" -ForegroundColor Yellow
            Write-Host "   git tag -a v1.0.0 -m `"Release v1.0.0`"" -ForegroundColor Green
            Write-Host "   git push origin v1.0.0" -ForegroundColor Green
            Write-Host ""
        } else {
            Write-Host "❌ Erreur lors du push" -ForegroundColor Red
            exit 1
        }
        
    } catch {
        Write-Host "❌ Erreur : $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Vérifiez que :" -ForegroundColor Yellow
        Write-Host "- Le token est valide et a les permissions 'repo'"
        Write-Host "- Vous n'avez pas déjà un repo nommé 'StatusBarProtector'"
        Write-Host "- Votre connexion internet fonctionne"
        exit 1
    }
}

Write-Host "🎉 Configuration terminée avec succès !" -ForegroundColor Magenta
