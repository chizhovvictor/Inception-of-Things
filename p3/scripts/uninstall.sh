#!/bin/bash

set -e  # Завершаем скрипт при ошибке

echo "🧹 Delete port-forward..."
# Завершаем все процессы с kubectl port-forward
pkill -f "kubectl port-forward" || true

echo "🧹 Delete from ArgoCD..."
kubectl delete -n argocd -f confs/application.yaml || true

echo "🧹 Delete ArgoCD..."
kubectl delete namespace argocd --wait=true || true

echo "🧹 Delete namespace dev..."
kubectl delete namespace dev --wait=true || true

echo "🧹 Delete cluster k3d..."
k3d cluster delete p3 || true

echo "✅ Deleted"
