
multipass launch --name Master1 -m 3G -d 20G -c 2

multipass launch --name Master2 -m 3G -d 20G -c 2

multipass launch --name Worker -m 3G -d 20G -c 2


multipass exec Master1 -- sudo snap install microk8s --classic
multipass exec Master2 -- sudo snap install microk8s --classic  
multipass exec Worker -- sudo snap install microk8s --classic


./ClusterLaunch.sh Worker Master1
./ClusterLaunch.sh Master2 Master1