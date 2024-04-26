multipass exec $1 -- helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
multipass exec $1 -- helm repo update
multipass exec $1 -- helm install prometheus prometheus-community/kube-prometheus-stack