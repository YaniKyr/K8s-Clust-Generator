#!/bin/bash

function addWorker(){
    temp=`multipass exec $2 -- sudo microk8s add-node | sed -n "s#microk8s join [0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*/[a-zA-Z0-9]*/[a-zA-Z0-9]*#\0#p"| grep  worker`
    multipass exec $1 -- sudo $temp
}

function addMaster(){
    temp=`multipass exec $2 -- sudo microk8s add-node | sed -n "s#microk8s join [0-9]*.[0-9]*.[0-9]*.[0-9]*:[0-9]*/[a-zA-Z0-9]*/[a-zA-Z0-9]*#\0#p"| grep -v worker | head -1`
    multipass exec $1 -- sudo $temp
}
#echo "$temp" | grep -v worker | head -1
#echo "$temp" | grep  worker

addWorker $1 $2
