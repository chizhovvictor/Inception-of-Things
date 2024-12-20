Чтобы получить информацию о кластере с агента, нужно настроить kubectl на второй машине так, чтобы он обращался к API-серверу на первой машине

Шаги для решения:

Скопируйте kubeconfig файл с первой машины на вторую
На первой машине (192.168.56.110), файл kubeconfig обычно находится по пути /etc/rancher/k3s/k3s.yaml. Скопируйте его на вторую машину

scp -P 2222 /etc/rancher/k3s/k3s.yaml vagrant@127.0.0.1:/home/vagrant/k3s.yaml

Измените адрес API-сервера в скопированном kubeconfig

На второй машине (192.168.56.111), откройте файл k3s.yaml:
Найдите строку server: https://127.0.0.1:6443 и замените 127.0.0.1 на IP-адрес вашего сервера (192.168.56.110)

Настройте kubectl использовать этот файл
Укажите kubectl использовать обновленный kubeconfig файл:
export KUBECONFIG=/home/vagrant/k3s.yaml


Постоянная настройка KUBECONFIG: Чтобы не задавать KUBECONFIG каждый раз, добавьте экспорт в ~/.bashrc:
echo "export KUBECONFIG=/home/vagrant/k3s.yaml" >> ~/.bashrc
source ~/.bashrc



