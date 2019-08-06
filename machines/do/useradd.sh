#!/usr/bin/bash
useradd -d /home/${user} -m ${user}
echo '${user} ALL = (root) NOPASSWD:ALL' | tee /etc/sudoers.d/${user}
"chmod 0440 /etc/sudoers.d/${user}
mkdir /home/${user}/.ssh
cp /root/.ssh/authorized_keys /home/${user}/.ssh/authorized_keys
chown -R ${user}:${user} /home/${user}
chmod 0700 /home/${user}/.ssh",
chmod  600 /home/${user}/.ssh/authorized_keys
