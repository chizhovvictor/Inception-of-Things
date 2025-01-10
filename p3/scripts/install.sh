#!/bin/bash



# install kubernetes, check k3d

set -e  # Stop the script if any command fails

echo "🔍 Checking for existing K3D cluster"
if k3d cluster list | grep -q 'p3'; then
  echo "✅ Cluster 'p3' already exists, skipping creation."
else
  echo "🚀 Creating cluster 'p3'"
  k3d cluster create p3
  kubectl cluster-info
  kubectl get nodes
fi

echo "🔍 Checking for existing namespaces"
if kubectl get namespace argocd &>/dev/null; then
  echo "✅ Namespace 'argocd' already exists, skipping."
else
  echo "🚀 Creating namespace 'argocd'"
  kubectl create namespace argocd
fi

if kubectl get namespace dev &>/dev/null; then
  echo "✅ Namespace 'dev' already exists, skipping."
else
  echo "🚀 Creating namespace 'dev'"
  kubectl create namespace dev
fi

kubectl get namespaces

echo "🔍 Checking for ArgoCD installation"
if kubectl get pods -n argocd | grep -q 'argocd-server'; then
  echo "✅ ArgoCD is already installed, skipping installation."
else
  echo "🚀 Installing ArgoCD"
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  sleep 5
  
  kubectl get pods -n argocd
  sleep 5

  echo "⏳ Waiting for ArgoCD to be ready..."
  kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=500s
fi

echo "🔍 Retrieving ArgoCD password"
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
echo "🔑 ArgoCD login password: $ARGOCD_PASSWORD"

echo "🔍 Checking port-forward for ArgoCD"
if lsof -i :8080 | grep LISTEN; then
  echo "✅ Port-forward for ArgoCD is already running."
else
  echo "🚀 Starting port-forward for ArgoCD"
  kubectl port-forward svc/argocd-server -n argocd 8080:443 &
  sleep 10
fi

echo "🌐 Open your browser and go to https://localhost:8080"
echo "👤 Login: admin"
echo "🔑 Password: $ARGOCD_PASSWORD"

echo "🔍 Checking for ArgoCD application deployment"
if kubectl get applications -n argocd | grep -q 'wil-playground'; then
  echo "✅ ArgoCD application 'wil-playground' is already deployed, skipping."
else
  echo "🚀 Applying ArgoCD application"
  kubectl apply -n argocd -f ../confs/application.yaml
fi

echo "🔍 Checking port-forward for application"
if lsof -i :8888 | grep LISTEN; then
  echo "✅ Port-forward for svc-wil is already running."
else
  echo "🚀 Starting port-forward for svc-wil"
  kubectl port-forward svc/svc-wil 8888:8888 -n dev &
fi

echo "✅ Installation complete!"


# установить lsof
# проверить работу на порту 8888 поскольку в данном скрипте команда не выполняется
