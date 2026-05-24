#!/bin/bash
# ============================================================
# Script de déploiement GitHub - Portfolio-pro
# ============================================================

set -euo pipefail

GIT_USER="khalidPro2025"
REPO_NAME="Portfolio-pro"
BRANCH="main"
SSH_KEY="$HOME/.ssh/id_ed25519"
REMOTE="git@github.com:${GIT_USER}/${REPO_NAME}.git"

echo "============================================================"
echo "🚀 DEPLOY - Portfolio-pro"
echo "============================================================"

# 1. Vérifier que la clé SSH existe
if [ ! -f "$SSH_KEY" ]; then
    echo "❌ Clé SSH non trouvée: $SSH_KEY"
    echo "   Génération d'une nouvelle clé..."
    ssh-keygen -t ed25519 -C "${GIT_USER}@github.com" -f "$SSH_KEY" -N ""
    echo "📋 Ajoutez cette clé sur GitHub:"
    cat "${SSH_KEY}.pub"
    exit 1
fi

# 2. Démarrer l'agent SSH
echo "[1/4] 🔐 Démarrage agent SSH..."
eval "$(ssh-agent -s)" >/dev/null
ssh-add "$SSH_KEY" 2>/dev/null

# 3. Tester la connexion GitHub (Version corrigée)
echo "[2/4] 🔎 Test connexion GitHub..."
SSH_OUTPUT=$(ssh -T git@github.com 2>&1 || true)

# Vérifier la connexion de plusieurs façons
if echo "$SSH_OUTPUT" | grep -qi "successfully authenticated" || \
   echo "$SSH_OUTPUT" | grep -qi "Hi.*! You've successfully" || \
   echo "$SSH_OUTPUT" | grep -qi "You've successfully authenticated"; then
    echo "✅ Connecté à GitHub avec succès"
else
    echo "❌ Échec de connexion SSH"
    echo "   Sortie: $SSH_OUTPUT"
    echo ""
    echo "👉 Ajoutez cette clé publique sur GitHub:"
    echo "--------------------------------------------------"
    cat "${SSH_KEY}.pub"
    echo "--------------------------------------------------"
    echo "https://github.com/settings/keys"
    exit 1
fi

# 4. Initialiser Git si nécessaire
echo "[3/4] 📦 Préparation du repository..."
if [ ! -d ".git" ]; then
    git init
    git branch -M "$BRANCH"
    echo "✅ Repository initialisé"
else
    echo "✅ Repository existant"
fi

# 5. Configurer le remote
echo "[4/4] 🔗 Configuration du remote..."
# Supprimer l'ancien remote s'il existe avec une URL différente
if git remote get-url origin >/dev/null 2>&1; then
    CURRENT_REMOTE=$(git remote get-url origin)
    if [ "$CURRENT_REMOTE" != "$REMOTE" ]; then
        git remote set-url origin "$REMOTE"
        echo "✅ Remote mis à jour"
    else
        echo "✅ Remote déjà correct"
    fi
else
    git remote add origin "$REMOTE"
    echo "✅ Remote ajouté"
fi

# 6. Pull les dernières modifications (évite les conflits)
echo "📥 Récupération des dernières modifications..."
git pull origin "$BRANCH" --rebase --allow-unrelated-histories 2>/dev/null || true

# 7. Ajouter tous les fichiers modifiés
echo "📝 Ajout des modifications..."
git add .

# 8. Vérifier s'il y a des changements
if git diff --cached --quiet; then
    echo "ℹ️ Aucun changement à committer"
else
    # Compter les fichiers modifiés
    FILES_CHANGED=$(git diff --cached --name-only | wc -l)
    echo "📝 $FILES_CHANGED fichier(s) modifié(s)"
    git commit -m "🔄 Mise à jour Portfolio-pro - $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 9. Pousser vers GitHub
echo "📤 Push vers GitHub..."
git push -u origin "$BRANCH" 2>&1 || {
    echo "⚠️ Push échoué, tentative avec --force..."
    git push -u origin "$BRANCH" --force
}

# 10. Résumé final
echo ""
echo "============================================================"
echo "✅ DEPLOY TERMINÉ AVEC SUCCÈS !"
echo "============================================================"
echo "📦 Repository : $REPO_NAME"
echo "🌿 Branche    : $BRANCH"
echo "🔗 URL        : https://github.com/${GIT_USER}/${REPO_NAME}"
echo "🕒 Date       : $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================================"

# Afficher le dernier commit
echo ""
echo "📋 Dernier commit :"
git log -1 --oneline
