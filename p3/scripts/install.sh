#!bin/bash

set -e

echo "Install k3d"

k3d cluster create p3
kubectl cluster-info
kubectl get nodes

echo "Install namespaces"
#kubectl creates namespace with context getting from kubeconfig (kubectl config current-context) and this namespace will be used for this cluster
kubectl create namespace argocd
kubectl create namespace dev
kubectl get namespaces

echo "Install ArgoCD"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd

echo "Wait for ArgoCD to be ready"
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=600s

echo "Get ArgoCD password"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

echo "Port forward ArgoCD"
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

sleep 10

echo "Login to ArgoCD"
echo "Open browser and go to https://localhost:8080"
echo "Login with username: admin and password: <password>"


echo "Apply ArgoCD Application"
kubectl apply -n argocd -f confs/application.yaml

echo "Forward Apllication to localhost"
kubectl port-forward svc/svc-wil 8888:8888 -n dev &

echo "✅ Done"
wait