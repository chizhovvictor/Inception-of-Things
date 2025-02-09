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
#sudo helm install gitlab gitlab/gitlab \
#  --namespace gitlab \
#  --set global.hosts.domain=gitlab-local.com\
#  --set global.hosts.externalIP=10.1.1.1 \
#  --set certmanager-issuer.email="huesosy@pidorasy.com"

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

#get passwd
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode

Шаг 6: Интеграция с Kubernetes

Для того чтобы GitLab мог работать с вашим кластером, необходимо настроить Kubernetes CI/CD:

    Подключите ваш кластер Kubernetes к GitLab:
        В интерфейсе GitLab перейдите в Admin Area → Kubernetes и добавьте ваш кластер.
        Это позволит GitLab взаимодействовать с Kubernetes для развертывания приложений через CI/CD.

    Настройка GitLab Runner для работы с Kubernetes:

        Установите GitLab Runner в Kubernetes для выполнения пайплайнов CI/CD.

        Вы можете установить GitLab Runner с помощью Helm:

        helm install gitlab-runner gitlab/gitlab-runner --namespace gitlab

        Это создаст ресурс gitlab-runner в вашем кластере, который будет отвечать за запуск пайплайнов.

Шаг 7: Настройка GitLab CI/CD

    В вашем репозитории GitLab создайте файл .gitlab-ci.yml для определения пайплайнов.

    Пример базового .gitlab-ci.yml:

    stages:
      - build
      - deploy

    build:
      stage: build
      script:
        - echo "Building the application"

    deploy:
      stage: deploy
      script:
        - kubectl apply -f kubernetes/deployment.yaml

    Создайте ресурсы Kubernetes (например, Deployment, Service, etc.) в каталоге kubernetes/ вашего проекта, чтобы GitLab мог деплоить их в ваш кластер.

Шаг 8: Убедитесь, что все работает

    Проверьте доступность GitLab по адресу http://localhost:8080.
    Убедитесь, что GitLab может запускать пайплайны, деплоить приложения и работать с Kubernetes


