FROM centos:6
ENV JENKINS_UID 1000
ENV JENKINS_HOME /var/lib/jenkins_home
ENV SWARM_CLIENT_VERSION 2.0
ENV SWARM_CLIENT swarm-client-${SWARM_CLIENT_VERSION}-jar-with-dependencies.jar
ENV PYTHON_VERSION 2.7.11
RUN yum -y update && \
    yum -y install \
        gcc-c++ \
        rpm-build \
        ccache \
        openssh-clients \
        gettext \
        java-1.8.0-openjdk-headless \
        binutils-devel \
        libcurl-devel \
        expat-devel \
        glibc-static \
        ncurses-devel \
        ncurses-static \
        readline-devel \
        openssl-devel \
        zlib-devel \
        zlib-static \
        tcl-devel \
        python-devel \
        git \
        wget \
        libxslt \
        docbook-utils \
        docbook-dtds \
        docbook-xsl \
        bzip2-devel \
        tar \
        unzip

ADD https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz /tmp/Python-$PYTHON_VERSION.tgz
ADD http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$SWARM_CLIENT_VERSION/$SWARM_CLIENT $JENKINS_HOME/$SWARM_CLIENT

ENV ICU_PATH /opt/icu

COPY startup.sh /usr/bin/startup.sh
COPY setup-slave.sh /tmp/setup-slave.sh

# now that all dependencies are complete setup the slave
RUN /bin/sh /tmp/setup-slave.sh && rm -f /tmp/setup-slave.sh

USER jenkins_slave
ENTRYPOINT ["/usr/bin/startup.sh"]
