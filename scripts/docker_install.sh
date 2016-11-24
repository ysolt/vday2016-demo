cat <<'EOF'> /etc/yum.repos.d/dockerrepo.repo
[dockerrepo]
gpgcheck=0
key_url=https://yum.dockerproject.org/gpg
enabled=1
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
name=Docker Repository
EOF


yum install -y docker-engine
mkdir -p /etc/systemd/system/docker.service.d

cat <<'EOF' >/etc/systemd/system/docker.service.d/insecure-registry.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --insecure-registry 10.0.2.2:5000
EOF
systemctl daemon-reload
systemctl start docker
systemctl enable docker
