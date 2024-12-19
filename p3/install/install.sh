
# Install k3d

k3d cluster create p3
kubectl cluster-info
kubectl get nodes

# Install namespace
#kubectl creates namespace with context getting from kubeconfig (kubectl config current-context) and this namespace will be used for this cluster
kubectl create namespace argocd
kubectl create namespace dev
kubectl get namespaces

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd

# Wait for ArgoCD to be ready
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=600s

# Get ArgoCD password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

# Port forward ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Login to ArgoCD
# Open browser and go to https://localhost:8080
# Login with username: admin and password: <password>


# Apply ArgoCD Application
kubectl apply -n argocd -f confs/application.yaml