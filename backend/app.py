#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask, jsonify, request
from flask_cors import CORS
import os
import logging

# Configuration
app = Flask(__name__)
CORS(app)  # Permettre les requêtes du frontend

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Routes
@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'healthy',
        'message': 'Portfolio-pro API is running!'
    })

@app.route('/api/info', methods=['GET'])
def info():
    return jsonify({
        'name': 'Portfolio-pro',
        'version': '1.0.0',
        'backend': 'Python/Flask',
        'status': 'running'
    })

@app.route('/api/contact', methods=['POST'])
def contact():
    data = request.get_json()
    logger.info(f"Message reçu: {data}")
    return jsonify({
        'success': True,
        'message': 'Message envoyé avec succès!'
    })

# Erreur 404
@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Route not found'}), 404

# Erreur 500
@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
