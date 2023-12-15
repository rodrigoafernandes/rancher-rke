infra/run:
	vagrant up
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.60 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.70 ls -lah
	ssh -i keys/devsecops.pem -o StrictHostKeyChecking=accept-new rkeoci@192.168.56.80 ls -lah
	ansible-playbook --inventory-file provisionamento/ansible/hosts.yml provisionamento/ansible/main.yml
	rke up --config provisionamento/ansible/roles/install_k8s_cluster/files/cluster.yml

infra/destroy:
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.60"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.70"
	ssh-keygen -f "/home/rodrigo/.ssh/known_hosts" -R "192.168.56.80"
	vagrant destroy -f