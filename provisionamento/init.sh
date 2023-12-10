#!/bin/sh

USER_NAME=rkeoci

validateCommand() {
  if [ $? -eq 0 ]; then
    echo "[OK] $1"
  else
    echo "[ERROR] $1"
    exit 1
  fi
}

#Criando usuário
useradd -m -d /home/$USER_NAME -s /bin/bash $USER_NAME
echo "$USER_NAME@123" | passwd $USER_NAME --stdin
validateCommand "Usuário $USER_NAME criado"
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME
chown -R $USER_NAME:$USER_NAME /tmp
validateCommand "Adicionado usuário como owner da sua pasta home"
usermod -aG wheel $USER_NAME
validateCommand "Adicionado $USER_NAME como sudoer"

# Inserindo chave SSH
sudo test -f /home/$USER_NAME/.ssh/id_rsa
if [ $? -eq 1 ]; then
  sudo mkdir -p /home/$USER_NAME/.ssh/ && \
	  sudo cp /tmp/devsecops.pem /home/$USER_NAME/.ssh/id_rsa && \
	  sudo cp /tmp/devsecops.pub /home/$USER_NAME/.ssh/authorized_keys && \
	  sudo chmod 600 /home/$USER_NAME/.ssh/id_rsa
  
  validateCommand "Preparando SSH KEY"
else
  echo "[OK] SSH KEY"
fi