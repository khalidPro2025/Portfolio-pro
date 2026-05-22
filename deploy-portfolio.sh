#!/bin/bash
set -euo pipefail

GIT_USER="khalidPro2025"
REPO_NAME="Portfolio-pro"
BRANCH="main"
SSH_KEY="$HOME/.ssh/id_ed25519"
REMOTE="git@github.com:${GIT_USER}/${REPO_NAME}.git"

echo "============================================================"
echo "🚀 DEPLOY - Portfolio-pro"
echo "============================================================"

# Agent SSH
eval "$(ssh-agent -s)" >/dev/null
ssh-add "$SSH_KEY" >/dev/null 2>&1

# Test connexion
echo "🔎 Test GitHub..."
if ! ssh -T git@github.com 2>&1 | grep -qi "Hi"; then
    echo "❌ Échec connexion"
    exit 1
fi
echo "✅ Connecté"

# Init Git
[ ! -d ".git" ] && git init && git branch -M "$BRANCH"

# Remote
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"

# Push
git add .
git diff --cached --quiet || git commit -m "🚀 Deploy Portfolio-pro - $(date '+%Y-%m-%d %H:%M:%S')"
git push -u origin "$BRANCH"

echo "✅ https://github.com/${GIT_USER}/${REPO_NAME}"
