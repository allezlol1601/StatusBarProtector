# Script de compilation et installation du module Status Bar Protector
# PowerShell 7

Write-Host "🔨 Compilation du module Status Bar Protector..." -ForegroundColor Cyan

# Nettoyer les anciens builds
.\gradlew.bat clean

# Compiler en mode release
.\gradlew.bat assembleRelease

# Vérifier si la compilation a réussi
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Compilation réussie !" -ForegroundColor Green
    
    $apkPath = "app\build\outputs\apk\release\app-release.apk"
    
    if (Test-Path $apkPath) {
        Write-Host "📦 APK généré : $apkPath" -ForegroundColor Green
        
        # Demander si l'utilisateur veut installer
        $response = Read-Host "Voulez-vous installer l'APK sur l'appareil connecté ? (O/N)"
        
        if ($response -match '^[OoYy]') {
            Write-Host "📱 Installation sur l'appareil..." -ForegroundColor Cyan
            adb install -r $apkPath
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Installation réussie !" -ForegroundColor Green
                Write-Host ""
                Write-Host "📝 Prochaines étapes :" -ForegroundColor Yellow
                Write-Host "1. Ouvrez LSPosed"
                Write-Host "2. Activez le module 'Status Bar Protector'"
                Write-Host "3. Sélectionnez les applications dans la portée"
                Write-Host "4. Redémarrez les applications ou l'appareil"
            } else {
                Write-Host "❌ Erreur lors de l'installation" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "❌ APK non trouvé" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Erreur lors de la compilation" -ForegroundColor Red
}
