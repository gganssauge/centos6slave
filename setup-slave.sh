#!/bin/sh
# Build locale used for message catalogs
locale-gen de_DE@euro || localedef --quiet -c -i de_DE -f ISO-8859-1 de_DE@euro

ccache=ccache-3.2.3.tar.xz
icu=icu4c-51_2-src.tgz 

# set timezone
cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# add our user
groupadd -g $JENKINS_UID jenkins_slave
useradd -d $JENKINS_HOME -s /bin/bash -m jenkins_slave -u $JENKINS_UID -g jenkins_slave
echo jenkins_slave:jpass | chpasswd

# make sure permissions are correct
chmod +x /usr/bin/startup.sh
chown -R $JENKINS_UID:$JENKINS_UID $JENKINS_HOME

mkdir -p /tmp/build
icuprefix=${ICU_PATH-/opt/icu51}

cd /tmp/build
wget -q http://samba.org/ftp/ccache/$ccache
tar xf $ccache
cd `basename $ccache .tar.xz`
./configure
make
make install

cd /tmp/build
wget -q http://download.icu-project.org/files/icu4c/51.2/$icu
tar xf $icu
cd icu/source
./configure --prefix=$icuprefix && make && make install
echo $icuprefix/lib > /etc/ld.so.conf.d/icu.conf
ldconfig

rm -rf /tmp/build

# compile python-2.7
cd /tmp
tar xf Python-$PYTHON_VERSION.tgz
cd Python-$PYTHON_VERSION
./configure
make all install
# add pip and virtualenv to the newly build python
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
/usr/local/bin/python get-pip.py
/usr/local/bin/pip install virtualenv

# add a virtualenv for build use
su jenkins_slave -c "virtualenv -p /usr/local/bin/python ~jenkins_slave/py"
su jenkins_slave -c "~jenkins_slave/py/bin/pip install sshed"
