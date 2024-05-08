#!/bin/bash
function configureVms(){
    echo $1
    multipass launch --name $1 -m 3G -d 20G -c 2 
    multipass exec $1 -- sudo snap install microk8s --classic
    multipass exec $1 -- sudo usermod -a -G microk8s ubuntu
    multipass restart $1
    multipass exec $1 -- sed -i -e $'$a\\\ alias kubectl=\'microk8s kubectl\'' .bashrc
    multipass exec $1 -- source .bashrc
}

function Services(){
    multipass exec $1 -- microk8s helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    multipass exec $1 -- microk8s helm repo update
    multipass exec $1 -- microk8s helm install prometheus prometheus-community/kube-prometheus-stack
    multipass exec $1 -- microk8s helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    multipass exec $1 -- microk8s helm repo update
    multipass exec $1 -- microk8s helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
}

function addWorker(){
    temp=`multipass exec $2 -- sudo microk8s add-node | sed -n "s#microk8s join [0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*/[a-zA-Z0-9]*/[a-zA-Z0-9]*#\0#p"| grep  worker`
    multipass exec $1 -- sudo $temp
}

function addMaster(){
    temp=`multipass exec $2 -- sudo microk8s add-node | sed -n "s#microk8s join [0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*/[a-zA-Z0-9]*/[a-zA-Z0-9]*#\0#p"| grep -v worker | head -1`
    multipass exec $1 -- sudo $temp
}

function InitVms(){
    configureVms $2
    configureVms $3
    configureVms $4

    if [ $1 = "-1M2W" ] ; then
        addWorker $4 $2
        addWorker $3 $2
    elif [ $1 = "-3M" ] ; then
        addMaster $4 $2
        addMaster $3 $2
    elif [ $1 = "-2M1W" ] ; then
        addWorker $4 $2
        addMaster $3 $2
    fi
    
    Services $2     
    multipass transfer NodePort.yaml $2:NodePort.yaml
    multipass transfer AuthRBAC.yaml $2:AuthRBAC.yaml
    multipass exec $2 -- kubectl apply -f NodePort.yaml 
    multipass exec $2 -- kubectl apply -f AuthRBAC.yaml 
}

InitVms $1 $2 $3 $4
