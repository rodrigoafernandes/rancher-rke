infra/run:
	vagrant up
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.60 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.70 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.80 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.90 ls -lah
	ansible-playbook --inventory-file provisionamento/ansible/hosts.yml provisionamento/ansible/main.yml
	rke up --config provisionamento/ansible/roles/install_k8s_cluster/files/cluster.yml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/cloud/deploy.yaml
	kubectl apply -f provisionamento/ansible/roles/install_k8s_cluster/files/metrics_server.yaml
	kubectl apply -f provisionamento/ansible/roles/install_k8s_cluster/files/ip_address_pool.yaml
	kubectl apply -f provisionamento/ansible/roles/install_k8s_cluster/files/l2_advertisement.yaml

infra/destroy:
	rke remove --config provisionamento/ansible/roles/install_k8s_cluster/files/cluster.yml --force
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.60"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.70"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.80"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.90"
	vagrant destroy -f