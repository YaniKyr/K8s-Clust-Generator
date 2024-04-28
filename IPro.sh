#!/bin/bash

multipass exec $1 -- microk8s helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
multipass exec $1 -- microk8s helm repo update
multipass exec $1 -- microk8s helm install prometheus prometheus-community/kube-prometheus-stack
multipass exec $1 -- microk8s helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
multipass exec $1 -- microk8s helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard