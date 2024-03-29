#!/usr/bin/bash
set -euxo pipefail
sudo useradd -d /home/${user} -m ${user}
echo '${user} ALL = (root) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/${user}
sudo chmod 0440 /etc/sudoers.d/${user}
sudo mkdir /home/${user}/.ssh
sudo cp /root/.ssh/authorized_keys /home/${user}/.ssh/authorized_keys
sudo chown -R ${user}:${user} /home/${user}
sudo chmod 0700 /home/${user}/.ssh
sudo chmod  600 /home/${user}/.ssh/authorized_keys

