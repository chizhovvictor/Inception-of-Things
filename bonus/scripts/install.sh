# Install helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Check helm
helm version

# Add repo gitlab helm
sudo helm repo add gitlab https://charts.gitlab.io

# Update local repo helm
sudo helm repo update

# create namespace
sudo kubectl create namespace gitlab

# install gitlab helm chart
sudo helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=gitlab-local.com \
  --set global.hosts.externalIP=10.1.1.1 \
  --set global.hosts.https=false
  

# Install helm chart
helm install gitlab gitlab/gitlab -f value.yaml -n gitlab

# Check install gitlab
sudo kubectl get all -n gitlab

# Check open port for gitlab
sudo kubectl describe svc gitlab-webservice-default -n gitlab

# UI gitlab 
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 8083:8181

# Check helm lists
helm list -n gitlab

# Delete helm list if it exists
helm uninstall gitlab -n gitlab

# Get passwd
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode

# Get name of application
sudo kubectl get applications --all-namespaces

# Get repo url of application
kubectl get application wil-playground -n argocd -o yaml | grep repoURL

# Create repo in gitlab and copy data from github in gitlab

# Download repo from gitlab
git clone http://localhost:8083/root/vchizhov.git

# Apply new configuration for argocd
sudo kubectl apply -f ./conf/application.yaml

