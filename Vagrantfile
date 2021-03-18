# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
# Variables
NOMAD_VERSION=1.0.4
CONSUL_VERSION=1.9.1
CNI_VERSION=v0.9.0

# Installing packages
sudo apt install -y openjdk-11-jre-headless openjdk-11-jdk-headless

echo "Installing Docker..."
sudo apt-get update
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

# Packages required for nomad & consul
sudo apt-get install unzip curl vim -y

echo "Installing CNI Plugins"
sudo mkdir -p /opt/cni/bin/
sudo mkdir -p /opt/cni/config/
sudo wget -O cni.tgz https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-v0.9.0.tgz
sudo tar -xzf cni.tgz -C /opt/cni/bin/

echo "Installing Nomad..."
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo install nomad /usr/bin/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d
sudo mkdir -p /opt/nomad/serverdata

# Write Server main config file
sudo cat <<-EOF > /etc/nomad.d/vagrant1.hcl
# Setup data dir
data_dir = "/opt/nomad/serverdata"

# Give the agent a unique name. Defaults to hostname
name = "vagrant1"

# Enable the server
server {
  enabled = true

  # Self-elect, should be 3 or 5 for production
  bootstrap_expect = 1
}
client {
  enabled       = true
  network_speed = 10
  host_network "public" {
    cidr = "10.0.2.0/24"
  }
  host_network "private" {
    cidr = "192.168.50.0/24"
  }
  cni_path = "/opt/cni/bin"
  cni_config_dir = "/opt/cni/config"
}


plugin "raw_exec" {
  config {
    enabled = true
  }
}

consul {
  address = "0.0.0.0:8500"
}

log_level = "TRACE"

EOF

# Create a syslog config file
(
cat <<-EOF
if \$programname == 'nomad' or \$syslogtag == 'nomad' then /var/log/nomad/nomad.log
& stop
EOF
) | sudo tee /etc/rsyslog.d/30-nomad.conf

#restart syslog
sudo systemctl restart rsyslog

# Setup Nomad for systemctl
(
cat <<-EOF
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=infinity
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
TasksMax=infinity

# make sure log directory exists and owned by syslog
PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /var/log/nomad
ExecStartPre=/usr/bin/touch /var/log/nomad/nomad.log
ExecStartPre=/bin/chown -R syslog:adm /var/log/nomad
ExecStartPre=/bin/chmod -R 755 /var/log/nomad
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=nomad

[Install]
WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service

# Enable the service
sudo systemctl enable nomad
sudo systemctl start nomad

# Configure Nomad Autocomplete
nomad -autocomplete-install
complete -C /usr/bin/nomad nomad

echo "########################"
echo "########################"
echo "########################"
echo "########################"
echo "########################"
echo "Installing Consul..."
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip
unzip /tmp/consul.zip
sudo install consul /usr/bin/consul
(
cat <<-EOF
  [Unit]
  Description=consul agent
  Requires=network-online.target
  After=network-online.target

  [Service]
  Restart=on-failure
  ExecStart=/usr/bin/consul agent -dev
  ExecReload=/bin/kill -HUP $MAINPID

  [Install]
  WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service
sudo systemctl enable consul.service
sudo systemctl start consul

for bin in cfssl cfssl-certinfo cfssljson
do
  echo "Installing $bin..."
  curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
  sudo install /tmp/${bin} /usr/local/bin/${bin}
done

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64" # 18.04 LTS
  config.vm.hostname = "nomad"
  config.vm.provision "shell", inline: $script, privileged: false

  config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true
  config.vm.network "forwarded_port", guest: 8800, host: 8800, auto_correct: true
  config.vm.network "forwarded_port", guest: 8500, host: 8500, auto_correct: true

  config.vm.network "forwarded_port", guest: 443, host: 443, auto_correct: true
  # Loki
  config.vm.network "forwarded_port", guest: 3100, host: 3100, auto_correct: true
  #Grafana
  config.vm.network "forwarded_port", guest: 10000, host: 10000, auto_correct: true
  #Promtail
  config.vm.network "forwarded_port", guest: 9080, host: 9080, auto_correct: true
  #Nomad
  config.vm.network "forwarded_port", guest: 4647, host: 4647, auto_correct: true
  # Expose the nomad api and ui to the host
  config.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.synced_folder '/Users/guy/dev/rookout/rookout-nomad-driver', '/opt/nomad/serverdata/plugins'


  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
  end
end
