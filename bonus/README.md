# README - Установка и настройка GitLab с помощью Helm на K3D и Argo CD

## Описание задачи
Задача включает в себя установку и настройку **GitLab** локально, а также интеграцию с **K3D** и **Argo CD** для автоматического развертывания приложений из GitHub. Это расширение задачи из **Part 3: K3d and Argo CD**, где GitLab используется как дополнительный сервис для хранения кода и управления репозиториями.

### Этапы выполнения:
1. Установка и настройка **K3D** (K3S в Docker-контейнерах).
2. Установка и настройка **Argo CD** для автоматического деплоя приложений.
3. Установка **GitLab** в Kubernetes с помощью **Helm**.
4. Интеграция GitLab с Argo CD для автоматического обновления приложений.
5. Создание двух версий приложения и автоматический деплой через Argo CD.

### Требования:
- Установленный **K3D** для локальной работы с Kubernetes.
- Установленный **Argo CD** для автоматического деплоя.
- **GitLab** на локальной машине, настроенный через Helm.

---

## Шаги для выполнения

### 1. Установка Helm
Для начала нужно установить **Helm**, чтобы можно было использовать его для установки GitLab:
```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

### 2. Проверка Helm
Проверь, что **Helm** успешно установлен:
```bash
helm version
```

### 3. Добавление репозитория GitLab
Добавь репозиторий Helm для GitLab:
```bash
sudo helm repo add gitlab https://charts.gitlab.io
```

### 4. Обновление локального репозитория Helm
Обнови список доступных чартов:
```bash
sudo helm repo update
```

### 5. Создание namespace для GitLab
Создай новый namespace для GitLab:
```bash
sudo kubectl create namespace gitlab
```

### 6. Установка GitLab с использованием Helm
Установи **GitLab** через Helm:
```bash
sudo helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=gitlab-local.com \
  --set global.hosts.externalIP=10.1.1.1 \
  --set global.hosts.https=false
```

### 7. Проверка установки GitLab
Проверь, что все компоненты GitLab установлены:
```bash
sudo kubectl get all -n gitlab
```

### 8. Открытие порта для GitLab
Если GitLab установлен корректно, открой его веб-интерфейс через порт-forwarding:
```bash
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 8083:8181
```
Теперь ты можешь зайти в GitLab через `http://localhost:8083`.

### 9. Проверка списка Helm-релизов
Убедись, что GitLab установлен через Helm:
```bash
helm list -n gitlab
```

### 10. Удаление старых Helm релизов
Если необходимо, удали старые релизы GitLab:
```bash
helm uninstall gitlab -n gitlab
```

### 11. Получение пароля администратора GitLab
Для получения пароля администратора GitLab выполните команду:
```bash
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
```

### 12. Получение информации о приложении в Argo CD
Получите имя приложения в Argo CD:
```bash
sudo kubectl get applications --all-namespaces
```
Для получения URL репозитория приложения в Argo CD:
```bash
kubectl get application wil-playground -n argocd -o yaml | grep repoURL
```

### 13. Создание репозитория в GitLab
Создайте новый репозиторий в GitLab и скопируйте данные из GitHub.

### 14. Клонирование репозитория из GitLab
Клонируйте репозиторий из GitLab:
```bash
git clone http://localhost:8083/root/vchizhov.git
```

### 15. Применение новой конфигурации для Argo CD
Примените новую конфигурацию для приложения в Argo CD:
```bash
sudo kubectl apply -f ./conf/application.yaml
```

---

## Дополнительные задачи
- В случае использования **Minikube** или другого локального кластера, нужно будет прокинуть доменное имя в файл `/etc/hosts`.
- Если нужно изменить версию приложения через GitHub, создайте теги `v1` и `v2` для вашего Docker-образа и настройте их в GitLab.

---

## Заключение
Этот процесс позволяет интегрировать **GitLab** в локальный кластер Kubernetes с использованием **Helm**, а также настроить автоматический деплой через **Argo CD**. В результате вы получаете рабочую систему для управления кодом и автоматического развертывания приложений.

