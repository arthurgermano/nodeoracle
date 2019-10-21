FROM debian:latest

# update packages
RUN apt update && apt upgrade -y

# Installing updated wget
RUN apt install -y wget curl python g++ make debpear php-dev libaio1

RUN wget -qO- http://raw.githubusercontent.com/creationix/nvm/v0.35.0/install.sh | bash \
&& export NVM_DIR="$HOME/.nvm" \
&& [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  \
&& [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
&& nvm install 12 \
&& nvm use 12 \
&& npm config set registry http://registry.npmjs.org \
&& npm config set unsafe-perm true \
&& npm install -g @vue/cli \
&& npm install -g pm2

# Install the Oracle Instant Client
COPY oracle/oracle-instantclient11.2-basiclite_11.2.0.4.0-2_amd64.deb /tmp
COPY oracle/oracle-instantclient11.2-devel_11.2.0.4.0-2_amd64.deb /tmp
COPY oracle/oracle-instantclient11.2-sqlplus_11.2.0.4.0-2_amd64.deb /tmp
COPY oci8-2.2.0.tgz /tmp
RUN dpkg -i /tmp/oracle-instantclient11.2-basiclite_11.2.0.4.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient11.2-devel_11.2.0.4.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient11.2-sqlplus_11.2.0.4.0-2_amd64.deb

# Setting ORACLE environment variables
ENV LD_LIBRARY_PATH /usr/lib/oracle/11.2/client64/lib/
ENV ORACLE_HOME /usr/lib/oracle/11.2/client64/lib/

# Compiling and installing oci8 driver
RUN echo 'instantclient,/usr/lib/oracle/11.2/client64/lib' | pecl install -f /tmp/oci8-2.2.0.tgz

# Removing unnecessary packages 
RUN apt remove debpear php-dev -y
RUN apt autoremove -y

# Removing everything from /tmp
RUN rm -rf /tmp/*

# Script to enable or delete proxy via command
COPY proxyscript.sh /tmp
RUN chmod 777 /tmp/proxyscript.sh
RUN echo 'alias enProxy="eval \"$(./tmp/proxyscript.sh)\""' >> ~/.bashrc
RUN echo 'alias delProxy="eval \"$(./tmp/proxyscript.sh delete)\""' >> ~/.bashrc

MAINTAINER Arthur Jose Germano <email@email.com>
