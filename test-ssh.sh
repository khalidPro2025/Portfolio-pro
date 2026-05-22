#!/bin/bash
echo "=== TEST SSH CONNECTION ==="
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo ""
echo "=== TESTING git@github.com ==="
ssh -T git@github.com
echo ""
echo "=== DONE ==="
