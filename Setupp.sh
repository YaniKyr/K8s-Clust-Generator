
multipass launch --name Master1 -m 3G -d 20G -c 2

multipass launch --name Master2 -m 3G -d 20G -c 2

multipass launch --name Worker -m 3G -d 20G -c 2

multipass exec Master1 -- sudo snap install microk8s --classic
multipass exec Master2 -- sudo snap install microk8s --classic  
multipass exec Worker -- sudo snap install microk8s --classic

#./ClusterSetup.sh Worker Master1

#Configure Prometheus Init
#Add NodePort
#Set Microk8s Creditentials
#Create Liveness Checks
#newgrp microk8s
#   19  
#   20  source ~/.bashrc 
#      38  kubectl describe pod prometheus-prometheus-kube-prometheus-prometheus-0
#   39  vi NodePPrometheus.yaml
#   40  kubectl apply -f NodePPrometheus.yaml -n default
#sed -i -e $'$a\\\ alias kubectl=\'microk8s kubectl\'' ~/.bashrc
# source ~/.bashrc
#
#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#helm repo update
#helm install prometheus prometheus-community/kube-prometheus-stack