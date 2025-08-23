


cluster:
	k3d cluster delete k3s-default
	k3d cluster create k3s-default \
		--image "rancher/k3s:v1.33.3-k3s1" \
		--api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" -p "1022:22@loadbalancer" --servers 2 \
		--k3s-arg "--disable=traefik@server:*"
	kubectl create namespace argocd

argocd:
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.1.0/manifests/install.yaml

argo-proxy:
	@echo https://localhost:8080
	@echo admin
	@kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
	@kubectl -n argocd port-forward services/argocd-server 8080:80


all: cluster argocd