FROM ubuntu:18.04
LABEL maintainer="Graham Lillico"

# Update packages to the latest version
RUN apt-get update \
&& apt-get -y upgrade \
&& apt-get -y autoremove

# Install required packages.
# Remove packages that are nolonger requried.
# Clean the apt cache.
# Remove documents, man pages & apt files.
RUN apt-get install -y --no-install-recommends \
build-essential \
libffi-dev \
libssl-dev \
python \
python-dev \
python-pip \
python-setuptools \
python-wheel \
sudo \
systemd \
systemd-sysv \
&& apt-get -y autoremove \
&& apt-get -y clean \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc/* \
&& rm -rf /usr/share/man/*

# Install ansible.
RUN pip  --no-cache-dir install ansible

# Create ansible directory and copy ansible inventory file.
RUN mkdir /etc/ansible
COPY hosts /etc/ansible/hosts

# Stop systemd from spawning agettys on tty[1-6].
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

# Resolves high CPU usage while using molecule.
# See https://github.com/ansible/molecule/issues/1104 for details.
RUN rm -f /lib/systemd/system/systemd*udev* \
&& rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]