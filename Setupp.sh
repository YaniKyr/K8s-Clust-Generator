
multipass launch --name Master1 -m 3G -d 20G -c 2

multipass launch --name Master2 -m 3G -d 20G -c 2

multipass launch --name Worker -m 3G -d 20G -c 2

multipass exec Master1 -- sudo snap install microk8s --classic
#multipass exec Master2 -- sudo snap install microk8s --classic  
multipass exec Worker -- sudo snap install microk8s --classic

./ClusterSetup.sh Worker Master1

#Configure Prometheus Init
#Add NodePort
#Set Microk8s Creditentials
#Create Liveness Checks
