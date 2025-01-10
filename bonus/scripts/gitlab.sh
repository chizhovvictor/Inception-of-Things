# install helm


# install gitlab docker
docker compose -f ./gitlab_install up -d

# install namespaces
kubectl create namespace gitlab
kubectl get namespaces

# get password

docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
