sudo apt-get update
sudo apt-get install curl -y

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --flannel-iface eth1" sh -s - --token 12345


sudo kubectl apply -f /vagrant/script/app1.yml
