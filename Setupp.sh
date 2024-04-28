#!/bin/bash
function configureVms(){
    multipass launch --name $1 -m 3G -d 20G -c 2
    multipass exec $1 -- sudo snap install microk8s --classic
    multipass exec $1 -- sudo usermod -a -G microk8s ubuntu
    multipass exec $1 -- newgrp microk8s
    multipass exec $1 -- rm -rf .bashrc
    multipass transfer .bashrc $1:.bashrc
}

configureVms Master1
configureVms Master2
configureVms Worker
./joinNode.sh Worker Master1
./joinNode.sh Master2 Master1
./IPro.sh Master1


#Add NodePort
#Set Microk8s Creditentials
#Create Liveness Checks



