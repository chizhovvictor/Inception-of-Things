sudo apt-get update
sudo apt-get install curl -y

export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 -t $(cat /vagrant/token.env) --node-ip=192.168.56.111"


curl -sfL https://get.k3s.io | sh -


sudo rm /vagrant/token.env
