#!/bin/bash
# ============================================================
# Build et Push Portfolio-pro (Python + React)
# ============================================================

set -e

DOCKER_USERNAME="khalid267"
IMAGE_NAME="portfolio-pro"
VERSION=${1:-latest}

echo ""
echo "============================================================"
echo "🐳 Building Portfolio-pro with Python Backend"
echo "============================================================"

# Vérifications
if [ ! -f "backend/requirements.txt" ]; then
    echo "❌ backend/requirements.txt non trouvé!"
    exit 1
fi

if [ ! -f "backend/app.py" ]; then
    echo "❌ backend/app.py non trouvé!"
    exit 1
fi

if [ ! -d "frontend" ]; then
    echo "❌ Dossier frontend non trouvé!"
    exit 1
fi

# Login Docker Hub
echo "[1/4] 🔐 Connexion à Docker Hub..."
docker login

# Build frontend (optionnel, fait dans Dockerfile)
echo "[2/4] 🔨 Construction de l'image Docker..."
docker build -t ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} .

# Tagger
echo "[3/4] 🏷️  Tagging de l'image..."
docker tag ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION} ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

# Push
echo "[4/4] 📤 Push vers Docker Hub..."
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}
docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest

echo ""
echo "============================================================"
echo "✅ IMAGE PUSHED SUCCESSFULLY!"
echo "📦 Image: ${DOCKER_USERNAME}/${IMAGE_NAME}:${VERSION}"
echo "🔗 https://hub.docker.com/r/${DOCKER_USERNAME}/${IMAGE_NAME}"
echo "============================================================"
echo ""
echo "🐍 Backend: Python/Flask"
echo "⚛️ Frontend: React"
echo ""
echo "Pour tester localement :"
echo "docker run -d -p 3000:3000 -p 5000:5000 ${DOCKER_USERNAME}/${IMAGE_NAME}:latest"
echo ""
echo "Pour accéder :"
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 API Health: http://localhost:5000/api/health"
echo "============================================================"
