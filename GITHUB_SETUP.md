# 🚀 Guide de configuration GitHub - Status Bar Protector

Ce guide explique comment configurer votre repository GitHub pour compiler automatiquement le module avec GitHub Actions.

## 📋 Table des matières

1. [Créer le repository](#1-créer-le-repository)
2. [Pousser le code](#2-pousser-le-code)
3. [Vérifier la compilation](#3-vérifier-la-compilation)
4. [Créer une release](#4-créer-une-release)
5. [Configuration avancée](#5-configuration-avancée)

---

## 1. Créer le repository

### Sur GitHub.com :

1. Allez sur [github.com](https://github.com) et connectez-vous
2. Cliquez sur **"New repository"** (ou le bouton **+** en haut à droite)
3. Remplissez les informations :
   - **Repository name** : `StatusBarProtector`
   - **Description** : `LSPosed module to prevent apps from covering the status bar`
   - **Visibility** : Public ou Private (votre choix)
   - ☑️ **Add a README file** : NON (on a déjà un README)
   - **Add .gitignore** : NON (on en a déjà un)
   - **Choose a license** : MIT (recommandé) ou autre
4. Cliquez sur **"Create repository"**

---

## 2. Pousser le code

### Sur votre ordinateur :

```bash
# Se placer dans le dossier du projet
cd StatusBarProtector

# Remplacer le README par la version GitHub
mv README.md README_LOCAL.md
mv README_GITHUB.md README.md

# Initialiser Git (si pas déjà fait)
git init

# Ajouter tous les fichiers
git add .

# Premier commit
git commit -m "Initial commit - StatusBarProtector v1.0.0"

# Ajouter le remote (remplacez VOTRE_USERNAME)
git remote add origin https://github.com/VOTRE_USERNAME/StatusBarProtector.git

# Pousser vers GitHub
git branch -M main
git push -u origin main
```

### Avec SSH (si configuré) :

```bash
git remote add origin git@github.com:VOTRE_USERNAME/StatusBarProtector.git
git push -u origin main
```

---

## 3. Vérifier la compilation

### Automatiquement après le push :

1. Allez sur votre repo : `https://github.com/VOTRE_USERNAME/StatusBarProtector`
2. Cliquez sur l'onglet **"Actions"**
3. Vous devriez voir le workflow **"Build APK"** en cours d'exécution

### Progression :

- 🟡 **Jaune** : En cours
- ✅ **Vert** : Succès
- ❌ **Rouge** : Échec

### Télécharger l'APK compilé :

1. Attendez que le workflow soit terminé (✅ vert)
2. Cliquez sur le workflow
3. Scrollez vers le bas jusqu'à **"Artifacts"**
4. Cliquez sur **"StatusBarProtector-APK"** pour télécharger
5. Extrayez le ZIP et vous aurez votre APK !

---

## 4. Créer une release

### Méthode 1 : Via Git (recommandé)

```bash
# Créer un tag pour la version 1.0.0
git tag -a v1.0.0 -m "Release v1.0.0 - Initial release"

# Pousser le tag vers GitHub
git push origin v1.0.0
```

GitHub Actions va automatiquement :
- ✅ Compiler l'APK
- ✅ Créer une release sur GitHub
- ✅ Attacher l'APK à la release
- ✅ Générer des notes de release

### Méthode 2 : Via l'interface GitHub

1. Sur votre repo, cliquez sur **"Releases"** (colonne de droite)
2. Cliquez sur **"Draft a new release"**
3. **Choose a tag** : Tapez `v1.0.0` et créez le tag
4. **Release title** : `v1.0.0 - Initial Release`
5. **Describe this release** : Ajoutez des notes de version
6. Cochez **"Set as the latest release"**
7. Cliquez sur **"Publish release"**

Le workflow se déclenchera automatiquement et ajoutera l'APK à la release.

### Convention de nommage des tags :

- `v1.0.0` - Release majeure
- `v1.1.0` - Nouvelle fonctionnalité
- `v1.1.1` - Correction de bug
- `v2.0.0` - Changements majeurs

---

## 5. Configuration avancée

### Badges dans le README

Dans votre `README.md`, remplacez `VOTRE_USERNAME` par votre vrai nom d'utilisateur GitHub :

```markdown
[![Build APK](https://github.com/VOTRE_USERNAME/StatusBarProtector/actions/workflows/build.yml/badge.svg)](https://github.com/VOTRE_USERNAME/StatusBarProtector/actions/workflows/build.yml)
```

Exemple pour l'utilisateur `johndoe` :
```markdown
[![Build APK](https://github.com/johndoe/StatusBarProtector/actions/workflows/build.yml/badge.svg)](https://github.com/johndoe/StatusBarProtector/actions/workflows/build.yml)
```

### Activer GitHub Pages (optionnel)

Pour héberger la documentation :

1. **Settings** → **Pages**
2. **Source** : `Deploy from a branch`
3. **Branch** : `main`, folder `/ (root)`
4. Cliquez sur **Save**

Votre documentation sera accessible sur :
`https://VOTRE_USERNAME.github.io/StatusBarProtector`

### Protéger la branche main

Pour éviter les push directs :

1. **Settings** → **Branches**
2. Cliquez sur **"Add rule"**
3. **Branch name pattern** : `main`
4. Cochez :
   - ☑️ **Require a pull request before merging**
   - ☑️ **Require status checks to pass before merging**
   - Sélectionnez **"Build APK"** dans les status checks
5. Cliquez sur **"Create"**

### Ajouter des secrets (si nécessaire)

Si vous voulez signer l'APK :

1. **Settings** → **Secrets and variables** → **Actions**
2. Cliquez sur **"New repository secret"**
3. Ajoutez vos secrets :
   - `KEYSTORE_FILE` (base64 du keystore)
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS`
   - `KEY_PASSWORD`

---

## 📊 Workflow des GitHub Actions

### build.yml - Compilation automatique

**Se déclenche sur :**
- Push sur `main`, `master`, ou `develop`
- Pull Request vers `main` ou `master`
- Manuellement via l'interface

**Actions :**
1. Checkout du code
2. Installation de JDK 17
3. Compilation avec Gradle
4. Upload de l'APK en tant qu'artefact

**Durée moyenne** : 2-3 minutes

### release.yml - Release automatique

**Se déclenche sur :**
- Push d'un tag `v*.*.*` (ex: `v1.0.0`)
- Manuellement via l'interface

**Actions :**
1. Compilation de l'APK
2. Renommage de l'APK avec la version
3. Création d'une release GitHub
4. Attachement de l'APK à la release

**Durée moyenne** : 2-3 minutes

---

## 🔄 Workflow de développement recommandé

### Développement quotidien :

```bash
# 1. Créer une branche pour votre feature
git checkout -b feature/nouvelle-fonctionnalite

# 2. Faire vos modifications
# ... éditer les fichiers ...

# 3. Committer
git add .
git commit -m "Add: Nouvelle fonctionnalité"

# 4. Pousser vers GitHub
git push origin feature/nouvelle-fonctionnalite

# 5. Créer une Pull Request sur GitHub
# → GitHub Actions va compiler et tester

# 6. Merger la PR une fois les checks passés
```

### Créer une nouvelle version :

```bash
# 1. S'assurer d'être sur main et à jour
git checkout main
git pull origin main

# 2. Mettre à jour le versionCode/versionName dans build.gradle
# ... éditer app/build.gradle ...

# 3. Committer les changements
git add app/build.gradle
git commit -m "Bump version to 1.1.0"
git push origin main

# 4. Créer un tag
git tag -a v1.1.0 -m "Release v1.1.0 - Description des changements"
git push origin v1.1.0

# GitHub Actions va créer la release automatiquement !
```

---

## 🎯 Personnalisation des workflows

### Modifier build.yml

Exemple pour compiler sur plusieurs branches :

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]
```

Exemple pour ajouter des tests :

```yaml
- name: Run tests
  run: ./gradlew test

- name: Run lint
  run: ./gradlew lint
```

### Modifier release.yml

Exemple pour signer l'APK :

```yaml
- name: Sign APK
  uses: r0adkll/sign-android-release@v1
  with:
    releaseDirectory: app/build/outputs/apk/release
    signingKeyBase64: ${{ secrets.KEYSTORE_FILE }}
    alias: ${{ secrets.KEY_ALIAS }}
    keyStorePassword: ${{ secrets.KEYSTORE_PASSWORD }}
    keyPassword: ${{ secrets.KEY_PASSWORD }}
```

---

## 🐛 Dépannage

### Le workflow échoue

**Vérifier les logs :**
1. Onglet **Actions**
2. Cliquer sur le workflow en échec
3. Cliquer sur le job **"build"**
4. Voir les logs détaillés

**Erreurs communes :**

| Erreur | Solution |
|--------|----------|
| Permission denied sur gradlew | Ajoutez `chmod +x gradlew` avant de commit |
| Gradle build failed | Vérifiez votre `build.gradle` localement |
| Out of memory | Ajoutez `org.gradle.jvmargs=-Xmx4096m` dans gradle.properties |
| Artifact upload failed | Vérifiez que l'APK existe dans le chemin spécifié |

### L'artefact ne se télécharge pas

- Attendez que le workflow soit complètement terminé (✅)
- Vérifiez que vous êtes connecté à GitHub
- Les artefacts expirent après 30 jours

### La release ne se crée pas

- Vérifiez que le tag commence par `v` (ex: `v1.0.0`)
- Assurez-vous que le workflow a les permissions nécessaires
- Vérifiez les logs du workflow `release.yml`

---

## 📚 Ressources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Android CI/CD with GitHub Actions](https://github.com/actions/setup-java)
- [Signing Android Apps](https://developer.android.com/studio/publish/app-signing)

---

## ✅ Checklist finale

Avant de pousser vers GitHub :

- [ ] README.md mis à jour avec votre username
- [ ] .gitignore en place
- [ ] Workflows testés localement si possible
- [ ] Premier commit créé
- [ ] Remote GitHub configuré
- [ ] Code poussé vers GitHub
- [ ] Workflow exécuté avec succès
- [ ] APK téléchargé et testé
- [ ] Badge dans le README fonctionnel

---

## 🎉 C'est tout !

Votre projet est maintenant sur GitHub avec compilation automatique !

**Chaque fois que vous faites un commit :**
- ✅ GitHub compile automatiquement l'APK
- ✅ Vous pouvez le télécharger depuis les Actions
- ✅ Les releases sont automatiques avec les tags

**Prochaines étapes :**
- Personnalisez le README avec votre username
- Créez votre première release avec un tag
- Partagez votre repo !

**Liens utiles :**
- Votre repo : `https://github.com/VOTRE_USERNAME/StatusBarProtector`
- Actions : `https://github.com/VOTRE_USERNAME/StatusBarProtector/actions`
- Releases : `https://github.com/VOTRE_USERNAME/StatusBarProtector/releases`
